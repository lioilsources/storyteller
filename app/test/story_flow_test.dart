import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/cast/cast_composer_screen.dart';
import 'package:storyteller/globe/globe_screen.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/narrate/narration_screen.dart';
import 'package:storyteller/story/osnova_screen.dart';

import 'globe_entry.dart';

/// The app opens on the globe (§1.1b); everything here is about what
/// happens once a country is chosen, so [enterFlowFrom] walks in from
/// Denmark. The filtering itself is globe_test.dart's job.

Future<void> _tapFirstTile(WidgetTester tester) async {
  // Each picker screen's cards are InkWells rendered before the
  // "Zamíchat" OutlinedButton in the tree, so .first reliably hits a
  // motif card regardless of which 3 motifs got shuffled in.
  await tester.tap(find.byType(InkWell).first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('full story-assembly flow: cast → task → problem → ending → osnova', (tester) async {
    await enterFlowFrom(tester);
    expect(find.byType(CastComposerScreen), findsOneWidget);

    await tester.tap(find.text('Pokračovat →'));
    await tester.pumpAndSettle();
    expect(find.text(MotifCategory.task.title), findsOneWidget);

    await _tapFirstTile(tester);
    expect(find.text(MotifCategory.problem.title), findsOneWidget);

    await _tapFirstTile(tester);
    expect(find.text(MotifCategory.ending.title), findsOneWidget);

    await _tapFirstTile(tester);
    expect(find.byType(OsnovaScreen), findsOneWidget);

    // All four sections present with a real selection each.
    expect(find.text('Postavy'), findsOneWidget);
    expect(find.text('Úkol'), findsOneWidget);
    expect(find.text('Problém'), findsOneWidget);
    expect(find.text('Konec'), findsOneWidget);

    // isComplete (cast + task + problem + ending all set) enables the button.
    final continueBtn = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Vyprávím →'));
    expect(continueBtn.onPressed, isNotNull);
    await tester.tap(find.text('Vyprávím →'));
    await tester.pumpAndSettle();
    // It used to apologise with a SnackBar; it now opens the prompter.
    // What happens inside is narration_test.dart's job.
    expect(find.byType(NarrationScreen), findsOneWidget);
  });

  testWidgets('shuffle on a motif picker replaces the three shown cards without navigating', (tester) async {
    // Germany, because shuffling needs more motifs in the category than
    // the three on screen — Denmark has only two tasks extracted.
    await enterFlowFrom(tester, iso: 'DE');
    await tester.tap(find.text('Pokračovat →'));
    await tester.pumpAndSettle();

    final before = tester
        .widgetList<Text>(find.descendant(of: find.byType(Scaffold), matching: find.byType(Text)))
        .map((t) => t.data)
        .whereType<String>()
        .where((s) => taskPool.map((m) => m.label).contains(s))
        .toSet();

    await tester.tap(find.text('Zamíchat'));
    await tester.pumpAndSettle();

    // Still on the task screen — shuffle must not advance.
    expect(find.text(MotifCategory.task.title), findsOneWidget);
    final after = tester
        .widgetList<Text>(find.descendant(of: find.byType(Scaffold), matching: find.byType(Text)))
        .map((t) => t.data)
        .whereType<String>()
        .where((s) => taskPool.map((m) => m.label).contains(s))
        .toSet();
    expect(before, isNot(equals(after)));
  });

  testWidgets('Znovu resets the draft and goes back to the globe', (tester) async {
    await enterFlowFrom(tester);
    await tester.tap(find.text('Pokračovat →'));
    await tester.pumpAndSettle();
    await _tapFirstTile(tester); // task
    await _tapFirstTile(tester); // problem
    await _tapFirstTile(tester); // ending
    expect(find.byType(OsnovaScreen), findsOneWidget);

    await tester.tap(find.text('Znovu'));
    await tester.pumpAndSettle();
    // Starting over means choosing where the story comes from again,
    // because reset() drops the country along with everything else.
    expect(find.byKey(globeCanvasKey), findsOneWidget);

    // And re-entering must not show stale task/problem/ending sections
    // leaking through on a quick revisit.
    await turnTo(tester, 'DE');
    await tester.tap(find.textContaining('Vyprávět z'));
    await tester.pumpAndSettle();
    expect(find.byType(CastComposerScreen), findsOneWidget);
    await tester.tap(find.text('Pokračovat →'));
    await tester.pumpAndSettle();
    expect(find.text(MotifCategory.task.title), findsOneWidget);
  });
}
