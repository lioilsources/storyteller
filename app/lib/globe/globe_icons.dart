import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'feature.dart';
import 'globe_projection.dart';
import 'landmark.dart';
import 'region.dart';

/// One icon the globe decided to draw this frame, and where. The screen
/// lays icons out once per build and hands the same list to the painter
/// and to its own tap handler, so what you can hit is exactly what you
/// can see.
class PlacedIcon {
  const PlacedIcon({
    required this.rect,
    required this.sprite,
    required this.name,
    required this.lon,
    required this.lat,
    required this.depth,
    this.iso,
    this.region,
    this.nature = false,
  });

  final Rect rect;
  final String sprite;
  final String name;
  final double lon;
  final double lat;

  /// 1 dead centre, falling to 0 at the limb — icons near the edge fade.
  final double depth;
  final String? iso; // landmarks: the country it stands in
  final Region? region; // set when this icon stands for a whole merged region
  final bool nature; // a peak rather than a building
}

/// Decides which icons are drawn (STORYTELLER_GLOBE_PLAN.md §1.3, §4).
///
/// Icons are billboards: only the anchor is projected, the picture stays
/// upright and stands on it. Where two would overlap, the more important
/// one wins and the other waits for a closer zoom — which is the whole
/// reason there is a zoom.
List<PlacedIcon> layoutIcons({
  required GlobeProjection proj,
  required Size size,
  required double zoom,
  required LandmarkIndex landmarks,
  required FeatureIndex features,
  required RegionIndex regions,
  String? focusIso,
}) {
  final canvas = (Offset.zero & size).inflate(8);
  final base = (22 * math.pow(zoom, 0.42)).clamp(22.0, 52.0).toDouble();
  final candidates = <(double rank, PlacedIcon icon)>[];

  void add(
    double lon,
    double lat,
    double scale,
    double rank,
    PlacedIcon Function(Rect rect, double depth) make,
  ) {
    final depth = proj.cosC(lon, lat);
    if (depth < 0.2) return; // too close to the limb to stand upright
    final p = proj.project(lon, lat)!;
    final s = base * scale * (0.55 + 0.45 * depth);
    final rect = Rect.fromLTWH(p.dx - s / 2, p.dy - s * 0.85, s, s);
    if (!rect.overlaps(canvas)) return;
    candidates.add((rank + depth, make(rect, depth)));
  }

  for (final l in landmarks.landmarks) {
    final merged = regions.mergedAt(l.iso, zoom);
    if (merged != null) {
      // A merged region shows one icon: its hero country's hero.
      if (l.iso != merged.hero || landmarks.heroOf(l.iso) != l) continue;
      add(
        l.lon,
        l.lat,
        1.5,
        100,
        (rect, depth) => PlacedIcon(
          rect: rect,
          sprite: l.sprite,
          name: l.name,
          lon: l.lon,
          lat: l.lat,
          depth: depth,
          iso: l.iso,
          region: merged,
        ),
      );
      continue;
    }
    if (l.priority == 1 && zoom < 2) {
      continue; // second landmarks only once there is room
    }
    add(
      l.lon,
      l.lat,
      l.priority == 3 ? 1.15 : 1,
      // The country under the centre always shows its own landmark,
      // whatever its neighbours would rather put there.
      l.priority * 10 + (l.iso == focusIso && landmarks.heroOf(l.iso) == l ? 50 : 0),
      (rect, depth) => PlacedIcon(
        rect: rect,
        sprite: l.sprite,
        name: l.name,
        lon: l.lon,
        lat: l.lat,
        depth: depth,
        iso: l.iso,
      ),
    );
  }
  for (final f in features.features) {
    if (f.type != FeatureType.peak || zoom < f.minZoom) continue;
    add(
      f.lon,
      f.lat,
      0.85,
      15,
      (rect, depth) => PlacedIcon(
        rect: rect,
        sprite: f.sprite ?? 'mountain',
        name: f.name,
        lon: f.lon,
        lat: f.lat,
        depth: depth,
        nature: true,
      ),
    );
  }

  candidates.sort((a, b) => b.$1.compareTo(a.$1));
  final placed = <PlacedIcon>[];
  for (final (_, icon) in candidates) {
    // A little overlap is fine — stickers on a globe do touch.
    final body = icon.rect.deflate(icon.rect.width * 0.05);
    if (placed.any((p) => p.rect.deflate(p.rect.width * 0.05).overlaps(body))) {
      continue;
    }
    placed.add(icon);
  }
  // Painted back to front, so a nearer icon overlaps a farther one.
  return placed..sort((a, b) => a.rect.bottom.compareTo(b.rect.bottom));
}

/// Rendered sticker art for the icons, when the `globe.icons` pack has
/// them (STORYTELLER_GLOBE_PLAN.md §6). Any sprite it lacks falls back to
/// a drawn placeholder, so the globe works before the art exists and for
/// a landmark the pack hasn't caught up with.
class SpriteAtlas {
  const SpriteAtlas(this.image, this.rects);

  final ui.Image image;
  final Map<String, Rect> rects;
}

final _iconPaint = Paint()..filterQuality = FilterQuality.medium;

void paintSprite(Canvas canvas, PlacedIcon icon, SpriteAtlas? atlas) {
  final opacity = (0.35 + 0.65 * ((icon.depth - 0.2) / 0.35).clamp(0.0, 1.0))
      .toDouble();
  final src = atlas?.rects[icon.sprite];
  if (src != null) {
    canvas.drawImageRect(
      atlas!.image,
      src,
      icon.rect,
      _iconPaint..color = Color.fromRGBO(0, 0, 0, opacity),
    );
    return;
  }
  canvas.save();
  canvas.translate(icon.rect.left, icon.rect.top);
  canvas.scale(icon.rect.width / 100);
  if (opacity < 1) {
    canvas.saveLayer(
      const Rect.fromLTWH(-10, -10, 120, 120),
      Paint()..color = Color.fromRGBO(0, 0, 0, opacity),
    );
  }
  switch (icon.sprite) {
    case 'mountain':
      _mountain(canvas);
    case 'volcano':
      _volcano(canvas);
    case 'rock':
      _rock(canvas);
    default:
      _building(canvas, icon.sprite.hashCode);
  }
  if (opacity < 1) canvas.restore();
  canvas.restore();
}

// Placeholder stickers, drawn in a 100×100 box standing on y = 85 (the
// anchor). Each is a white-rimmed shape, the look the rendered art will
// have, so layout and collisions are judged on the right silhouette.

const _ink = Color(0xFF4E342E);

void _sticker(Canvas canvas, Path shape, Color fill) {
  canvas.drawPath(
    shape,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white,
  );
  canvas.drawPath(shape, Paint()..color = fill);
  canvas.drawPath(
    shape,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeJoin = StrokeJoin.round
      ..color = _ink,
  );
}

void _mountain(Canvas canvas) {
  final body = Path()
    ..moveTo(6, 85)
    ..lineTo(38, 26)
    ..lineTo(52, 48)
    ..lineTo(66, 34)
    ..lineTo(94, 85)
    ..close();
  _sticker(canvas, body, const Color(0xFF9E9EAE));
  final snow = Path()
    ..moveTo(38, 26)
    ..lineTo(27, 46)
    ..lineTo(36, 42)
    ..lineTo(42, 50)
    ..lineTo(48, 42)
    ..close();
  canvas.drawPath(snow, Paint()..color = Colors.white);
}

void _volcano(Canvas canvas) {
  canvas.drawCircle(
    const Offset(58, 12),
    9,
    Paint()..color = const Color(0xFFE0E0E0),
  );
  canvas.drawCircle(
    const Offset(46, 20),
    7,
    Paint()..color = const Color(0xFFEEEEEE),
  );
  final body = Path()
    ..moveTo(6, 85)
    ..lineTo(38, 32)
    ..lineTo(62, 32)
    ..lineTo(94, 85)
    ..close();
  _sticker(canvas, body, const Color(0xFF8D6E63));
  final lava = Path()
    ..moveTo(38, 32)
    ..lineTo(62, 32)
    ..lineTo(57, 48)
    ..lineTo(50, 40)
    ..lineTo(44, 52)
    ..close();
  canvas.drawPath(lava, Paint()..color = const Color(0xFFFF7043));
}

void _rock(Canvas canvas) {
  final body = Path()
    ..moveTo(6, 85)
    ..quadraticBezierTo(14, 44, 34, 42)
    ..lineTo(68, 42)
    ..quadraticBezierTo(88, 46, 94, 85)
    ..close();
  _sticker(canvas, body, const Color(0xFFD9764A));
}

const _buildingColors = [
  Color(0xFFFFCC80),
  Color(0xFFEF9A9A),
  Color(0xFFB39DDB),
  Color(0xFF90CAF9),
  Color(0xFFFFF59D),
  Color(0xFFBCAAA4),
];

void _building(Canvas canvas, int seed) {
  final h = seed & 0x7fffffff;
  final fill = _buildingColors[h % _buildingColors.length];
  final Path shape;
  switch ((h ~/ 7) % 5) {
    case 0: // tower
      shape = Path()
        ..moveTo(34, 85)
        ..lineTo(42, 30)
        ..lineTo(50, 6)
        ..lineTo(58, 30)
        ..lineTo(66, 85)
        ..close();
    case 1: // dome
      shape = Path()
        ..moveTo(14, 85)
        ..lineTo(14, 52)
        ..quadraticBezierTo(50, -4, 86, 52)
        ..lineTo(86, 85)
        ..close();
    case 2: // castle
      shape = Path()
        ..moveTo(10, 85)
        ..lineTo(10, 30)
        ..lineTo(24, 30)
        ..lineTo(24, 44)
        ..lineTo(40, 44)
        ..lineTo(40, 18)
        ..lineTo(60, 18)
        ..lineTo(60, 44)
        ..lineTo(76, 44)
        ..lineTo(76, 30)
        ..lineTo(90, 30)
        ..lineTo(90, 85)
        ..close();
    case 3: // temple
      shape = Path()
        ..moveTo(12, 85)
        ..lineTo(12, 46)
        ..lineTo(4, 46)
        ..lineTo(50, 14)
        ..lineTo(96, 46)
        ..lineTo(88, 46)
        ..lineTo(88, 85)
        ..close();
    default: // house with a steep roof
      shape = Path()
        ..moveTo(18, 85)
        ..lineTo(18, 50)
        ..lineTo(50, 14)
        ..lineTo(82, 50)
        ..lineTo(82, 85)
        ..close();
  }
  _sticker(canvas, shape, fill);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(43, 62, 14, 23),
      const Radius.circular(6),
    ),
    Paint()..color = _ink,
  );
}
