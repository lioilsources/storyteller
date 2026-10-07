import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show PictureRecorder;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/cast/cast_composer_screen.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/globe/country.dart';
import 'package:storyteller/globe/feature.dart';
import 'package:storyteller/globe/globe_icons.dart';
import 'package:storyteller/globe/landmark.dart';
import 'package:storyteller/globe/region.dart';
import 'package:storyteller/globe/globe_painter.dart';
import 'package:storyteller/globe/globe_projection.dart';
import 'package:storyteller/globe/globe_screen.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/packs/pack_fetcher.dart';
import 'package:storyteller/packs/pack_manifest.dart';
import 'package:storyteller/packs/pack_providers.dart';
import 'package:storyteller/packs/pack_repository.dart';
import 'package:storyteller/packs/store_gateway.dart';
import 'package:storyteller/rag/rag_providers.dart';

import 'globe_entry.dart';

void main() {
  group('projection', () {
    const proj = GlobeProjection(centerLat: 0, centerLon: 0, radius: 100, center: Offset(200, 200));

    test('the centre of view lands in the centre of the disc', () {
      expect(proj.project(0, 0), const Offset(200, 200));
    });

    test('the far side of the sphere is not drawn', () {
      expect(proj.project(180, 0), isNull); // the antipode
      expect(proj.project(120, 0), isNull); // past the limb
      expect(proj.project(80, 0), isNotNull); // still facing us
    });

    test('east is right and north is up', () {
      final east = proj.project(45, 0)!;
      final north = proj.project(0, 45)!;
      expect(east.dx, greaterThan(200));
      expect(east.dy, closeTo(200, 0.001));
      expect(north.dy, lessThan(200)); // screen y grows downward
      expect(north.dx, closeTo(200, 0.001));
    });

    test('unproject inverts project', () {
      for (final point in [(10.0, 50.0), (-30.0, -20.0), (60.0, 5.0)]) {
        final screen = proj.project(point.$1, point.$2)!;
        final back = proj.unproject(screen)!;
        expect(back.lon, closeTo(point.$1, 0.01));
        expect(back.lat, closeTo(point.$2, 0.01));
      }
    });

    test('a tap outside the disc is not on the globe at all', () {
      expect(proj.unproject(const Offset(400, 400)), isNull);
    });
  });

  group('country lookup', () {
    late CountryIndex index;
    setUpAll(() async => index = await geo());

    test('the asset carries the corpus coverage the globe colours by', () {
      for (final iso in ['DE', 'DK', 'FR']) {
        final c = index.byIso[iso];
        expect(c, isNotNull, reason: '$iso missing from the geo asset');
        expect(c!.motifs, greaterThan(0), reason: '$iso should carry corpus coverage');
      }
      // Natural Earth ships ISO_A2 = "-99" for France and Norway;
      // build-geo falls back to ISO_A2_EH, so both must be present.
      expect(index.byIso['FR'], isNotNull);
      expect(index.byIso['NO'], isNotNull);
      // Nothing extracted from Czechia yet — still on the globe, just
      // uncoloured. (Erben/Němcová are on the fetch list.)
      expect(index.byIso['CZ']!.motifs, 0);
    });

    test('points inland resolve to their country', () {
      expect(index.at(13.4, 52.5)?.iso, 'DE'); // Berlin
      expect(index.at(2.35, 48.85)?.iso, 'FR'); // Paris
      expect(index.at(14.42, 50.09)?.iso, 'CZ'); // Prague
    });

    test('a country centroid resolves to that same country', () {
      // Tapping turns to a country's centroid and the card then
      // re-derives what is at the centre; if those disagree, tapping a
      // country would name a different one.
      for (final iso in ['DE', 'DK', 'FR', 'CZ']) {
        final c = index.byIso[iso]!;
        expect(index.at(c.lon, c.lat)?.iso, iso, reason: "$iso's centroid resolves elsewhere");
      }
    });

    test('near-shore sea snaps to a country, mid-ocean does not', () {
      // §1.1b wants a near miss to land somewhere sensible.
      expect(index.at(7.0, 56.0), isNotNull); // Skagerrak
      expect(index.at(-140.0, -40.0), isNull); // mid South Pacific
    });
  });

  group('globe screen', () {
    testWidgets('opens on the country we have the most to offer from', (tester) async {
      await openGlobe(tester);

      expect(find.byType(GlobeScreen), findsOneWidget);
      expect(find.byKey(globeCanvasKey), findsOneWidget);

      final index = await geo(tester);
      final richest = index.countries.where((c) => c.motifs > 0).reduce((a, b) => b.motifs > a.motifs ? b : a);
      // Germany, which on the whole planet is still part of merged Evropa:
      // the view is aimed at it, the card names the region and offers the
      // way in, and one tap later it is the country itself.
      expect(globePainter(tester).highlightIso, richest.iso);
      expect(globePainter(tester).zoom, 1);
      expect(focusedCountry(tester), 'Evropa');
      await tester.tap(find.text('Přiblížit Evropa →'));
      await tester.pumpAndSettle();
      expect(focusedCountry(tester), richest.name);
      expect(globePainter(tester).zoom, greaterThan(2));
    });

    testWidgets('dragging rotates the globe and moves the highlight with it', (tester) async {
      await openGlobe(tester);
      final before = focusedCountry(tester);
      final lonBefore = globePainter(tester).centerLon;

      // Far enough east to leave Europe entirely.
      await tester.drag(find.byKey(globeCanvasKey), const Offset(-220, 0));
      await tester.pumpAndSettle();

      expect(globePainter(tester).centerLon, isNot(lonBefore));
      expect(focusedCountry(tester), isNot(before));
      // The painter must highlight the country the card names.
      final painter = globePainter(tester);
      final named = painter.index.countries.firstWhere((c) => c.name == focusedCountry(tester));
      expect(painter.highlightIso, named.iso);
    });

    testWidgets('a fling keeps spinning and then settles', (tester) async {
      await openGlobe(tester);
      final start = globePainter(tester).centerLon;

      await tester.fling(find.byKey(globeCanvasKey), const Offset(-120, 0), 1200);
      await tester.pump(const Duration(milliseconds: 100));
      final midFlight = globePainter(tester).centerLon;

      // pumpAndSettle would hang forever on a globe that never stops.
      await tester.pumpAndSettle();
      final settled = globePainter(tester).centerLon;

      expect(midFlight, isNot(start), reason: 'the fling did not move the globe');
      expect(settled, isNot(midFlight), reason: 'the globe stopped dead instead of coasting');
    });

    testWidgets('tapping a country turns to it and highlights it', (tester) async {
      await openGlobe(tester);
      await turnTo(tester, 'DK');

      expect(focusedCountry(tester), 'Denmark');
      expect(globePainter(tester).highlightIso, 'DK');
      expect(find.text('224 motivů z 18 pohádek'), findsOneWidget);
    });

    testWidgets('the painter repaints exactly when the view or the highlight moves', (tester) async {
      final index = await geo(tester);
      GlobePainter at({double lat = 50, double lon = 12, String? iso = 'DE'}) =>
          GlobePainter(index: index, centerLat: lat, centerLon: lon, highlightIso: iso, coveredIsos: const {'DE'});

      expect(at().shouldRepaint(at()), isFalse);
      expect(at().shouldRepaint(at(lat: 51)), isTrue);
      expect(at().shouldRepaint(at(lon: 13)), isTrue);
      expect(at().shouldRepaint(at(iso: 'CZ')), isTrue);
    });
  });

  group('zoom, regions and icons', () {
    Offset canvasCentre(WidgetTester tester) => tester.getCenter(find.byKey(globeCanvasKey));

    List<PlacedIcon> iconsOnScreen(WidgetTester tester, ({RegionIndex regions, LandmarkIndex landmarks, FeatureIndex features}) extras) => layoutIcons(
          proj: currentProjection(tester),
          size: tester.getSize(find.byKey(globeCanvasKey)),
          zoom: globePainter(tester).zoom,
          landmarks: extras.landmarks,
          features: extras.features,
          regions: extras.regions,
        );

    testWidgets('the buttons zoom in, out and back to the whole planet', (tester) async {
      await openGlobe(tester);
      expect(find.byKey(globeWholeKey), findsNothing, reason: 'nowhere to go back to yet');

      await tester.tap(find.byKey(globeZoomInKey));
      await tester.pumpAndSettle();
      final closer = globePainter(tester).zoom;
      expect(closer, greaterThan(1));

      await tester.tap(find.byKey(globeZoomInKey));
      await tester.pumpAndSettle();
      expect(globePainter(tester).zoom, greaterThan(closer));

      await tester.tap(find.byKey(globeZoomOutKey));
      await tester.pumpAndSettle();
      expect(globePainter(tester).zoom, closeTo(closer, 0.001));

      await tester.tap(find.byKey(globeWholeKey));
      await tester.pumpAndSettle();
      expect(globePainter(tester).zoom, 1);
    });

    testWidgets('a pinch zooms, and letting go does not throw the globe', (tester) async {
      await openGlobe(tester);
      final c = canvasCentre(tester);
      final a = await tester.startGesture(c - const Offset(30, 0));
      final b = await tester.startGesture(c + const Offset(30, 0));
      await tester.pump();
      for (var i = 0; i < 6; i++) {
        await a.moveBy(const Offset(-10, 0));
        await b.moveBy(const Offset(10, 0));
        await tester.pump(const Duration(milliseconds: 16));
      }
      final zoomed = globePainter(tester).zoom;
      expect(zoomed, greaterThan(1.5));

      await a.up();
      await b.up();
      await tester.pump(const Duration(milliseconds: 16));
      final lon = globePainter(tester).centerLon;
      await tester.pumpAndSettle();
      expect(globePainter(tester).centerLon, lon);
      expect(globePainter(tester).zoom, zoomed);
    });

    testWidgets('zoomed in, the same drag turns the globe less', (tester) async {
      await openGlobe(tester);
      Future<double> dragged() async {
        final before = globePainter(tester).centerLon;
        await tester.drag(find.byKey(globeCanvasKey), const Offset(-60, 0));
        await tester.pump();
        final after = globePainter(tester).centerLon;
        await tester.drag(find.byKey(globeCanvasKey), const Offset(60, 0));
        await tester.pumpAndSettle();
        return (after - before).abs();
      }

      final wide = await dragged();
      await tester.tap(find.byKey(globeZoomInKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(globeZoomInKey));
      await tester.pumpAndSettle();
      final close = await dragged();
      expect(close, lessThan(wide / 2));
    });

    testWidgets('a merged region shows one icon, and comes apart when you fly in', (tester) async {
      await openGlobe(tester);
      final extras = await geoExtras(tester);
      final eu = extras.regions.of('DE')!;

      final far = iconsOnScreen(tester, extras).where((i) => eu.isos.contains(i.iso)).toList();
      expect(far.map((i) => i.sprite), ['eiffel'], reason: 'the whole of Evropa is one icon from afar');
      expect(far.single.region, eu);

      await turnTo(tester, 'CZ');
      final near = iconsOnScreen(tester, extras).where((i) => eu.isos.contains(i.iso)).toList();
      expect(near.length, greaterThan(5));
      expect(near.map((i) => i.sprite), contains('prague-castle'));
      expect(near.every((i) => i.region == null), isTrue);
    });

    testWidgets('the card names the landmark of the country, and the icon you tap', (tester) async {
      await openGlobe(tester);
      final extras = await geoExtras(tester);
      await turnTo(tester, 'CZ');
      expect(tester.widget<Text>(find.byKey(globeSightKey)).data, contains('Pražský hrad'));

      // Some other building on screen — tapping it turns to it and names it.
      // (One well inside the canvas, clear of the zoom buttons.)
      final size = tester.getSize(find.byKey(globeCanvasKey));
      final clear = Rect.fromLTRB(20, 20, size.width - 90, size.height - 20);
      final other = iconsOnScreen(tester, extras).firstWhere((i) => i.iso != null && i.iso != 'CZ' && clear.contains(i.rect.center));
      await tester.tapAt(tester.getTopLeft(find.byKey(globeCanvasKey)) + other.rect.center);
      await tester.pumpAndSettle();
      expect(tester.widget<Text>(find.byKey(globeSightKey)).data, contains(other.name));
      expect(globePainter(tester).highlightIso, other.iso);
    });

    testWidgets('a country inside a region cannot start a story until it is picked', (tester) async {
      await openGlobe(tester);
      expect(find.textContaining('Vyprávět z'), findsNothing);
      expect(find.textContaining('zemí pohromadě'), findsOneWidget);
    });

    test('where two icons would overlap, the more important one stays', () async {
      final extras = await geoExtras();
      const proj = GlobeProjection(centerLat: 50, centerLon: 14, radius: 600, center: Offset(200, 200));
      final placed = layoutIcons(
        proj: proj,
        size: const Size(400, 400),
        zoom: 3,
        landmarks: LandmarkIndex([
          Landmark(id: 'small', iso: 'CZ', name: 'Malá', lon: 14.0, lat: 50.0, sprite: 'small', priority: 1),
          Landmark(id: 'big', iso: 'CZ', name: 'Velká', lon: 14.1, lat: 50.0, sprite: 'big', priority: 3),
          Landmark(id: 'far', iso: 'CZ', name: 'Daleká', lon: 24.0, lat: 50.0, sprite: 'far', priority: 1),
        ]),
        features: FeatureIndex.empty,
        regions: extras.regions,
      );
      expect(placed.map((i) => i.sprite).toSet(), {'big', 'far'});
    });

    test('a country whose landmark is crowded out still gets one, from elsewhere', () async {
      // Whole planet over North America: the Statue of Liberty and Toronto's
      // tower want the same spot. Whichever loses, neither country may end
      // up bare — and the stand-in must not be the hero's next-door
      // neighbour (the Empire State Building for the Statue of Liberty).
      final extras = await geoExtras();
      const proj = GlobeProjection(centerLat: 23, centerLon: -102, radius: 198, center: Offset(206, 325));
      final placed = layoutIcons(proj: proj, size: const Size(412, 650), zoom: 1, landmarks: extras.landmarks, features: extras.features, regions: extras.regions);
      final us = placed.where((i) => i.iso == 'US').map((i) => i.sprite).toList();
      expect(placed.any((i) => i.iso == 'CA'), isTrue);
      expect(us, hasLength(1), reason: 'the United States must show exactly one landmark from afar, got $us');
      if (us.single != 'statue-of-liberty') expect(us.single, isNot('empire-state'));
    });

    test('zoomed in, the painter stops walking the whole world', () async {
      final index = await geo();
      int built(double zoom) {
        final recorder = PictureRecorder();
        GlobePainter(index: index, centerLat: 50, centerLon: 14, highlightIso: 'CZ', coveredIsos: const {}, zoom: zoom).paint(Canvas(recorder), const Size(400, 500));
        recorder.endRecording().dispose();
        return GlobePainter.debugPathsBuilt;
      }

      final whole = built(1);
      final close = built(6);
      expect(whole, greaterThan(100));
      expect(close, lessThan(60));
      expect(close, greaterThan(3), reason: 'Czechia and its neighbours must still be drawn');
    });

    test('the painter repaints when the zoom changes', () async {
      final index = await geo();
      GlobePainter at(double zoom) => GlobePainter(index: index, centerLat: 50, centerLon: 12, highlightIso: 'DE', coveredIsos: const {'DE'}, zoom: zoom);
      expect(at(2).shouldRepaint(at(2)), isFalse);
      expect(at(2).shouldRepaint(at(3)), isTrue);
    });
  });

  group('the globe filters the story', () {
    testWidgets('entering from Denmark offers only Danish characters', (tester) async {
      await enterFlowFrom(tester, iso: 'DK');
      expect(find.byType(CastComposerScreen), findsOneWidget);

      final danish = {for (final m in mockCastPool) if (m.country == 'DK') m.label};
      final shown = shownFrom(tester, mockCastPool.map((m) => m.label));
      expect(shown, isNotEmpty);
      expect(shown.difference(danish), isEmpty, reason: 'non-Danish characters leaked past the globe filter');
    });

    testWidgets('entering from Germany offers a different, German-only cast', (tester) async {
      await enterFlowFrom(tester, iso: 'DE');

      final german = {for (final m in mockCastPool) if (m.country == 'DE') m.label};
      final danish = {for (final m in mockCastPool) if (m.country == 'DK') m.label};
      final shown = shownFrom(tester, mockCastPool.map((m) => m.label));
      expect(shown, isNotEmpty);
      expect(shown.difference(german), isEmpty);
      // Disjoint from Denmark's, so the filter can't be passing by luck.
      expect(shown.intersection(danish), isEmpty);
    });

    testWidgets('and the task picker stays inside that one tradition', (tester) async {
      await enterFlowFrom(tester, iso: 'DE');
      await tester.tap(find.text('Pokračovat →'));
      await tester.pumpAndSettle();

      final shown = shownFrom(tester, taskPool.map((m) => m.label));
      expect(shown, isNotEmpty);
      final countries = {
        for (final m in taskPool)
          if (shown.contains(m.label)) m.country,
      };
      expect(countries, {'DE'}, reason: 'a filtered picker must not mix traditions');
    });

    testWidgets('a narrow tradition shows fewer cards rather than padding from elsewhere', (tester) async {
      // France currently has exactly one translated motif per category.
      await enterFlowFrom(tester, iso: 'FR');
      await tester.tap(find.text('Pokračovat →'));
      await tester.pumpAndSettle();

      final french = {for (final m in taskPool) if (m.country == 'FR') m.label};
      expect(shownFrom(tester, taskPool.map((m) => m.label)), french);
      // Nothing left to shuffle to, so the button must be dead rather
      // than reshuffling the same single card.
      final shuffle = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Zamíchat'));
      expect(shuffle.onPressed, isNull);
    });

    testWidgets('a country with no corpus is an honest dead end', (tester) async {
      await openGlobe(tester);
      await turnTo(tester, 'CZ');

      expect(find.text('Odsud zatím žádné pohádky nemáme.'), findsOneWidget);
      final button = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Vyprávět z Czechia →'));
      expect(button.onPressed, isNull, reason: 'an empty country must not fall back to another tradition');
    });
  });

  group('packs on the globe', () {
    testWidgets('a pack country says how many tales its motifs come from', (tester) async {
      await openGlobe(tester, overrides: [
        packMotifCountsProvider.overrideWithValue(const {'PL': 12, 'TN': 1}),
        packTaleCountsProvider.overrideWithValue(const {'PL': 3, 'TN': 1}),
      ]);
      await turnTo(tester, 'PL');
      expect(find.text('12 motivů z 3 pohádek'), findsOneWidget);
      await turnTo(tester, 'TN');
      expect(find.text('1 motiv z 1 pohádky'), findsOneWidget);
    });

    testWidgets('a pack built before pack_tales still shows its motifs', (tester) async {
      await openGlobe(tester, overrides: [packMotifCountsProvider.overrideWithValue(const {'PL': 7})]);
      await turnTo(tester, 'PL');
      expect(find.text('7 motivů z balíčku'), findsOneWidget);
    });

    // Through JSON, as the app reads it: literal maps would be typed otherwise.
    Map<String, dynamic> manifestJson({bool afriBundled = false}) => jsonDecode(jsonEncode({
          'schema': 4, 'lang': 'cs', 'min_app_version': '1.4.0',
          'base_urls': {'free': 'https://example.test/free-v2/', 'paid': 'https://example.test/'},
          'regions': {
            'afri': {
              'name': {'cs': 'Afrika'}, 'bundled': afriBundled, 'countries': ['TN', 'DZ', 'CD'],
              'free': {'version': 1, 'size': 5 * 1024 * 1024, 'sha256': '00', 'tales': 10, 'file': 'region-afri-free-v1.zip'},
              'parts': [
                {'n': 1, 'product_id': 'pack_afri_1', 'version': 1, 'size': 30 * 1024 * 1024, 'sha256': '00', 'tales': 50, 'file': 'afri-p1.zip'},
                {'n': 2, 'product_id': 'pack_afri_2', 'version': 1, 'size': 30 * 1024 * 1024, 'sha256': '00', 'tales': 50, 'file': 'afri-p2.zip'},
              ],
            },
            'east': {'name': {'cs': 'Východní Evropa a Kavkaz'}, 'bundled': true, 'countries': ['PL'], 'free': {'version': 1, 'size': 1, 'sha256': '00', 'tales': 10, 'file': 'region-east-free-v1.zip'}, 'parts': []},
          },
          'countries': {
            'tn': {'name': {'en': 'Tunisia'}, 'region': 'AFRI', 'tales': 48, 'in': {'free': 1, 'parts': {'1': 12, '2': 35}}, 'coming': 3},
            'dz': {'name': {'en': 'Algeria'}, 'region': 'AFRI', 'tales': 0, 'in': {'free': 0, 'parts': {}}, 'coming': 12},
            'cd': {'name': {'en': 'Dem. Rep. Congo'}, 'region': 'AFRI', 'tales': 5, 'in': {'free': 5, 'parts': {}}, 'coming': 0},
            'pl': {'name': {'en': 'Poland'}, 'region': 'EAST', 'tales': 4, 'in': {'free': 4, 'parts': {}}, 'coming': 1},
          },
        })) as Map<String, dynamic>;

    PackRepository tmpRepo({StoreGateway store = const NoStoreGateway()}) {
      final tmp = Directory.systemTemp.createTempSync('globe-packs');
      addTearDown(() => tmp.deleteSync(recursive: true));
      final repo = PackRepository(root: tmp, manifestUrl: Uri.parse('https://example.test/m.json'), fetcher: _NoNet(), store: store, appVersion: '1.7.0');
      addTearDown(repo.close);
      return repo;
    }

    testWidgets('a region whose free pack is a download offers it, a bundled one does not', (tester) async {
      final repo = tmpRepo();
      final manifest = PackManifest.fromJson(manifestJson());
      await openGlobe(tester, overrides: [
        packRepositoryProvider.overrideWith((ref) async => repo),
        packManifestProvider.overrideWith((ref) async => manifest),
      ]);
      await turnTo(tester, 'TN');
      expect(find.byKey(globeDownloadKey), findsOneWidget);
      expect(find.text('Stáhnout Afrika: 10 pohádek zdarma (5,0 MB)'), findsOneWidget);

      await turnTo(tester, 'PL');
      expect(find.byKey(globeDownloadKey), findsNothing, reason: 'the free ten of the region is in the binary');
    });

    testWidgets('the card counts a country\'s tales across every pack, on the device or not', (tester) async {
      final repo = tmpRepo();
      final manifest = PackManifest.fromJson(manifestJson(afriBundled: true));
      await openGlobe(tester, overrides: [
        packRepositoryProvider.overrideWith((ref) async => repo),
        packManifestProvider.overrideWith((ref) async => manifest),
        packMotifCountsProvider.overrideWithValue(const {'TN': 9, 'CD': 40, 'PL': 30}),
        packTaleCountsProvider.overrideWithValue(const {'TN': 1, 'CD': 5, 'PL': 4}),
      ]);
      await turnTo(tester, 'TN');
      expect(find.text('48 pohádek · 1 zdarma, 47 v dílech Afrika 1–2 · máš 1'), findsOneWidget);
      expect(find.byKey(globeDownloadKey), findsNothing, reason: 'the parts are not owned, and buying comes later');
      expect(find.textContaining('Vyprávět z '), findsOneWidget);
      await turnTo(tester, 'CD');
      expect(find.text('5 pohádek zdarma'), findsOneWidget);
      await turnTo(tester, 'PL');
      expect(find.text('4 pohádky zdarma · další 1 chystáme'), findsOneWidget);
      await turnTo(tester, 'DZ'); // nothing in a pack yet
      expect(find.text('Chystáme odsud 12 pohádek do balíčku Afrika.'), findsOneWidget);
      final painter = tester.widget<CustomPaint>(find.byKey(globeCanvasKey)).painter! as GlobePainter;
      expect(painter.pendingIsos, {'DZ'}, reason: 'a paler green: tales exist, none on the device');
      expect(painter.coveredIsos.containsAll({'TN', 'CD', 'PL'}), isTrue);
    });

    testWidgets('an owned part with tales from the country is offered where the country has none on the device', (tester) async {
      final repo = tmpRepo(store: const UnlockedStoreGateway());
      final json = manifestJson(afriBundled: true);
      ((json['countries'] as Map<String, dynamic>)['dz'] as Map<String, dynamic>).addAll(<String, dynamic>{'tales': 7, 'in': <String, dynamic>{'free': 0, 'parts': <String, dynamic>{'2': 7}}, 'coming': 0});
      final manifest = PackManifest.fromJson(json);
      await openGlobe(tester, overrides: [
        storeGatewayProvider.overrideWithValue(const UnlockedStoreGateway()),
        packRepositoryProvider.overrideWith((ref) async => repo),
        packManifestProvider.overrideWith((ref) async => manifest),
      ]);
      await turnTo(tester, 'DZ');
      expect(find.text('7 pohádek · 7 v dílu Afrika 2'), findsOneWidget);
      expect(find.text('Stáhnout Afrika 2: 50 pohádek (30,0 MB)'), findsOneWidget);
    });

    testWidgets('the globe stays put whatever the card has to say', (tester) async {
      // The card is laid out under the globe; when it grew a row for a
      // download offer or a landmark, the planet jumped as the focus moved
      // between countries with tales and without.
      final repo = tmpRepo();
      final manifest = PackManifest.fromJson(manifestJson());
      await openGlobe(tester, overrides: [
        packRepositoryProvider.overrideWith((ref) async => repo),
        packManifestProvider.overrideWith((ref) async => manifest),
      ]);
      Rect canvas() => tester.getRect(find.byKey(globeCanvasKey));
      final merged = canvas(); // "Evropa", no landmark row, "Přiblížit"

      await turnTo(tester, 'DK'); // tales, a landmark, zoomed in
      expect(canvas(), merged);
      await turnTo(tester, 'CZ'); // no tales
      expect(canvas(), merged);
      await turnTo(tester, 'TN'); // a download offer
      expect(find.byKey(globeDownloadKey), findsOneWidget);
      expect(canvas(), merged);
      await turnTo(tester, 'CD'); // a long name, a river and a forest under the centre
      expect(canvas(), merged);
      await turnTo(tester, 'BR'); // no offer, no tales, far from everything above
      expect(canvas(), merged);
    });
  });
}

class _NoNet implements PackFetcher {
  @override
  Future<Uint8List> get(Uri url) async => throw const SocketException('offline');

  @override
  Future<void> download(Uri url, File part, {void Function(int)? onBytes}) async => throw const SocketException('offline');
}
