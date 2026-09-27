// The Suflér end to end on a device, over whatever packs are bundled in
// assets/rag/packs/ (see app/README.md "RAG na zařízení"): real model, real
// pack, the real screen. Composes an osnova from pack motifs, opens the
// narration, taps "Napověz" and expects retrieved Czech hints with scores.
//
//   flutter test integration_test/rag_flow_test.dart -d <device>
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/narrate/beat.dart';
import 'package:storyteller/narrate/narration_screen.dart';
import 'package:storyteller/rag/rag_providers.dart';
import 'package:storyteller/story/story_draft.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Napověz retrieves pack hints for a pack osnova', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final store = await tester.runAsync(() => container.read(ragStoreProvider.future));
    expect(store, isNotNull, reason: 'no packs bundled in assets/rag/packs/');
    final counts = store!.titledMotifCounts();
    // ignore: avoid_print
    print('RAG_FLOW packs: titled motifs per country $counts');
    expect(counts['CZ'] ?? 0, greaterThan(0));

    // the motifs the pipeline has already written hints for
    final withArt = [for (final c in MotifCategory.values) store.motifs(c.packType, country: 'CZ').where((m) => m.jpeg != null).length];
    // ignore: avoid_print
    print('RAG_FLOW card art (task, problem, ending): $withArt');
    Motif pick(MotifCategory c) => Motif.fromPack((store.motifs(c.packType, country: 'CZ')..sort((a, b) => b.hintCount.compareTo(a.hintCount))).first);
    final draft = container.read(storyDraftProvider.notifier)
      ..setCountry('CZ', 'Česko')
      ..setCharacters([mockCastPool.first]);
    for (final c in MotifCategory.values) {
      draft.setMotif(c, pick(c));
    }

    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const MaterialApp(home: NarrationScreen())));
    await tester.pump();

    final results = <String, List<String>>{};
    for (final beat in StoryBeat.values) {
      await tester.tap(find.byKey(narrationHintKey));
      await tester.pump(); // let the tap's setState show "Hledám…" before waiting on it
      // model load + embed + retrieval run on real async work
      for (var i = 0; i < 150 && find.text('Hledám…').evaluate().isNotEmpty; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
        await tester.pump();
      }
      await tester.pump();
      final texts = tester.widgetList<Text>(find.descendant(of: find.byType(ListView), matching: find.byType(Text))).map((t) => t.data ?? '').toList();
      results[beat.name] = texts.where((t) => t.contains('·')).toList(); // the "0.83 · k motivu · task" meta lines
      if (beat != StoryBeat.ending) {
        await tester.tap(find.byKey(narrationNextKey));
        await tester.pump();
      }
    }
    // ignore: avoid_print
    print('RAG_FLOW hints per beat: $results');
    expect(results.values.where((v) => v.isNotEmpty), isNotEmpty, reason: 'no beat got a retrieved hint');
  });
}
