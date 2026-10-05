import 'dart:io';

import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/theme/kid_text.dart';

import 'font_test_utils.dart';

/// Battle test CuteKidFonts — čitelnost (docs/cute-kid-fonts-battle-test.md §4).
/// Plán balíčku: dialog/body ≥ 18 pt, kontrast plocha/obrys ≥ 4.5:1.
/// Kontrast WCAG 2 přes `kidContrastRatio` z balíčku; poloprůhledné
/// barvy se nejdřív smíchají s pozadím.

const _cream = Color(0xFFFFFBF2); // pozadí obrazovek
const _hintCard = Color(0xFFFFF3E0); // karta nápovědy / osnovy
const _white = Color(0xFFFFFFFF); // spodní lišty, karta země

/// Popisek karty leží na `black54` přes obrázek; nejhorší případ je
/// světlý obrázek → šedá ~#757575.
final _cardOverlayOnWhite = Color.alphaBlend(const Color(0x8A000000), _white);

Color _over(Color fg, Color bg) => Color.alphaBlend(fg, bg);

void main() {
  test('kontrast a velikosti textů appky', () {
    final rows = <(String, String, double, double)>[
      ('body/dialog inkoust na pozadí', 'body 18', kidContrastRatio(StoryInk.ink, _cream), 18),
      ('body inkoust na kartě nápovědy', 'body 18', kidContrastRatio(StoryInk.ink, _hintCard), 18),
      ('návody (soft 60 %) na pozadí', 'body 15', kidContrastRatio(_over(StoryInk.soft, _cream), _cream), 15),
      ('kurzíva „Nápověda —“ (soft) na pozadí', 'body 14', kidContrastRatio(_over(StoryInk.soft, _cream), _cream), 14),
      ('skóre nápovědy (soft) na kartě', 'number 13', kidContrastRatio(_over(StoryInk.soft, _hintCard), _hintCard), 13),
      for (final p in [KidPalette.peach, KidPalette.mint, KidPalette.lavender]) ...[
        ('${p.name}: obrys na pozadí', 'bubble', kidContrastRatio(p.dark, _cream), 0),
        ('${p.name}: obrys na bílé liště', 'bubble', kidContrastRatio(p.dark, _white), 0),
        ('${p.name}: plocha (mid) proti obrysu', 'bubble', kidContrastRatio(p.mid, p.dark), 0),
        ('${p.name}: plocha (light) na pozadí — bez obrysu', 'bubble', kidContrastRatio(p.light, _cream), 0),
      ],
      ('peach plocha (mid) na kartě přes světlý obrázek', 'title 16', kidContrastRatio(KidPalette.peach.mid, _cardOverlayOnWhite), 16),
      ('peach obrys na kartě přes světlý obrázek', 'title 16', kidContrastRatio(KidPalette.peach.dark, _cardOverlayOnWhite), 16),
    ];
    final out = StringBuffer('# Čitelnost — vygenerováno `test/fonts/readability_battle_test.dart`\n\n')
      ..writeln('| co | role | kontrast | ≥ 4.5 |')
      ..writeln('|---|---|---|---|');
    for (final (what, role, ratio, _) in rows) {
      out.writeln('| $what | $role | ${ratio.toStringAsFixed(2)}:1 | ${ratio >= 4.5 ? 'ano' : '**ne**'} |');
    }
    File('${reportDir().path}/readability.md').writeAsStringSync(out.toString());

    expect(rows[0].$3, greaterThanOrEqualTo(4.5));
    expect(rows[1].$3, greaterThanOrEqualTo(4.5));
    // Hlavní čtený text (osnova, nápovědy) je v appce body 18.
    expect(KidRole.body.spec.size, greaterThanOrEqualTo(18));
  });
}
