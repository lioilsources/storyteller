import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../rag/rag_providers.dart';

/// One country on the globe, loaded from `assets/geo/countries.json`
/// (Natural Earth 110m, public domain, built by
/// `corpus/cmd/build-geo` — see STORYTELLER_PLAN.md §1.1b).
///
/// Rings are flattened `[lon, lat, lon, lat, …]` to keep the asset
/// small; nothing in the app ever needs them as objects.
class Country {
  Country({required this.iso, required this.name, required this.lat, required this.lon, required this.motifs, required this.tales, required this.rings});

  final String iso;
  final String name;
  final double lat;
  final double lon;

  /// How much of the corpus actually comes from here — `rag.extract`
  /// output, counted into the asset by `corpus/cmd/build-geo`. Zero
  /// means we have nothing from this country yet, which the globe
  /// shows as a faded landmass (§1.1b's "zamlžené" countries).
  final int motifs;
  final int tales;

  final List<List<double>> rings;

  /// How far, in degrees of arc, the country reaches from its centroid.
  /// Zoomed in, most of the world is off-screen; the painter skips every
  /// country whose centroid is farther from the view than this plus what
  /// the canvas can show, without touching its points.
  late final double reach = () {
    const deg = math.pi / 180;
    final sinA = math.sin(lat * deg), cosA = math.cos(lat * deg);
    var minCos = 1.0;
    for (final ring in rings) {
      for (var i = 0; i < ring.length; i += 2) {
        final c = sinA * math.sin(ring[i + 1] * deg) + cosA * math.cos(ring[i + 1] * deg) * math.cos((ring[i] - lon) * deg);
        if (c < minCos) minCos = c;
      }
    }
    return math.acos(minCos.clamp(-1.0, 1.0)) / deg;
  }();

  factory Country.fromJson(Map<String, dynamic> j) => Country(
        iso: j['i'] as String,
        name: j['n'] as String,
        lat: (j['a'] as num).toDouble(),
        lon: (j['o'] as num).toDouble(),
        motifs: (j['m'] as num?)?.toInt() ?? 0,
        tales: (j['t'] as num?)?.toInt() ?? 0,
        rings: [
          for (final r in j['p'] as List) [for (final v in r as List) (v as num).toDouble()],
        ],
      );

  /// Ray-casting point-in-polygon on raw lon/lat.
  ///
  /// Good enough for every country the corpus actually covers. It is
  /// wrong for the handful whose geometry crosses the antimeridian
  /// (Russia, Fiji, Kiribati): their rings wrap from +180 to -180 and a
  /// flat test can't see that. Landing on those falls through to the
  /// nearest-centroid match in [CountryIndex.at], which puts you
  /// somewhere sensible rather than nowhere.
  bool contains(double testLon, double testLat) {
    for (final ring in rings) {
      var inside = false;
      final n = ring.length ~/ 2;
      for (var i = 0, j = n - 1; i < n; j = i++) {
        final xi = ring[i * 2], yi = ring[i * 2 + 1];
        final xj = ring[j * 2], yj = ring[j * 2 + 1];
        if ((yi > testLat) != (yj > testLat) && testLon < (xj - xi) * (testLat - yi) / (yj - yi) + xi) {
          inside = !inside;
        }
      }
      if (inside) return true;
    }
    return false;
  }
}

/// All countries plus the lookups the globe needs.
class CountryIndex {
  CountryIndex(this.countries) : byIso = {for (final c in countries) c.iso: c};

  final List<Country> countries;
  final Map<String, Country> byIso;

  static Future<CountryIndex> load() async {
    final raw = await rootBundle.loadString('assets/geo/countries.json');
    final list = jsonDecode(raw) as List;
    return CountryIndex([for (final j in list) Country.fromJson(j as Map<String, dynamic>)]);
  }

  /// The country at (lon, lat), or null when that point is open ocean.
  ///
  /// Tries real polygon containment first. If nothing contains the
  /// point — ocean, or one of the antimeridian-crossing shapes the flat
  /// test can't handle — falls back to the nearest centroid within
  /// [oceanSnapDegrees], which is the plan's "ocean → nearest country"
  /// rule (§1.1b). Beyond that it really is open sea and returns null.
  Country? at(double lon, double lat, {double oceanSnapDegrees = 12}) {
    for (final c in countries) {
      if (c.contains(lon, lat)) return c;
    }
    Country? best;
    var bestDist = double.infinity;
    for (final c in countries) {
      var dLon = (c.lon - lon).abs();
      if (dLon > 180) dLon = 360 - dLon; // shortest way round
      // Longitude degrees shrink toward the poles; without this a point
      // near the arctic snaps to whatever is far east/west of it.
      final scaledLon = dLon * _cosLat(lat);
      final dLat = c.lat - lat;
      final dist = scaledLon * scaledLon + dLat * dLat;
      if (dist < bestDist) {
        bestDist = dist;
        best = c;
      }
    }
    return bestDist <= oceanSnapDegrees * oceanSnapDegrees ? best : null;
  }

  static double _cosLat(double lat) {
    final c = math.cos(lat * math.pi / 180).abs();
    return c < 0.05 ? 0.05 : c; // clamp so the poles don't collapse the metric
  }
}

/// The geo asset, parsed once per app run instead of per screen — it's
/// 114 KB of JSON and ~10k points, and the library/back-office screens
/// will want the same lookups.
///
/// It's a provider rather than a plain `Future` in `initState` so that
/// widget tests can hand the globe an already-parsed index: real asset
/// I/O never completes inside `testWidgets`' fake-async zone, so a
/// screen that loads it itself can only ever be pumped in its loading
/// state.
final countryIndexProvider = FutureProvider<CountryIndex>((ref) => CountryIndex.load());

/// Which countries the corpus actually has motifs from. Derived here so
/// the set keeps one stable identity across rebuilds — `GlobePainter`
/// compares it by reference to decide whether to repaint.
///
/// Also every country a RAG pack can serve (lib/rag/): motifs there only
/// count once `rag.verbalize` has given them a Czech title, so a country
/// turns green exactly when the pickers have something to show from it.
final coveredCountriesProvider = Provider<Set<String>>((ref) {
  final index = ref.watch(countryIndexProvider).value;
  if (index == null) return const {};
  final pack = ref.watch(packMotifCountsProvider);
  return {for (final c in index.countries) if (c.motifs > 0 || (pack[c.iso] ?? 0) > 0) c.iso};
});
