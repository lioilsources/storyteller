import 'dart:io';

import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/theme/kid_text.dart';

import 'font_test_utils.dart';

/// Battle test CuteKidFonts — layout (docs/cute-kid-fonts-battle-test.md §2).
///
/// 1. Inkoust mimo layoutový box: obrys, extruze a diakritika verzálek
///    (Ř Ů Ž) kreslí mimo velikost, kterou BubbleText hlásí rodiči.
/// 2. Slévání řádků: dolní dotahy + extruze řádku N proti háčkům
///    verzálek řádku N+1 při výšce řádku role.
/// 3. Mezera mezi slovy, kterou sní obrys.
/// 4. Goldeny nejhorších případů z dat (nejdelší názvy, nejdelší slovo,
///    velké písmo systému) v reálných rozměrech karet appky.
///
/// Čísla jdou do build/cute_kid_fonts_battle/layout.md; asserty hlídají
/// jen to, na co appka spoléhá (nic nepřeteče, karty nevyhodí výjimku),
/// a pinují známé vady, aby oprava v balíčku byla vidět.

KidBubblePainter _painter(String text, KidRole role, double size, {double maxWidth = double.infinity}) =>
    KidBubblePainter(text: text, role: role, size: size)..layout(maxWidth: maxWidth);

/// Velikosti, ve kterých StoryTeller role opravdu používá.
const _appSizes = <KidRole, List<double>>{
  KidRole.title: [13, 16, 24, 26, 48],
  KidRole.titleItalic: [32, 48],
  KidRole.upper: [17, 48],
  KidRole.body: [13, 18],
  KidRole.dialog: [15, 18],
  KidRole.number: [13, 20],
};

void main() {
  final report = StringBuffer('# Layout — vygenerováno `test/fonts/layout_battle_test.dart`\n\n');
  final overflow = <String, Rect>{}; // "role@size" → přesah inkoustu (kladné = mimo box)
  final collision = <String, double>{};
  final wordGap = <String, double>{};

  tearDownAll(() => File('${reportDir().path}/layout.md').writeAsStringSync(report.toString()));

  test('inkoust mimo layoutový box', () async {
    report
      ..writeln('## Inkoust mimo box (px, kladné = kreslí mimo `size`)\n')
      ..writeln('Text `ŘŮŽ Ďábel gjy` na jednom řádku.\n')
      ..writeln('| role | velikost | nahoře | dole | vlevo | vpravo |')
      ..writeln('|---|---|---|---|---|---|');
    for (final MapEntry(key: role, value: sizes) in _appSizes.entries) {
      for (final size in sizes) {
        final p = _painter('ŘŮŽ Ďábel gjy', role, size);
        final ink = (await inkBounds(p))!;
        final o = Rect.fromLTRB(-ink.left, -ink.top, ink.right - p.size.width, ink.bottom - p.size.height);
        overflow['${role.name}@${size.round()}'] = o;
        String f(double v) => v > 0.5 ? '**${v.toStringAsFixed(1)}**' : v.toStringAsFixed(1);
        report.writeln('| ${role.name} | ${size.round()} | ${f(o.top)} | ${f(o.bottom)} | ${f(o.left)} | ${f(o.right)} |');
        p.dispose();
      }
    }
    report.writeln();
    // Známá vada v0.1.1: Grandstander Italic kreslí kroužek/háček verzálek
    // nad box (výška řádku 1.15 při ascentu fontu 0.73 em).
    expect(overflow['titleItalic@32']!.top, greaterThan(1), reason: 'titleItalic už nepřetéká nahoru — aktualizuj dokument');
  });

  test('slévání řádků víceřádkového bubble textu', () async {
    report
      ..writeln('## Slévání řádků (px)\n')
      ..writeln('Dolní inkoust řádku s `gjyp` (dotahy + obrys + extruze) + horní inkoust řádku s `ŘŮŽĎ` (háčky + obrys) − výška řádku. '
          'Kladné = inkoust dvou řádků se překrývá.\n')
      ..writeln('| role | velikost | výška řádku | pod účařím | nad účařím | překryv |')
      ..writeln('|---|---|---|---|---|---|');
    for (final role in [KidRole.title, KidRole.titleItalic, KidRole.upper, KidRole.body, KidRole.dialog]) {
      for (final size in _appSizes[role]!) {
        final down = _painter('gjyp', role, size);
        final up = _painter('ŘŮŽĎ', role, size);
        final inkDown = (await inkBounds(down))!;
        final inkUp = (await inkBounds(up))!;
        final below = inkDown.bottom - down.baseline;
        final above = up.baseline - inkUp.top;
        final line = down.fontSize * role.spec.height;
        final c = below + above - line;
        collision['${role.name}@${size.round()}'] = c;
        report.writeln('| ${role.name} | ${size.round()} | ${line.toStringAsFixed(1)} | ${below.toStringAsFixed(1)} | '
            '${above.toStringAsFixed(1)} | ${c > 0 ? '**${c.toStringAsFixed(1)}**' : c.toStringAsFixed(1)} |');
        down.dispose();
        up.dispose();
      }
    }
    report.writeln();
    // Ploché role s diakritikou nesmí slévat (čitelnost dlouhých textů).
    expect(collision['body@18']!, lessThanOrEqualTo(0));
    expect(collision['dialog@18']!, lessThanOrEqualTo(0));
    // Známá vada: bubble title se při zalomení slévá (karty, nadpis fáze).
    expect(collision['title@16']!, greaterThan(0), reason: 'title už se neslévá — aktualizuj dokument');
  });

  test('mezera mezi slovy, kterou sní obrys', () {
    report
      ..writeln('## Mezera mezi slovy (px)\n')
      ..writeln('Šířka mezery v řezu minus šířka obrysu (obrys přidá půl šířky na každou stranu sousedních písmen). '
          'Plochý text = celá mezera.\n')
      ..writeln('| role | velikost | mezera | obrys | zbývá | zbývá % |')
      ..writeln('|---|---|---|---|---|---|');
    for (final role in [KidRole.title, KidRole.titleItalic, KidRole.upper]) {
      for (final size in _appSizes[role]!) {
        final flat = KidBubblePainter(text: 'a a', role: role, size: size, flat: true)..layout();
        final aa = KidBubblePainter(text: 'aa', role: role, size: size, flat: true)..layout();
        final space = flat.size.width - aa.size.width;
        final stroke = _painter('a', role, size).strokeWidth;
        final left = space - stroke;
        wordGap['${role.name}@${size.round()}'] = left / space;
        report.writeln('| ${role.name} | ${size.round()} | ${space.toStringAsFixed(1)} | ${stroke.toStringAsFixed(1)} | '
            '${left.toStringAsFixed(1)} | ${(left / space * 100).round()} % |');
        flat.dispose();
        aa.dispose();
      }
    }
    report.writeln();
    expect(wordGap['title@16']!, lessThan(0.75), reason: 'obrys už mezeru nežere — aktualizuj dokument');
  });

  // Goldeny jsou citlivé na rasterizaci (macOS × Linux v CI) — stejný tag
  // jako test/screenshots_test.dart, CI je vynechává.
  group('nejhorší případy z dat v kartách appky', () {
    final samples = loadLayoutSamples();
    final longestTitles = [for (final s in samples['titles']!.take(3)) s['text']! as String];
    final longestWord = samples['titles_longest_word']!.first['text']! as String;

    Widget card(String label, {double width = 132, double height = 168, double size = 16, int maxLines = 3}) => SizedBox(
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF9FA8DA)]))),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54])),
                    child: StoryCardLabel(label, size: size, maxLines: maxLines),
                  ),
                ),
              ],
            ),
          ),
        );

    Future<void> shoot(WidgetTester tester, Widget child, String name, {Size size = const Size(560, 420), double textScale = 1}) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: KidTheme(
            data: storyKidTheme,
            child: ColoredBox(color: const Color(0xFFFFFBF2), child: Padding(padding: const EdgeInsets.all(16), child: child)),
          ),
        ),
      ));
      expect(tester.takeException(), isNull, reason: name);
      await expectLater(find.byType(ColoredBox).first, matchesGoldenFile('goldens/$name.png'));
    }

    testWidgets('nejdelší názvy karet (postava 132, motiv 140, Suflér 100, osnova 84)', tags: 'screenshots', (tester) async {
      await shoot(
        tester,
        Wrap(spacing: 12, runSpacing: 12, children: [
          for (final t in longestTitles) card(t),
          card(longestTitles.first, width: 140, height: 170),
          card(longestWord),
          card(longestTitles.first, width: 100, height: 132, maxLines: 2),
          card(longestTitles.first, width: 84, height: 108, size: 13, maxLines: 1),
        ]),
        'karty-nejdelsi-nazvy',
        size: const Size(620, 420),
      );
    });

    testWidgets('karty při velkém písmu systému (textScaler 1.3)', tags: 'screenshots', (tester) async {
      await shoot(
        tester,
        Wrap(spacing: 12, runSpacing: 12, children: [for (final t in [...longestTitles.take(2), 'Moudrý kůň', 'Říční bůh']) card(t)]),
        'karty-text-scale-1_3',
        textScale: 1.3,
        size: const Size(620, 230),
      );
    });

    testWidgets('víceřádkové bubble nadpisy: slévání řádků a přechod plochy', tags: 'screenshots', (tester) async {
      await shoot(
        tester,
        SizedBox(
          width: 372, // nadpis fáze vyprávění na 412dp telefonu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const StoryTitle('Co se postavilo do cesty — Říční bůh a Ďábel na kopí', maxLines: 3),
              const SizedBox(height: 16),
              const BubbleText('Dobrou noc, Ůžasný Řízku. Ďábel gjy', role: KidRole.titleItalic, size: 32, palette: KidPalette.lavender, align: TextAlign.start),
              const SizedBox(height: 16),
              StorySectionTitle(samples['titles']![3]['text']! as String),
            ],
          ),
        ),
        'nadpisy-viceradkove',
        size: const Size(420, 460),
      );
    });

    testWidgets('nejdelší nápověda a věta ploše (body 18)', tags: 'screenshots', (tester) async {
      final hint = samples['hints']!.first['text']! as String;
      final sentence = samples['sentences']!.first['text']! as String;
      await shoot(
        tester,
        SizedBox(
          width: 372,
          child: Builder(
            builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final t in [hint, sentence])
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(14)),
                    child: Text(t, style: context.kid(KidRole.body)),
                  ),
              ],
            ),
          ),
        ),
        'napoveda-nejdelsi',
        size: const Size(404, 700),
      );
    });
  });
}
