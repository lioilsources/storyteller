import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A cluster of countries too small to tell apart on the whole globe
/// (STORYTELLER_GLOBE_PLAN.md §1.1): below [minZoom] the globe draws it as
/// one shape with one icon and names it as one place; tapping it flies in
/// to [zoomTo], where its countries are separate again.
///
/// Purely visual — packs and continents (`rag/rag/continents.py`) know
/// nothing about regions, and a story is still told from a country.
class Region {
  Region({
    required this.code,
    required this.name,
    required this.isos,
    required this.hero,
    required this.lon,
    required this.lat,
    required this.minZoom,
    required this.zoomTo,
  });

  final String code;
  final String name;
  final Set<String> isos;

  /// The country whose hero landmark stands for the whole region.
  final String hero;
  final double lon;
  final double lat;
  final double minZoom;
  final double zoomTo;

  factory Region.fromJson(Map<String, dynamic> j) => Region(
    code: j['code'] as String,
    name: j['n'] as String,
    isos: {for (final i in j['isos'] as List) i as String},
    hero: j['hero'] as String,
    lon: (j['o'] as num).toDouble(),
    lat: (j['a'] as num).toDouble(),
    minZoom: (j['minZoom'] as num).toDouble(),
    zoomTo: (j['zoomTo'] as num).toDouble(),
  );
}

class RegionIndex {
  RegionIndex(this.regions)
    : _byIso = {
        for (final r in regions)
          for (final i in r.isos) i: r,
      };

  static final empty = RegionIndex(const []);

  final List<Region> regions;
  final Map<String, Region> _byIso;

  Region? of(String iso) => _byIso[iso];

  /// The region [iso] is currently drawn as part of, or null when the
  /// view is close enough that the country stands on its own.
  Region? mergedAt(String iso, double zoom) {
    final r = _byIso[iso];
    return r != null && zoom < r.minZoom ? r : null;
  }

  static Future<RegionIndex> load() async {
    final list =
        jsonDecode(await rootBundle.loadString('assets/geo/regions.json'))
            as List;
    return RegionIndex([
      for (final j in list) Region.fromJson(j as Map<String, dynamic>),
    ]);
  }
}

/// A provider for the same reason as `countryIndexProvider`: widget tests
/// hand over an already-parsed index.
final regionIndexProvider = FutureProvider<RegionIndex>(
  (ref) => RegionIndex.load(),
);
