import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/globe/country.dart';
import 'package:storyteller/globe/feature.dart';
import 'package:storyteller/globe/landmark.dart';
import 'package:storyteller/globe/region.dart';
import 'package:storyteller/l10n/lang.dart';
import 'package:storyteller/main.dart';

import 'kid_finders.dart';

/// The app on an English phone: UI, country names and the way into a story.
void main() {
  testWidgets('English globe', (tester) async {
    tester.view.physicalSize = const Size(1290, 2796);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final index = (await tester.runAsync(() => CountryIndex.load(lang: 'en')))!;
    final regions = (await tester.runAsync(() => RegionIndex.load(lang: 'en')))!;
    final landmarks = (await tester.runAsync(() => LandmarkIndex.load(lang: 'en')))!;
    final features = (await tester.runAsync(() => FeatureIndex.load(lang: 'en')))!;
    expect(index.byIso['CZ']!.name, 'Czechia');
    expect(index.byIso['US']!.from, 'from the United States');
    expect(index.byIso['BA']!.name, 'Bosnia and Herzegovina');
    expect(landmarks.heroOf('CZ')!.name, isNot(contains('Pražský')));
    await tester.pumpWidget(ProviderScope(
      overrides: [
        appLangProvider.overrideWithValue('en'),
        countryIndexProvider.overrideWith((ref) => index),
        regionIndexProvider.overrideWith((ref) => regions),
        landmarkIndexProvider.overrideWith((ref) => landmarks),
        featureIndexProvider.overrideWith((ref) => features),
      ],
      child: const StorytellerApp(),
    ));
    await tester.pumpAndSettle();
    expect(findKidText('Where is the story from?'), findsOneWidget);
    expect(find.text('Spin'), findsOneWidget);
    // zoomed out, the richest country sits inside merged Europe
    expect(find.text('Zoom into Europe →'), findsOneWidget);
    expect(find.text('38 countries together. Zoom in and pick one.'), findsOneWidget);
  });
}
