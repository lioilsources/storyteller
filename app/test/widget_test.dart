import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/cast/cast_composer_screen.dart';
import 'package:storyteller/cast/cast_controller.dart';
import 'package:storyteller/cast/cast_member.dart';

import 'globe_entry.dart';

/// These suites are about the cast mechanics, which live downstream of
/// the globe — [enterFlowFrom] gets us there. It defaults to Denmark
/// because that tradition is wide enough (7 characters) not to clip the
/// grow/reroll behaviour under test; the filter itself is globe_test's
/// job, and the narrow-pool case gets its own test at the bottom.

// Restricted to known member labels (not the emoji glyph, not captions or
// buttons) so a reroll's before/after diff isn't polluted by the second
// Text node (the emoji) that changes alongside each label, or by static
// chrome that never changes.
Set<String> _visibleMemberLabels(WidgetTester tester) => shownFrom(
      tester,
      mockCastPool.map((m) => m.label),
      within: find.byType(CastComposerScreen),
    );

/// How many characters the chosen country actually has — the cast can
/// never grow past it, however high [maxCastSize] is.
int _poolSize(String iso) => mockCastPool.where((m) => m.country == iso).length;

void main() {
  testWidgets('entering from the globe lands on the cast composer with the initial cast size', (tester) async {
    await enterFlowFrom(tester);

    expect(find.byType(CastComposerScreen), findsOneWidget);
    expect(find.text('Obsazení: $initialCastSize/$maxCastSize'), findsOneWidget);
    expect(find.text('Přidat postavu'), findsOneWidget);
  });

  testWidgets('tapping a card rerolls just that slot (first rerolls are warm/instant)', (tester) async {
    await enterFlowFrom(tester);

    final before = _visibleMemberLabels(tester);
    expect(before.length, initialCastSize);

    await tester.tap(find.byType(InkWell).first); // first cast card's tap target
    // This reroll draws from the warm budget (fresh per test, budget=3),
    // so it never enters the loading/cold-delay path — safe to settle.
    await tester.pumpAndSettle();
    final after = _visibleMemberLabels(tester);

    // Exactly one label left, one label arrived — every other slot untouched.
    expect(after.length, initialCastSize);
    expect(before.difference(after).length, 1);
    expect(after.difference(before).length, 1);
  });

  testWidgets('add grows the cast up to the max, then the add card disappears', (tester) async {
    await enterFlowFrom(tester);

    for (var n = initialCastSize; n < maxCastSize; n++) {
      await tester.tap(find.text('Přidat postavu'));
      await tester.pumpAndSettle();
      expect(find.text('Obsazení: ${n + 1}/$maxCastSize'), findsOneWidget);
    }

    expect(find.text('Přidat postavu'), findsNothing);
    expect(find.text('Obsazení: $maxCastSize/$maxCastSize'), findsOneWidget);
  });

  testWidgets('once the warm-prewarm budget runs out, a reroll shows a loading veil and then resolves', (tester) async {
    await enterFlowFrom(tester);

    // Budget is prewarmBudget (3) rerolls before a draw goes "cold". Burn
    // it on the same card so its 4th reroll is the one under test.
    final firstCard = find.byType(InkWell).first;
    for (var i = 0; i < prewarmBudget; i++) {
      await tester.tap(firstCard);
      await tester.pumpAndSettle();
    }

    final before = _visibleMemberLabels(tester);
    await tester.tap(firstCard);
    await tester.pump(); // build the frame with isLoading == true

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // MODELS_PLAN tier 0 is ~1–2 s; the mock delay tops out at 1.6 s.
    await tester.pump(const Duration(milliseconds: 1700));
    // Plus the card's two concurrent transitions that start once the
    // delay resolves: the 150ms spinner-veil fade-out and the 320ms
    // old-member→new-member content crossfade — wait for the longer one.
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    final after = _visibleMemberLabels(tester);
    expect(after.length, initialCastSize);
    expect(before.difference(after).length, 1);
  });

  testWidgets('remove never goes below the minimum, and its button hides at the floor', (tester) async {
    await enterFlowFrom(tester);

    for (var n = initialCastSize; n > minCastSize; n--) {
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();
      expect(find.text('Obsazení: ${n - 1}/$maxCastSize'), findsOneWidget);
    }

    expect(find.text('Obsazení: $minCastSize/$maxCastSize'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('a narrow tradition caps the cast below the max instead of borrowing', (tester) async {
    // Germany currently has 5 extracted characters against a max of 6,
    // so the add card must run out one short — the alternative would be
    // padding a German story with a Danish character.
    const iso = 'DE';
    final cap = _poolSize(iso);
    expect(cap, lessThan(maxCastSize), reason: 'pick a narrower country for this test');

    await enterFlowFrom(tester, iso: iso);
    for (var n = initialCastSize; n < cap; n++) {
      await tester.tap(find.text('Přidat postavu'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Obsazení: $cap/$maxCastSize'), findsOneWidget);
    expect(find.text('Přidat postavu'), findsNothing);
    expect(_visibleMemberLabels(tester).length, cap);
  });
}
