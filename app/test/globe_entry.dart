import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/globe/country.dart';
import 'package:storyteller/globe/globe_painter.dart';
import 'package:storyteller/globe/globe_projection.dart';
import 'package:storyteller/globe/globe_screen.dart';
import 'package:storyteller/main.dart';

/// The app opens on the globe (§1.1b), so every suite about what happens
/// *downstream* of picking a country has to get through it first. These
/// helpers do that by aiming at a named country rather than trusting
/// whatever the opening view lands on — the downstream pools depend on
/// which country it is.

CountryIndex? _index;

/// The geo asset, parsed once for the whole suite.
///
/// It has to be loaded out here, not by the screen: real asset I/O never
/// completes inside `testWidgets`' fake-async zone, so a globe that
/// loaded it itself could only ever be pumped mid-"Chystám planetu…"
/// (and a `pumpAndSettle` waiting for it just burns the 10-minute test
/// timeout). [openGlobe] hands the parsed index to
/// `countryIndexProvider` instead.
///
/// Pass [tester] when calling from inside a `testWidgets` body: the
/// first load then runs via `runAsync`, in the real zone. Later calls
/// hit the cache and need nothing.
Future<CountryIndex> geo([WidgetTester? tester]) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final cached = _index;
  if (cached != null) return cached;
  return _index = tester == null ? await CountryIndex.load() : (await tester.runAsync(CountryIndex.load))!;
}

/// What the globe says it is looking at right now.
String focusedCountry(WidgetTester tester) => tester.widget<Text>(find.byKey(globeFocusNameKey)).data!;

GlobePainter globePainter(WidgetTester tester) =>
    tester.widget<CustomPaint>(find.byKey(globeCanvasKey)).painter! as GlobePainter;

/// The projection the screen is using for its canvas right now, so a
/// test can aim a tap at a (lon, lat) instead of guessing pixels.
GlobeProjection currentProjection(WidgetTester tester) {
  final painter = globePainter(tester);
  final size = tester.getSize(find.byKey(globeCanvasKey));
  return GlobeProjection(
    centerLat: painter.centerLat,
    centerLon: painter.centerLon,
    radius: math.min(size.width, size.height) / 2 - 8,
    center: Offset(size.width / 2, size.height / 2),
  );
}

Future<void> openGlobe(WidgetTester tester) async {
  final index = await geo(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [countryIndexProvider.overrideWith((ref) => index)],
      child: const StorytellerApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// Turns the globe to [iso] by tapping its centroid.
Future<Country> turnTo(WidgetTester tester, String iso) async {
  final country = (await geo(tester)).byIso[iso]!;
  final local = currentProjection(tester).project(country.lon, country.lat);
  expect(local, isNotNull, reason: '$iso is on the far side of the globe from the current view');
  await tester.tapAt(tester.getTopLeft(find.byKey(globeCanvasKey)) + local!);
  await tester.pumpAndSettle();
  expect(focusedCountry(tester), country.name, reason: 'failed to aim at $iso');
  return country;
}

/// Opens the globe, turns to [iso], and walks into the story flow from
/// that country's card. Denmark is the default because it is the widest
/// tradition in the corpus so far (7 characters), so cast mechanics that
/// need room to grow aren't clipped by the country filter.
Future<Country> enterFlowFrom(WidgetTester tester, {String iso = 'DK'}) async {
  await openGlobe(tester);
  final country = await turnTo(tester, iso);
  await tester.tap(find.textContaining('Vyprávět z'));
  await tester.pumpAndSettle();
  return country;
}

/// Labels from [poolLabels] that are currently on screen.
Set<String> shownFrom(WidgetTester tester, Iterable<String> poolLabels, {Finder? within}) {
  final pool = poolLabels.toSet();
  final finder = within == null ? find.byType(Text) : find.descendant(of: within, matching: find.byType(Text));
  return tester.widgetList<Text>(finder).map((t) => t.data).whereType<String>().where(pool.contains).toSet();
}
