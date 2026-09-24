import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/cast/cast_composer_screen.dart';
import 'package:storyteller/cast/cast_controller.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/main.dart';

// Restricted to known member labels (not the emoji glyph, not captions or
// buttons) so a reroll's before/after diff isn't polluted by the second
// Text node (the emoji) that changes alongside each label, or by static
// chrome that never changes.
final _knownLabels = mockCastPool.map((m) => m.label).toSet();

Set<String> _visibleMemberLabels(WidgetTester tester) => tester
    .widgetList<Text>(find.descendant(of: find.byType(CastComposerScreen), matching: find.byType(Text)))
    .map((t) => t.data)
    .whereType<String>()
    .where(_knownLabels.contains)
    .toSet();

void main() {
  testWidgets('app boots on the cast composer with the initial cast size', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: StorytellerApp()));
    await tester.pumpAndSettle();

    expect(find.byType(CastComposerScreen), findsOneWidget);
    expect(find.text('Obsazení: $initialCastSize/$maxCastSize'), findsOneWidget);
    expect(find.text('Přidat postavu'), findsOneWidget);
  });

  testWidgets('tapping a card rerolls just that slot (first rerolls are warm/instant)', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: StorytellerApp()));
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(const ProviderScope(child: StorytellerApp()));
    await tester.pumpAndSettle();

    for (var n = initialCastSize; n < maxCastSize; n++) {
      await tester.tap(find.text('Přidat postavu'));
      await tester.pumpAndSettle();
      expect(find.text('Obsazení: ${n + 1}/$maxCastSize'), findsOneWidget);
    }

    expect(find.text('Přidat postavu'), findsNothing);
    expect(find.text('Obsazení: $maxCastSize/$maxCastSize'), findsOneWidget);
  });

  testWidgets('once the warm-prewarm budget runs out, a reroll shows a loading veil and then resolves', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: StorytellerApp()));
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(const ProviderScope(child: StorytellerApp()));
    await tester.pumpAndSettle();

    for (var n = initialCastSize; n > minCastSize; n--) {
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();
      expect(find.text('Obsazení: ${n - 1}/$maxCastSize'), findsOneWidget);
    }

    expect(find.text('Obsazení: $minCastSize/$maxCastSize'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });
}
