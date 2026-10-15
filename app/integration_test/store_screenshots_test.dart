// Store screenshots on a simulator, over the real bundled packs. Each screen
// is pumped with real data, then the test prints `SHOT <name>` and holds so a
// host loop can `xcrun simctl io <device> screenshot` it (the integration
// binding can't write screenshots itself without a driver):
//
//   tool/store_screenshots.sh [simulator] [out dir]
import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:storyteller/cast/cast_composer_screen.dart';
import 'package:storyteller/cast/cast_controller.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/globe/globe_screen.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/motifs/motif_picker_screen.dart';
import 'package:storyteller/narrate/narration_screen.dart';
import 'package:storyteller/rag/rag_providers.dart';
import 'package:storyteller/rag/rag_store.dart';
import 'package:storyteller/story/osnova_screen.dart';
import 'package:storyteller/story/story_draft.dart';
import 'package:storyteller/theme/kid_text.dart';

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

    Future<void> holdShot(String name) async {
      // ignore: avoid_print
      print('SHOT $name');
      await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 6)));
    }

    Future<void> shot(String name, Widget screen, {Future<void> Function()? before, bool hold = true}) async {
      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        // The app's own look (lib/main.dart), or the shots would not match what ships.
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: storyThemeData(),
          builder: (context, child) => KidTheme(data: storyKidTheme, child: child!),
          home: screen,
        ),
      ));
      await settle();
      if (before != null) await before();
      if (hold) await holdShot(name);
    }

    // One tale, pinned by title (Erben's „Pták Ohnivák a liška Ryška“), so the
    // cast, the outline and the scenes belong together; left to chance the
    // shots mix motifs from different tales.
    PackMotif pick(String type, String title) {
      final all = store.motifs(type, country: 'CZ').where((m) => m.jpeg != null && m.title == title).toList()
        ..sort((a, b) => b.hintCount.compareTo(a.hintCount));
      return all.first;
    }

    final cast = [for (final t in ['Královic', 'Liška Ryška', 'Pták Ohnivák']) CastMember.fromPack(pick('character', t))];
    final tasks = [for (final t in ['Hlídání zlaté jabloně', 'Pták Ohnivák', 'Kůň Zlatohřivák']) Motif.fromPack(pick('task', t))];

    final draft = container.read(storyDraftProvider.notifier);

    await shot('01_globe', const GlobeScreen(), hold: false);
    await holdShot('01_globe');
    await tester.tap(find.textContaining('Přiblížit'));
    await settle(3000);
    await holdShot('02_globe_zeme');

    draft.setCountry('CZ', 'Česko');
    await shot('03_cast', const CastComposerScreen(), hold: false);
    final castState = container.read(castComposerProvider.notifier);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    castState.state = [for (final (i, m) in cast.indexed) CastSlot(slotKey: 'shot$i', member: m)];
    await settle(500);
    await holdShot('03_cast');

    await shot('04_task', MotifPickerScreen(category: MotifCategory.task, countryIso: 'CZ', packPool: tasks, onSelected: (_) {}));

    draft
      ..setCharacters(cast)
      ..setMotif(MotifCategory.task, tasks.first)
      ..setMotif(MotifCategory.problem, Motif.fromPack(pick('problem', 'Královic a zlatá klec')))
      ..setMotif(MotifCategory.ending, Motif.fromPack(pick('ending', 'Královic a Zlatovláska')));
    await shot('05_osnova', const OsnovaScreen());

    await shot('06_sufler', const NarrationScreen(), before: () async {
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
    await holdShot('07_zvuky');
  });
}
