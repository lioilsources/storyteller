import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'country.dart';
import 'feature.dart';
import 'globe_icons.dart';
import 'globe_projection.dart';
import 'region.dart';

/// Paints the globe: ocean disc, land, nature, the icons, and the country
/// (or merged region) currently under the centre of view.
///
/// Countries the corpus has motifs for are drawn in full colour;
/// everything else is faded — the plan's "země bez packu jsou lehce
/// zamlžené" (§1.1b), here doing double duty as an honest coverage map
/// of what has actually been extracted so far.
///
/// [zoom] scales the sphere past the canvas (STORYTELLER_GLOBE_PLAN.md
/// §1.2); what falls outside is clipped, and countries that can't reach
/// the canvas are skipped before any of their points are projected.
class GlobePainter extends CustomPainter {
  GlobePainter({
    required this.index,
    required this.centerLat,
    required this.centerLon,
    required this.highlightIso,
    required this.coveredIsos,
    this.pendingIsos = const {},
    this.zoom = 1,
    RegionIndex? regions,
    FeatureIndex? features,
    this.icons = const [],
    this.atlas,
  }) : regions = regions ?? RegionIndex.empty,
       features = features ?? FeatureIndex.empty;

  final CountryIndex index;
  final double centerLat;
  final double centerLon;
  final String? highlightIso;
  final Set<String> coveredIsos;

  /// Countries the packs have tales from that aren't on the device yet
  /// (a part to download or buy, or tales still waiting for one): a
  /// paler green than [coveredIsos], so the globe shows where there is
  /// more to come.
  final Set<String> pendingIsos;
  final double zoom;
  final RegionIndex regions;
  final FeatureIndex features;
  final List<PlacedIcon> icons;
  final SpriteAtlas? atlas;

  /// Country paths built by the last paint — tests read it to check that
  /// zooming in really stops the painter walking the whole world.
  static int debugPathsBuilt = 0;

  static const _ocean = Color(0xFFBBDEFB);
  static const _oceanDeep = Color(0xFF64B5F6);
  static const _landCovered = Color(0xFF81C784);
  static const _landPending = Color(0xFFCFE8C4);
  static const _landEmpty = Color(0xFFD7CCC8);

  Color _land(String iso) => coveredIsos.contains(iso)
      ? _landCovered
      : pendingIsos.contains(iso)
      ? _landPending
      : _landEmpty;
  static const _landStroke = Color(0x33000000);
  static const _regionStroke = Color(0x8A3E2723);
  static const _highlight = Color(0xFFFFB300);
  static const _highlightStroke = Color(0xFF5D4037);
  static const _sand = Color(0xD9F3DDA4);
  static const _dune = Color(0xFFD9A85B);
  static const _jungle = Color(0xB843A047);
  static const _tree = Color(0xFF2E7D32);
  static const _water = Color(0xFF64B5F6);
  static const _river = Color(0xFF4A9FE0);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2 - 8) * zoom;
    final proj = GlobeProjection(
      centerLat: centerLat,
      centerLon: centerLon,
      radius: radius,
      center: center,
    );

    canvas.save();
    canvas.clipRect(Offset.zero & size);

    // Ocean, shaded so the sphere reads as round rather than as a disc.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 0.95,
          colors: const [_ocean, _oceanDeep],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    // How far from the centre of view anything on the canvas can be.
    final corner = size.longestSide / 2 * math.sqrt2;
    final viewReach = corner >= radius
        ? 90.0
        : math.asin(corner / radius) * 180 / math.pi;

    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = _landStroke;
    final regionStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.6
      ..color = _regionStroke;

    final highlightRegion = highlightIso == null
        ? null
        : regions.mergedAt(highlightIso!, zoom);
    final merged = <Region, List<(Country, Path)>>{};
    Path? highlightPath;
    var built = 0;
    for (final country in index.countries) {
      final away =
          math.acos(proj.cosC(country.lon, country.lat).clamp(-1.0, 1.0)) *
          180 /
          math.pi;
      if (away > viewReach + country.reach) continue;
      final path = _pathFor(country, proj);
      if (path == null) continue;
      built++;
      final region = regions.mergedAt(country.iso, zoom);
      if (region != null) {
        (merged[region] ??= []).add((
          country,
          path,
        )); // drawn below, as one shape
        continue;
      }
      if (country.iso == highlightIso) {
        highlightPath = path; // drawn last so it sits on top of its neighbours
        continue;
      }
      fill.color = _land(country.iso);
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
    }
    debugPathsBuilt = built;

    // A merged region is one shape with no borders inside it. Stroking
    // every member thickly and then filling them all leaves the stroke
    // showing only along the region's outer edge — a union without
    // computing one. The fill stays per country, so the region still
    // tells the truth about which of its countries have tales.
    for (final MapEntry(key: region, value: members) in merged.entries) {
      final lit = region == highlightRegion;
      if (lit) continue;
      for (final (_, path) in members) {
        canvas.drawPath(path, regionStroke);
      }
      for (final (country, path) in members) {
        canvas.drawPath(
          path,
          fill..color = _land(country.iso),
        );
      }
    }
    if (highlightRegion != null) {
      final members = merged[highlightRegion] ?? const [];
      final rim = Paint()
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 4
        ..color = _highlightStroke;
      for (final (_, path) in members) {
        canvas.drawPath(path, rim);
      }
      // Covered and empty members stay two shades apart under the glow.
      for (final (country, path) in members) {
        canvas.drawPath(
          path,
          fill
            ..color = coveredIsos.contains(country.iso)
                ? _highlight
                : const Color(0xFFFFD98A),
        );
      }
    }

    if (highlightPath != null) {
      canvas.drawPath(highlightPath, fill..color = _highlight);
      canvas.drawPath(
        highlightPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = _highlightStroke,
      );
    }

    _paintNature(canvas, proj);

    for (final icon in icons) {
      paintSprite(canvas, icon, atlas);
    }

    // Soft limb shading — a rim that darkens toward the edge sells the
    // curvature far more cheaply than any lighting model would.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: const [
            Color(0x00000000),
            Color(0x00000000),
            Color(0x33000000),
          ],
          stops: const [0.0, 0.82, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.restore();
  }

  /// Deserts, forests and lakes first, rivers over them, mountains on
  /// top — the order a child would colour them in.
  void _paintNature(Canvas canvas, GlobeProjection proj) {
    final shown = [
      for (final f in features.features)
        if (zoom >= f.minZoom && f.type != FeatureType.peak) f,
    ];
    final mark = (2.6 * math.pow(zoom, 0.55)).clamp(2.6, 9.0).toDouble();

    for (final f in shown.where((f) => f.type == FeatureType.area)) {
      final path = _ringPath(f.pts, proj, close: true);
      if (path == null) continue;
      switch (f.kind!) {
        case AreaKind.lake:
          canvas.drawPath(path, Paint()..color = _water);
          canvas.drawPath(
            path,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.8
              ..color = _river,
          );
        case AreaKind.desert:
          canvas.drawPath(path, Paint()..color = _sand);
          final dune = Paint()
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeWidth = mark * 0.36
            ..color = _dune;
          for (var i = 0; i < f.scatter.length; i += 2) {
            final p = proj.project(f.scatter[i], f.scatter[i + 1]);
            if (p == null) continue;
            canvas.drawArc(
              Rect.fromCenter(center: p, width: mark * 2.2, height: mark * 1.6),
              math.pi,
              math.pi,
              false,
              dune,
            );
          }
        case AreaKind.forest:
          canvas.drawPath(path, Paint()..color = _jungle);
          final crown = Paint()..color = _tree;
          for (var i = 0; i < f.scatter.length; i += 2) {
            final p = proj.project(f.scatter[i], f.scatter[i + 1]);
            if (p == null) continue;
            canvas.drawCircle(p, mark * 0.8, crown);
            canvas.drawCircle(
              p + Offset(-mark * 0.25, -mark * 0.25),
              mark * 0.3,
              Paint()..color = const Color(0x66FFFFFF),
            );
          }
      }
    }

    final river = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = (1.5 * math.sqrt(zoom)).clamp(1.5, 4.5).toDouble()
      ..color = _river;
    for (final f in shown.where((f) => f.type == FeatureType.river)) {
      final path = _ringPath(f.pts, proj, close: false);
      if (path != null) canvas.drawPath(path, river);
    }

    final s = (7 * math.pow(zoom, 0.6)).clamp(7.0, 24.0).toDouble();
    final rock = Paint()..color = const Color(0xFF8E8EA0);
    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFF55556A);
    final snow = Paint()..color = Colors.white;
    for (final f in shown.where((f) => f.type == FeatureType.range)) {
      // On the whole globe every second mountain is enough to say "range".
      final step = zoom < 1.6 ? 4 : 2;
      for (var i = 0; i < f.pts.length; i += step) {
        final p = proj.project(f.pts[i], f.pts[i + 1]);
        if (p == null || proj.cosC(f.pts[i], f.pts[i + 1]) < 0.15) continue;
        final peak = Path()
          ..moveTo(p.dx - s * 0.6, p.dy + s * 0.35)
          ..lineTo(p.dx, p.dy - s * 0.65)
          ..lineTo(p.dx + s * 0.6, p.dy + s * 0.35)
          ..close();
        canvas.drawPath(peak, rock);
        canvas.drawPath(peak, rim);
        canvas.drawPath(
          Path()
            ..moveTo(p.dx, p.dy - s * 0.65)
            ..lineTo(p.dx - s * 0.22, p.dy - s * 0.28)
            ..lineTo(p.dx + s * 0.22, p.dy - s * 0.28)
            ..close(),
          snow,
        );
      }
    }
  }

  /// Builds a country's screen path, or null if none of it faces the
  /// viewer. Rings are clipped by dropping back-facing points, which
  /// leaves a straight chord along the limb — invisible at this size
  /// and far cheaper than true sphere-edge clipping.
  Path? _pathFor(Country country, GlobeProjection proj) {
    Path? path;
    for (final ring in country.rings) {
      final ringPath = _ringPath(ring, proj, close: true);
      if (ringPath != null) {
        path ??= Path();
        path.addPath(ringPath, Offset.zero);
      }
    }
    return path;
  }

  Path? _ringPath(
    List<double> ring,
    GlobeProjection proj, {
    required bool close,
  }) {
    final n = ring.length ~/ 2;
    var started = false;
    Path? ringPath;
    for (var i = 0; i < n; i++) {
      final p = proj.project(ring[i * 2], ring[i * 2 + 1]);
      if (p == null) {
        started = false; // hop over the back side and resume on the far edge
        continue;
      }
      ringPath ??= Path();
      if (!started) {
        ringPath.moveTo(p.dx, p.dy);
        started = true;
      } else {
        ringPath.lineTo(p.dx, p.dy);
      }
    }
    if (close) ringPath?.close();
    return ringPath;
  }

  @override
  bool shouldRepaint(GlobePainter old) =>
      old.centerLat != centerLat ||
      old.centerLon != centerLon ||
      old.zoom != zoom ||
      old.highlightIso != highlightIso ||
      old.coveredIsos != coveredIsos ||
      old.pendingIsos != pendingIsos ||
      old.regions != regions ||
      old.features != features ||
      old.icons != icons ||
      old.atlas != atlas;
}
