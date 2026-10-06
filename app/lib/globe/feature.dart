import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FeatureType { river, range, peak, area }

enum AreaKind { desert, forest, lake }

/// Nature on the globe, drawn the way a children's atlas draws it —
/// schematic, not surveyed (STORYTELLER_GLOBE_PLAN.md §2.3). Belongs to
/// no country: the Danube runs through ten of them.
///
/// The JSON carries a handful of points per feature; everything the
/// painter needs every frame (a smooth river line, where the mountains of
/// a range stand, where the trees of a forest grow) is worked out once
/// here.
class GeoFeature {
  GeoFeature._({
    required this.id,
    required this.type,
    required this.name,
    required this.minZoom,
    required this.pts,
    this.kind,
    this.sprite,
    this.scatter = const [],
  });

  final String id;
  final FeatureType type;
  final String name;

  /// Hidden below this zoom — the Vltava is noise on the whole globe.
  final double minZoom;

  /// Flattened `[lon, lat, …]` like country rings. River: the smoothed
  /// line. Range: where each mountain stands. Peak: the one point. Area:
  /// the outline, with long edges subdivided so they bend with the sphere.
  final List<double> pts;

  final AreaKind? kind;
  final String? sprite; // peaks: mountain | volcano | rock

  /// Areas: where dunes or trees are drawn inside the outline.
  final List<double> scatter;

  double get lon => pts[0];
  double get lat => pts[1];

  factory GeoFeature.fromJson(Map<String, dynamic> j) {
    final id = j['id'] as String;
    final type = FeatureType.values.byName(j['t'] as String);
    final raw = type == FeatureType.peak
        ? [(j['o'] as num).toDouble(), (j['a'] as num).toDouble()]
        : [
            for (final p in j['pts'] as List) ...[
              ((p as List)[0] as num).toDouble(),
              (p[1] as num).toDouble(),
            ],
          ];
    final kind = type == FeatureType.area
        ? AreaKind.values.byName(j['k'] as String)
        : null;
    final pts = switch (type) {
      FeatureType.river => _smooth(raw),
      FeatureType.range => _along(raw),
      FeatureType.peak => raw,
      FeatureType.area => _subdivide(raw, 4),
    };
    return GeoFeature._(
      id: id,
      type: type,
      name: j['n'] as String,
      minZoom: (j['z'] as num?)?.toDouble() ?? 1,
      pts: pts,
      kind: kind,
      sprite: j['s'] as String?,
      scatter: kind == null || kind == AreaKind.lake
          ? const []
          : _scatter(raw, math.Random(id.hashCode)),
    );
  }

  /// Point-in-polygon for areas; false for everything else.
  bool contains(double lon, double lat) =>
      type == FeatureType.area && _inside(pts, lon, lat);

  static bool _inside(List<double> ring, double lon, double lat) {
    var inside = false;
    final n = ring.length ~/ 2;
    for (var i = 0, j = n - 1; i < n; j = i++) {
      final xi = ring[i * 2],
          yi = ring[i * 2 + 1],
          xj = ring[j * 2],
          yj = ring[j * 2 + 1];
      if ((yi > lat) != (yj > lat) &&
          lon < (xj - xi) * (lat - yi) / (yj - yi) + xi) {
        inside = !inside;
      }
    }
    return inside;
  }

  /// Catmull-Rom through the authored points: a river that bends instead
  /// of a row of straight sticks.
  static List<double> _smooth(List<double> p) {
    final n = p.length ~/ 2;
    if (n < 3) return p;
    double x(int i) => p[i.clamp(0, n - 1) * 2];
    double y(int i) => p[i.clamp(0, n - 1) * 2 + 1];
    final out = <double>[];
    const steps = 6;
    for (var i = 0; i < n - 1; i++) {
      for (var s = 0; s < steps; s++) {
        final t = s / steps, t2 = t * t, t3 = t2 * t;
        double cr(double a, double b, double c, double d) =>
            0.5 *
            (2 * b +
                (c - a) * t +
                (2 * a - 5 * b + 4 * c - d) * t2 +
                (3 * b - a - 3 * c + d) * t3);
        out
          ..add(cr(x(i - 1), x(i), x(i + 1), x(i + 2)))
          ..add(cr(y(i - 1), y(i), y(i + 1), y(i + 2)));
      }
    }
    return out..addAll([x(n - 1), y(n - 1)]);
  }

  /// Points every couple of degrees along the line, each nudged a little
  /// off it so a range reads as mountains rather than as a dotted line.
  /// A short range (the Pyrenees) closes the spacing up instead of ending
  /// as two lonely peaks.
  static List<double> _along(List<double> p) {
    var total = 0.0;
    for (var i = 0; i + 3 < p.length; i += 2) {
      total += math.sqrt(math.pow(p[i + 2] - p[i], 2) + math.pow(p[i + 3] - p[i + 1], 2));
    }
    final step = math.min(2.2, total / 3.5);
    final out = <double>[];
    var carry = 0.0, k = 0;
    for (var i = 0; i + 3 < p.length; i += 2) {
      final dx = p[i + 2] - p[i], dy = p[i + 3] - p[i + 1];
      final len = math.sqrt(dx * dx + dy * dy);
      if (len == 0) continue;
      var d = carry;
      for (; d <= len; d += step) {
        final off = (k++).isEven ? 0.35 : -0.35;
        out
          ..add(p[i] + dx * d / len - dy / len * off)
          ..add(p[i + 1] + dy * d / len + dx / len * off);
      }
      carry = d - len; // how far into the next segment the next mountain stands
    }
    return out;
  }

  static List<double> _subdivide(List<double> p, double maxStep) {
    final out = <double>[];
    final n = p.length ~/ 2;
    for (var i = 0; i < n; i++) {
      final j = (i + 1) % n;
      final x0 = p[i * 2],
          y0 = p[i * 2 + 1],
          dx = p[j * 2] - x0,
          dy = p[j * 2 + 1] - y0;
      final parts = math.max(
        1,
        (math.sqrt(dx * dx + dy * dy) / maxStep).ceil(),
      );
      for (var s = 0; s < parts; s++) {
        out
          ..add(x0 + dx * s / parts)
          ..add(y0 + dy * s / parts);
      }
    }
    return out;
  }

  /// A jittered grid inside the outline — even enough to read as a
  /// texture, irregular enough not to read as wallpaper. Seeded by the
  /// feature id so the same dunes are there on every launch.
  static List<double> _scatter(List<double> ring, math.Random rng) {
    var minX = double.infinity,
        maxX = -double.infinity,
        minY = double.infinity,
        maxY = -double.infinity;
    for (var i = 0; i < ring.length; i += 2) {
      minX = math.min(minX, ring[i]);
      maxX = math.max(maxX, ring[i]);
      minY = math.min(minY, ring[i + 1]);
      maxY = math.max(maxY, ring[i + 1]);
    }
    // Small areas still get a few marks; big ones don't get hundreds.
    final cell = math.sqrt((maxX - minX) * (maxY - minY) / 60).clamp(1.2, 4.5);
    final out = <double>[];
    for (var y = minY + cell / 2; y < maxY; y += cell) {
      for (var x = minX + cell / 2; x < maxX; x += cell) {
        final px = x + (rng.nextDouble() - 0.5) * cell * 0.7,
            py = y + (rng.nextDouble() - 0.5) * cell * 0.7;
        if (_inside(ring, px, py)) {
          out
            ..add(px)
            ..add(py);
        }
      }
    }
    return out;
  }
}

class FeatureIndex {
  FeatureIndex(this.features);

  static final empty = FeatureIndex(const []);

  final List<GeoFeature> features;

  static Future<FeatureIndex> load() async {
    final list =
        jsonDecode(await rootBundle.loadString('assets/geo/features.json'))
            as List;
    return FeatureIndex([
      for (final j in list) GeoFeature.fromJson(j as Map<String, dynamic>),
    ]);
  }
}

final featureIndexProvider = FutureProvider<FeatureIndex>(
  (ref) => FeatureIndex.load(),
);
