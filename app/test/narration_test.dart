import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/globe/globe_screen.dart';
import 'package:storyteller/narrate/beat.dart';
import 'package:storyteller/narrate/narration_screen.dart';
import 'package:storyteller/story/osnova_screen.dart';

import 'globe_entry.dart';

/// Walks the whole flow and stops on the outline, ready for "Vyprávím →".
Future<void> _toOsnova(WidgetTester tester) async {
  await enterFlowFrom(tester, iso: 'DE');
  await tester.tap(find.text('Pokračovat →'));
  await tester.pumpAndSettle();
  for (var i = 0; i < 3; i++) {
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
  }
  expect(find.byType(OsnovaScreen), findsOneWidget);
}

Future<void> _toNarration(WidgetTester tester) async {
  await _toOsnova(tester);
  await tester.tap(find.text('Vyprávím →'));
  await tester.pumpAndSettle();
  expect(find.byType(NarrationScreen), findsOneWidget);
}

void main() {
  group('hints', () {
    const cast = [
      CastMember(id: 'a', label: 'Liška', emoji: '🦊', gradient: [Colors.orange, Colors.red], imagePath: 'x.jpg'),
    ];

    test('every beat has prompts, and they are questions or openings', () {
      for (final beat in StoryBeat.values) {
        final hints = hintsFor(beat, cast, rng: Random(1));
        expect(hints, isNotEmpty, reason: '$beat has no prompts');
        for (final h in hints) {
          expect(h.trim(), isNotEmpty);
          // The product promise (§7): the app never narrates for the
          // parent. A prompt you could read aloud *as the story* breaks
          // it, so every one has to end in a question mark or an
          // ellipsis — an answer the parent still has to give.
          expect(
            h.endsWith('?') || h.endsWith('…'),
            isTrue,
            reason: 'prompt is a readable sentence, not an opening: "$h"',
          );
        }
      }
    });

    test('no prompt points at the character with a pronoun', () {
      // Czech pronouns carry grammatical gender. "Kdo jí to poradil?"
      // reads as nonsense for "Král se strašidelným hradem", and the
      // cast is half masculine. Nothing here knows a character's gender,
      // so the prompts simply never use one. (Rule 2 in beat.dart.)
      const gendered = [' jí ', ' ji ', ' ní ', ' mu ', ' ho ', ' jeho ', ' její ', ' jemu '];
      for (final beat in StoryBeat.values) {
        for (final h in hintsFor(beat, cast, rng: Random(4))) {
          for (final p in gendered) {
            expect(' $h '.toLowerCase().contains(p), isFalse, reason: 'gendered pronoun "$p" in: "$h"');
          }
        }
      }
    });

    test('the character name is always the subject of its clause', () {
      // Rule 1 in beat.dart: nothing declines the labels, which are
      // descriptive phrases, not names. A crude but effective proxy for
      // "nominative subject" is that the name is never preceded by a
      // preposition that would demand another case.
      // "se" and "s" are left out on purpose: `se` is far more often the
      // reflexive particle than a preposition, so "Čeho se {postava}
      // bojí?" — correct Czech, nominative subject — would fail a test
      // that treated it as one.
      const prepositions = ['bys', 'na', 'do', 'od', 'pro', 'za', 'k', 'ke', 'o', 'u', 'v', 've'];
      for (final beat in StoryBeat.values) {
        for (final raw in rawHints(beat)) {
          final idx = raw.indexOf('{postava}');
          if (idx <= 0) continue;
          final before = raw.substring(0, idx).trim().split(RegExp(r'\s+')).last.toLowerCase();
          expect(prepositions.contains(before), isFalse, reason: '"$before {postava}" needs a case we cannot make: "$raw"');
        }
      }
    });

    test('prompts name a character the parent actually picked', () {
      final hints = hintsFor(StoryBeat.cast, cast, rng: Random(2));
      expect(hints.any((h) => h.contains('Liška')), isTrue);
      for (final h in hints) {
        expect(h.contains('{postava}'), isFalse, reason: 'placeholder leaked to the parent: "$h"');
      }
    });

    test('an empty cast falls back to a word, never the placeholder', () {
      for (final h in hintsFor(StoryBeat.task, const [], rng: Random(3))) {
        expect(h.contains('{postava}'), isFalse);
      }
    });

    test('the order differs between tellings', () {
      // Same four beats should not produce the same bedtime twice.
      final a = hintsFor(StoryBeat.problem, cast, rng: Random(1));
      final b = hintsFor(StoryBeat.problem, cast, rng: Random(9));
      expect(a, isNot(equals(b)));
      expect(a.toSet(), equals(b.toSet()), reason: 'shuffling must not drop or invent prompts');
    });
  });

  group('narration screen', () {
    testWidgets('the outline leads into it instead of apologising', (tester) async {
      await _toOsnova(tester);
      // The old behaviour was a SnackBar saying it was not built.
      await tester.tap(find.text('Vyprávím →'));
      await tester.pumpAndSettle();
      expect(find.byType(NarrationScreen), findsOneWidget);
      expect(find.textContaining('ještě není hotové'), findsNothing);
    });

    testWidgets('walks four beats and the last one offers the end', (tester) async {
      await _toNarration(tester);

      for (final beat in StoryBeat.values) {
        expect(find.text(beat.title), findsOneWidget, reason: 'beat ${beat.name} missing');
        if (beat != StoryBeat.values.last) {
          await tester.tap(find.byKey(narrationNextKey));
          await tester.pumpAndSettle();
        }
      }
      expect(find.text('Konec'), findsOneWidget);
    });

    testWidgets('no prompt is shown until asked for, then one at a time', (tester) async {
      await _toNarration(tester);

      // §1.2: the hint arrives when the parent hesitates — never before.
      expect(find.byType(Card), findsNothing);
      expect(find.textContaining('neříkej ji nahlas'), findsNothing);

      await tester.tap(find.byKey(narrationHintKey));
      await tester.pumpAndSettle();
      expect(find.textContaining('neříkej ji nahlas'), findsOneWidget);
      final afterFirst = _promptCount(tester);
      expect(afterFirst, 1);

      await tester.tap(find.byKey(narrationHintKey));
      await tester.pumpAndSettle();
      expect(_promptCount(tester), 2);
    });

    testWidgets('moving to the next beat puts the prompts away', (tester) async {
      await _toNarration(tester);
      await tester.tap(find.byKey(narrationHintKey));
      await tester.pumpAndSettle();
      expect(_promptCount(tester), 1);

      await tester.tap(find.byKey(narrationNextKey));
      await tester.pumpAndSettle();
      expect(_promptCount(tester), 0, reason: 'the previous beat\'s prompts followed us');
    });

    testWidgets('the ending is honest about what it cannot do', (tester) async {
      await _toNarration(tester);
      for (var i = 0; i < StoryBeat.values.length - 1; i++) {
        await tester.tap(find.byKey(narrationNextKey));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byKey(narrationNextKey));
      await tester.pumpAndSettle();

      expect(find.text('Dobrou noc.'), findsOneWidget);
      // Closing illustration and Knihovna are §1.2 promises that do not
      // exist; the dialog must not pretend otherwise.
      expect(find.textContaining('Knihovny'), findsOneWidget);

      await tester.tap(find.text('Zavřít'));
      await tester.pumpAndSettle();
      expect(find.byKey(globeCanvasKey), findsOneWidget);
    });
  });
}

/// Prompts currently on screen, counted by their own container colour
/// rather than by text, so the count doesn't depend on which prompts the
/// shuffle picked.
int _promptCount(WidgetTester tester) => tester
    .widgetList<Container>(find.byType(Container))
    .where((c) => (c.decoration as BoxDecoration?)?.color == const Color(0xFFFFF3E0))
    .length;
