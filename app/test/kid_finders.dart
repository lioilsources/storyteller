import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Nadpisy a názvy karet jsou od CuteKidFonts `BubbleText` — vlastní
/// render object, ne `Text`, takže je `find.text` nenajde. Tohle najde
/// obojí (nález „Pro CuteKidFonts“: balíček žádný finder nemá).
Finder findKidText(String text) => find.byWidgetPredicate(
      (w) => (w is BubbleText && w.text == text) || (w is Text && (w.data ?? w.textSpan?.toPlainText()) == text),
      description: 'Text nebo BubbleText "$text"',
    );

/// Text všech `Text` i `BubbleText` pod [finder].
Iterable<String> kidTexts(WidgetTester tester, Finder finder) => tester.widgetList(finder).map(
      (w) => switch (w) {
        BubbleText(:final text) => text,
        Text(:final data, :final textSpan) => data ?? textSpan?.toPlainText(),
        _ => null,
      },
    ).whereType<String>();
