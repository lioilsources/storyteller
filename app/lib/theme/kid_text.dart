import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

/// Typografie StoryTelleru nad balíčkem CuteKidFonts — jediné místo, kde
/// se role písma mapují na obrazovky (docs/cute-kid-fonts-battle-test.md).
///
/// | co | role | velikost |
/// |---|---|---|
/// | nadpis obrazovky (AppBar) | `title`, bubble | 26 |
/// | nadpis fáze vyprávění | `title`, bubble | 26 |
/// | jméno země na glóbu | `title`, bubble | 24 |
/// | nadpis sekce osnovy | `upper`, bubble | 17 |
/// | název karty na obrázku | `title`, bubble | 16 (13 v osnově) |
/// | název motivu v řádku osnovy | `dialog` | 18 |
/// | věty osnovy, nápovědy Suflérů | `body` | 18 |
/// | návody pod nadpisem | `body` | 15–16 |
/// | spojky („Jak navázat“) | `body` + kurzíva | 16 |
/// | čísla (obsazení, skóre nápovědy) | `number` | 20 / 12 |
/// | tlačítka, čipy, pole | Material `labelLarge`/`bodyLarge` v Baloo 2 | 16 |
/// | „Dobrou noc.“ | `titleItalic`, bubble | 32 |
///
/// Barvy zůstávají StoryTelleru: plochý text má hnědý inkoust appky
/// ([StoryInk]), ne tmavou barvu palety. Bubble písmo je v paletě
/// `peach` (cihlový obrys ladí s hnědou), pokrytá země `mint` (zelená =
/// „máme odsud pohádky“), závěrečný dialog `lavender` (noc).

/// Barvy textu appky (dřív hexy roztroušené po obrazovkách).
abstract final class StoryInk {
  static const ink = Color(0xFF3E2723);
  static const soft = Color(0x993E2723);
}

/// Výchozí paleta bubble písma. `onDark: false` — appka je světlá.
const storyKidTheme = KidThemeData(palette: KidPalette.peach);

/// Material téma: všechno, co nemá vlastní styl (tlačítka, čipy, pole,
/// dialogy), sází Baloo 2 se stejným fallbackem jako role CuteKidFonts.
///
/// Záměrně `fontFamily`, ne styly rolí: role nesou `FontVariation('wght')`,
/// a ta přebije `fontWeight`, kterým Material odlišuje tučnost — tlačítko
/// by pak bylo vždy v řezu role. Viz nález „Pro CuteKidFonts“ č. 3.
ThemeData storyThemeData() {
  final base = ThemeData(
    colorSchemeSeed: const Color(0xFF8D6E63),
    useMaterial3: true,
    fontFamily: KidFonts.baloo2,
    fontFamilyFallback: KidFonts.fallback,
  );
  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      // Tlačítka a čipy: 16 / SemiBold — dětská appka, ale ovládá ji rodič.
      labelLarge: base.textTheme.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 17),
    ),
  );
}

/// Plochý styl role v barvě appky — pro dlouhé texty (nápovědy, osnova).
extension StoryKidStyle on BuildContext {
  TextStyle kid(KidRole role, {double? size, Color? color, FontStyle? fontStyle}) {
    final s = KidTheme.of(this).style(role, size: size, color: color ?? StoryInk.ink);
    return fontStyle == null ? s : s.copyWith(fontStyle: fontStyle);
  }
}

/// Nadpis obrazovky do AppBaru: bubble `title`, jeden řádek.
class StoryTitle extends StatelessWidget {
  const StoryTitle(this.text, {super.key, this.size = 26, this.palette, this.maxLines = 1});

  final String text;
  final double size;
  final KidPalette? palette;
  final int maxLines;

  @override
  Widget build(BuildContext context) =>
      BubbleText(text, role: KidRole.title, size: size, palette: palette, align: TextAlign.start, maxLines: maxLines);
}

/// Název karty přes obrázek (postava, motiv): bubble `title` na
/// tmavém přechodu dole na kartě.
class StoryCardLabel extends StatelessWidget {
  const StoryCardLabel(this.text, {super.key, this.size = 16, this.maxLines = 3});

  final String text;
  final double size;
  final int maxLines;

  @override
  Widget build(BuildContext context) => BubbleText(text, role: KidRole.title, size: size, maxLines: maxLines);
}

/// Nadpis sekce (osnova): bubble `upper`.
class StorySectionTitle extends StatelessWidget {
  const StorySectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => BubbleText(text, role: KidRole.upper, size: 17, align: TextAlign.start);
}
