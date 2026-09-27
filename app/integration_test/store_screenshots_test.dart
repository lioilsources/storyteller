// Store screenshots on a simulator, over the real bundled packs. Each screen
// is pumped with real data, then the test prints `SHOT <name>` and holds so a
// host loop can `xcrun simctl io <device> screenshot` it (the integration
// binding can't write screenshots itself without a driver):
//
//   flutter test integration_test/store_screenshots_test.dart -d <device>
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:storyteller/cast/cast_composer_screen.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/globe/globe_screen.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/motifs/motif_picker_screen.dart';
import 'package:storyteller/narrate/narration_screen.dart';
import 'package:storyteller/rag/rag_providers.dart';
import 'package:storyteller/story/osnova_screen.dart';
import 'package:storyteller/story/story_draft.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('store screenshots', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final store = (await tester.runAsync(() => container.read(ragStoreProvider.future)))!;

    Future<void> settle([int ms = 1500]) async {
      for (var i = 0; i < ms ~/ 100; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pump();
      }
    }

    Future<void> shot(String name, Widget screen, {Future<void> Function()? before}) async {
      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(colorSchemeSeed: const Color(0xFF8D6E63), useMaterial3: true), home: screen),
      ));
      await settle();
      if (before != null) await before();
      // ignore: avoid_print
      print('SHOT $name');
      await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 6)));
    }

    // Pack motifs that already have hints and card art — what a CZ story looks like today.
    Motif best(MotifCategory c) {
      final all = store.motifs(c.packType, country: 'CZ').where((m) => m.jpeg != null).toList()..sort((a, b) => b.hintCount.compareTo(a.hintCount));
      return Motif.fromPack(all.first);
    }

    final draft = container.read(storyDraftProvider.notifier)..setCountry('CZ', 'Česko');

    await shot('01_globe', const GlobeScreen());
    await shot('02_cast', const CastComposerScreen());
    final taskPool = [for (final m in store.motifs('task', country: 'CZ').where((m) => m.jpeg != null && m.hintCount > 0)) Motif.fromPack(m)];
    await shot('03_task', MotifPickerScreen(category: MotifCategory.task, countryIso: 'CZ', packPool: taskPool, onSelected: (_) {}));

    draft
      ..setCharacters(mockCastPool.take(2).toList())
      ..setMotif(MotifCategory.task, best(MotifCategory.task))
      ..setMotif(MotifCategory.problem, best(MotifCategory.problem))
      ..setMotif(MotifCategory.ending, best(MotifCategory.ending));
    await shot('04_osnova', const OsnovaScreen());

    await shot('05_sufler', const NarrationScreen(), before: () async {
      await tester.tap(find.byKey(narrationNextKey)); // to the task beat: bridge phrase + scene
      await settle(2500);
      await tester.tap(find.byKey(narrationHintKey));
      await tester.pump();
      for (var i = 0; i < 150 && find.text('Hledám…').evaluate().isNotEmpty; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
        await tester.pump();
      }
      await settle();
    });

    // The soundboard sits under the hints: scroll to it for its own shot.
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await settle();
    // ignore: avoid_print
    print('SHOT 06_zvuky');
    await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 6)));
  });
}
