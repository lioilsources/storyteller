import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/globe/feature.dart';

import 'globe_entry.dart';

/// The hand-authored globe data (STORYTELLER_GLOBE_PLAN.md §2). A typo in
/// one of these files doesn't crash anything — an icon just never shows,
/// or a region silently loses a country — so the checks live here.
/// `tool/check_landmarks.py` covers the geometry of the landmark anchors.
void main() {
  test('every country has exactly one landmark that stands for it', () async {
    final index = await geo();
    final landmarks = (await geoExtras()).landmarks;
    for (final l in landmarks.landmarks) {
      expect(index.byIso[l.iso], isNotNull, reason: '${l.id}: no country ${l.iso}');
      expect(l.name, isNotEmpty, reason: l.id);
    }
    expect({for (final l in landmarks.landmarks) l.id}.length, landmarks.landmarks.length, reason: 'duplicate landmark id');
    for (final c in index.countries) {
      final hero = landmarks.heroOf(c.iso);
      expect(hero, isNotNull, reason: '${c.iso} ${c.name} has no landmark');
      final rivals = landmarks.landmarks.where((l) => l.iso == c.iso && l.priority == hero!.priority);
      expect(rivals.length, 1, reason: '${c.iso}: ${rivals.map((l) => l.id)} tie for hero');
    }
  });

  test('regions are made of real countries, each in one region at most', () async {
    final index = await geo();
    final extras = await geoExtras();
    final seen = <String, String>{};
    for (final r in extras.regions.regions) {
      expect(r.isos, contains(r.hero), reason: '${r.code}: hero ${r.hero} is not a member');
      expect(extras.landmarks.heroOf(r.hero), isNotNull, reason: '${r.code}: hero country has no landmark');
      expect(r.zoomTo, greaterThanOrEqualTo(r.minZoom), reason: '${r.code}: flying in must be enough to un-merge it');
      for (final iso in r.isos) {
        expect(index.byIso[iso], isNotNull, reason: '${r.code}: no country $iso');
        expect(seen[iso], isNull, reason: '$iso is in ${seen[iso]} and ${r.code}');
        seen[iso] = r.code;
      }
    }
    // The plan's premise: Evropa is merged, and Russia is not part of it.
    expect(extras.regions.of('CZ')?.code, 'EU');
    expect(extras.regions.of('RU'), isNull);
  });

  test('nature is drawable: every feature has a name and enough points', () async {
    final features = (await geoExtras()).features.features;
    expect({for (final f in features) f.id}.length, features.length, reason: 'duplicate feature id');
    for (final f in features) {
      expect(f.name, isNotEmpty, reason: f.id);
      expect(f.pts.length, greaterThanOrEqualTo(f.type == FeatureType.peak ? 2 : 6), reason: f.id);
      for (var i = 0; i < f.pts.length; i += 2) {
        expect(f.pts[i].abs(), lessThanOrEqualTo(180), reason: '${f.id}: longitude');
        expect(f.pts[i + 1].abs(), lessThanOrEqualTo(90), reason: '${f.id}: latitude');
      }
      if (f.type == FeatureType.area && f.kind != AreaKind.lake) {
        expect(f.scatter, isNotEmpty, reason: '${f.id}: an empty desert or forest draws as a plain blob');
      }
    }
    final sahara = features.firstWhere((f) => f.id == 'sahara');
    expect(sahara.contains(10, 23), isTrue);
    expect(sahara.contains(10, 5), isFalse);
  });
}
