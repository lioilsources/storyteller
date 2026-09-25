import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'country.dart';
import 'globe_projection.dart';

/// Paints the globe: ocean disc, land, and the country currently under
/// the centre of view.
///
/// Countries the corpus has motifs for are drawn in full colour;
/// everything else is faded — the plan's "země bez packu jsou lehce
/// zamlžené" (§1.1b), here doing double duty as an honest coverage map
/// of what has actually been extracted so far.
class GlobePainter extends CustomPainter {
  GlobePainter({
    required this.index,
    required this.centerLat,
    required this.centerLon,
    required this.highlightIso,
    required this.coveredIsos,
  });

  final CountryIndex index;
  final double centerLat;
  final double centerLon;
  final String? highlightIso;
  final Set<String> coveredIsos;

  static const _ocean = Color(0xFFBBDEFB);
  static const _oceanDeep = Color(0xFF64B5F6);
  static const _landCovered = Color(0xFF81C784);
  static const _landEmpty = Color(0xFFD7CCC8);
  static const _landStroke = Color(0x33000000);
  static const _highlight = Color(0xFFFFB300);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final proj = GlobeProjection(centerLat: centerLat, centerLon: centerLon, radius: radius, center: center);

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

    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6
      ..color = _landStroke;

    Path? highlightPath;
    for (final country in index.countries) {
      final path = _pathFor(country, proj);
      if (path == null) continue;
      if (country.iso == highlightIso) {
        highlightPath = path; // drawn last so it sits on top of its neighbours
        continue;
      }
      fill.color = coveredIsos.contains(country.iso) ? _landCovered : _landEmpty;
      canvas.drawPath(path, fill);
      canvas.drawPath(path, stroke);
    }

    if (highlightPath != null) {
      canvas.drawPath(highlightPath, fill..color = _highlight);
      canvas.drawPath(
        highlightPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = const Color(0xFF5D4037),
      );
    }

    // Soft limb shading — a rim that darkens toward the edge sells the
    // curvature far more cheaply than any lighting model would.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0x00000000), Color(0x00000000), Color(0x33000000)],
          stops: const [0.0, 0.82, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  /// Builds a country's screen path, or null if none of it faces the
  /// viewer. Rings are clipped by dropping back-facing points, which
  /// leaves a straight chord along the limb — invisible at this size
  /// and far cheaper than true sphere-edge clipping.
  Path? _pathFor(Country country, GlobeProjection proj) {
    Path? path;
    for (final ring in country.rings) {
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
      if (ringPath != null) {
        ringPath.close();
        path ??= Path();
        path.addPath(ringPath, Offset.zero);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(GlobePainter old) =>
      old.centerLat != centerLat ||
      old.centerLon != centerLon ||
      old.highlightIso != highlightIso ||
      old.coveredIsos != coveredIsos;
}
