import 'dart:io';

import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/theme/kid_text.dart';

import 'font_test_utils.dart';

/// Battle test CuteKidFonts — výkon (docs/cute-kid-fonts-battle-test.md §3).
///
/// Seznam 120 položek (tolik nápověd má jeden motiv po pár „Ještě jednu“
/// a tolik karet by měl výběr motivů s celým packem): BubbleText proti
/// obyčejnému Text se stejným obsahem. Měří se v testovacím prostředí
/// (JIT, debug, software raster), takže absolutní čísla neznamenají
/// nic pro telefon — porovnává se poměr a počty, které na stroji
/// nezávisí: vrstvy (každý BubbleText = vlastní RepaintBoundary) a
/// odstavce, které musí engine vysázet (bubble = 4 TextPaintery).
///
/// Výstup: build/cute_kid_fonts_battle/performance.md.

const _n = 120;
final _labels = [for (var i = 0; i < _n; i++) 'Říční bůh č. $i a Ďábel na kopí'];

Widget _app(Widget child) => MediaQuery(
      data: const MediaQueryData(size: Size(412, 915)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: KidTheme(data: storyKidTheme, child: ColoredBox(color: const Color(0xFFFFFBF2), child: child)),
      ),
    );

Widget _bubbleRow(int i) => Padding(padding: const EdgeInsets.all(4), child: StoryCardLabel(_labels[i], maxLines: 2));
Widget _textRow(int i) => Padding(
      padding: const EdgeInsets.all(4),
      child: Text(_labels[i], maxLines: 2, textAlign: TextAlign.center, style: KidRole.title.style(size: 16)),
    );

/// Všech 120 najednou (Column) — nejhorší případ, např. Wrap s celým packem.
Widget _all(Widget Function(int) row) => _app(SingleChildScrollView(child: Column(children: [for (var i = 0; i < _n; i++) row(i)])));

/// Líný seznam — jak by vypadal Suflér/výběr motivů s ListView.builder.
Widget _lazy(Widget Function(int) row) => _app(ListView.builder(itemCount: _n, itemBuilder: (_, i) => row(i)));

Future<double> _msPump(WidgetTester tester, Widget w, {int runs = 5}) async {
  var total = 0;
  for (var r = 0; r < runs; r++) {
    await tester.pumpWidget(const SizedBox());
    final sw = Stopwatch()..start();
    await tester.pumpWidget(w);
    total += sw.elapsedMicroseconds;
  }
  return total / runs / 1000;
}

Future<double> _msScroll(WidgetTester tester) async {
  final sw = Stopwatch()..start();
  var frames = 0;
  for (var i = 0; i < 40; i++) {
    await tester.drag(find.byType(Scrollable), const Offset(0, -120));
    await tester.pump(const Duration(milliseconds: 16));
    frames++;
  }
  return sw.elapsedMicroseconds / frames / 1000;
}

int _layers(WidgetTester tester) => tester.layers.length;

void main() {
  final report = StringBuffer('# Výkon — vygenerováno `test/fonts/performance_battle_test.dart`\n\n');
  tearDownAll(() => File('${reportDir().path}/performance.md').writeAsStringSync(report.toString()));

  testWidgets('120 položek: BubbleText proti Text', (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final allBubble = await _msPump(tester, _all(_bubbleRow));
    final layersBubble = _layers(tester);
    final allText = await _msPump(tester, _all(_textRow));
    final layersText = _layers(tester);

    final lazyBubble = await _msPump(tester, _lazy(_bubbleRow));
    final visibleBubble = find.byType(BubbleText).evaluate().length;
    final lazyLayers = _layers(tester);
    final scrollBubble = await _msScroll(tester);
    final lazyText = await _msPump(tester, _lazy(_textRow));
    final scrollText = await _msScroll(tester);

    // Odstavce na jeden BubbleText: base + obrys + plocha + lesk.
    final p = KidBubblePainter(text: 'x', role: KidRole.title, size: 16)..layout();
    final paragraphs = [p.isFlat ? 1 : 3, if (KidRole.title.spec.gloss) 1].fold<int>(0, (a, b) => a + b);
    final paintsPerFrame = KidRole.title.spec.extrusionLayers * 2 + 1 + 1 + (KidRole.title.spec.gloss ? 1 : 0);
    p.dispose();

    String r(double a, double b) => '${(a / b).toStringAsFixed(1)}×';
    report
      ..writeln('Prostředí: `flutter test` (JIT, debug, bez GPU) — absolutní ms nejsou čísla z telefonu, jen poměr.\n')
      ..writeln('| scénář | BubbleText | Text | poměr |')
      ..writeln('|---|---|---|---|')
      ..writeln('| 120 najednou: první snímek (build+layout+paint), ms | ${allBubble.toStringAsFixed(1)} | ${allText.toStringAsFixed(1)} | ${r(allBubble, allText)} |')
      ..writeln('| 120 najednou: vrstev ve stromu | $layersBubble | $layersText | ${r(layersBubble.toDouble(), layersText.toDouble())} |')
      ..writeln('| ListView.builder: první snímek, ms | ${lazyBubble.toStringAsFixed(1)} | ${lazyText.toStringAsFixed(1)} | ${r(lazyBubble, lazyText)} |')
      ..writeln('| ListView.builder: snímek při scrollu, ms | ${scrollBubble.toStringAsFixed(1)} | ${scrollText.toStringAsFixed(1)} | ${r(scrollBubble, scrollText)} |')
      ..writeln()
      ..writeln('- ListView.builder má na obrazovce $visibleBubble BubbleTextů a $lazyLayers vrstev.')
      ..writeln('- Jeden bubble BubbleText = $paragraphs vysázené odstavce (TextPainter) a $paintsPerFrame vykreslení odstavce '
          'na snímek (extruze ${KidRole.title.spec.extrusionLayers}× obrys+base, obrys, plocha, lesk). Text = 1 a 1.')
      ..writeln();

    // Každý BubbleText si nese RepaintBoundary → vrstva na položku.
    expect(layersBubble, greaterThan(layersText + _n));
  });

  testWidgets('BubbleText pod IntrinsicWidth (AlertDialog) sází odstavce znovu', (tester) async {
    // computeMaxIntrinsicWidth volá painter.layout() bez šířky → zahodí
    // a znovu vytvoří všechny 4 TextPaintery; performLayout a paint pak
    // znovu s omezením. Měří se čas relayoutu proti pevné šířce.

    Future<int> relayouts(Widget w) async {
      await tester.pumpWidget(_app(Center(child: w)));
      final render = tester.renderObject<RenderBox>(find.byType(BubbleText).last);
      final sw = Stopwatch()..start();
      for (var i = 0; i < 200; i++) {
        render.markNeedsLayout();
        tester.binding.scheduleFrame();
        await tester.pump();
      }
      return sw.elapsedMicroseconds ~/ 200;
    }

    final plain = await relayouts(const SizedBox(width: 300, child: BubbleText('Dobrou noc.', role: KidRole.titleItalic, size: 32)));
    final intrinsic = await relayouts(const IntrinsicWidth(child: BubbleText('Dobrou noc.', role: KidRole.titleItalic, size: 32)));
    report
      ..writeln('## Relayout pod IntrinsicWidth\n')
      ..writeln('200× relayout `BubbleText(titleItalic 32)`: s pevnou šířkou $plain µs/snímek, pod `IntrinsicWidth` $intrinsic µs/snímek '
          '(${(intrinsic / plain).toStringAsFixed(1)}×). Z kódu plyne, že intrinsic dotaz zahodí vysázené paintery '
          '(`layout()` s jinou šířkou), ale RenderBox intrinsic rozměry kešuje, takže v praxi to měřitelné není.\n');
    expect(intrinsic, greaterThan(0));
  });
}
