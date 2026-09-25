import 'dart:math' as math;
import 'dart:ui' show Offset;

/// Orthographic projection — the globe as seen from infinitely far
/// away, which is what makes it read as a ball rather than a map.
/// STORYTELLER_PLAN.md §1.1b offers this as the cheaper alternative to
/// a real 3D scene, and for a 360px sphere on a phone it is plenty.
///
/// [centerLat]/[centerLon] are the point facing the viewer — i.e. what
/// the child is "looking at". Rotating the globe moves these.
class GlobeProjection {
  const GlobeProjection({
    required this.centerLat,
    required this.centerLon,
    required this.radius,
    required this.center,
  });

  final double centerLat;
  final double centerLon;
  final double radius;
  final Offset center;

  static const _deg = math.pi / 180;

  /// Projects (lon, lat) to screen space. Returns null when the point
  /// is on the far side of the sphere and must not be drawn.
  Offset? project(double lon, double lat) {
    final phi = lat * _deg;
    final lambda = (lon - centerLon) * _deg;
    final phi0 = centerLat * _deg;

    final cosPhi = math.cos(phi), sinPhi = math.sin(phi);
    final cosPhi0 = math.cos(phi0), sinPhi0 = math.sin(phi0);
    final cosLambda = math.cos(lambda);

    // cos of the angular distance from the projection centre; negative
    // means the point has rotated around the back.
    final cosC = sinPhi0 * sinPhi + cosPhi0 * cosPhi * cosLambda;
    if (cosC < 0) return null;

    final x = radius * cosPhi * math.sin(lambda);
    final y = radius * (cosPhi0 * sinPhi - sinPhi0 * cosPhi * cosLambda);
    return Offset(center.dx + x, center.dy - y); // screen y grows downward
  }

  /// Screen point back to (lon, lat). Returns null when the point is
  /// outside the sphere's disc — a tap on empty background.
  ({double lon, double lat})? unproject(Offset p) {
    final x = p.dx - center.dx;
    final y = center.dy - p.dy;
    final rho = math.sqrt(x * x + y * y);
    if (rho > radius) return null;
    if (rho == 0) return (lon: centerLon, lat: centerLat);

    final c = math.asin((rho / radius).clamp(-1.0, 1.0));
    final sinC = math.sin(c), cosC = math.cos(c);
    final phi0 = centerLat * _deg;
    final sinPhi0 = math.sin(phi0), cosPhi0 = math.cos(phi0);

    final lat = math.asin((cosC * sinPhi0 + y * sinC * cosPhi0 / rho).clamp(-1.0, 1.0)) / _deg;
    final lon = centerLon + math.atan2(x * sinC, rho * cosC * cosPhi0 - y * sinC * sinPhi0) / _deg;
    return (lon: _wrapLon(lon), lat: lat);
  }

  /// True when (lon, lat) faces the viewer. Used to skip whole country
  /// rings before building their Path — at ~10k points a frame that
  /// culling is most of the win.
  bool isVisible(double lon, double lat) {
    final phi = lat * _deg, phi0 = centerLat * _deg, lambda = (lon - centerLon) * _deg;
    return math.sin(phi0) * math.sin(phi) + math.cos(phi0) * math.cos(phi) * math.cos(lambda) >= 0;
  }

  static double _wrapLon(double lon) {
    var l = (lon + 180) % 360;
    if (l < 0) l += 360;
    return l - 180;
  }
}
