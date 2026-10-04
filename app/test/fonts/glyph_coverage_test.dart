import 'dart:io';

import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/widgets.dart' show StringCharacters;
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'font_test_utils.dart';

/// Battle test CuteKidFonts — pokrytí znaků (docs/cute-kid-fonts-battle-test.md §1).
///
/// Pro každou roli a každý znak, který StoryTeller může ukázat (všechna
/// česká data + UI, `test/fixtures/font_charset.json`) a pro sondu
/// „co přijde s dalšími zeměmi“ ([_probe]) zjistí, jestli ho vykreslí
/// primární řez role, nebo spadne do fallbacku (Baloo 2 → Nunito = jiný
/// styl uprostřed slova), nebo nemá glyf nikdo z řetězce (na zařízení
/// systémový font, v testu tofu).
///
/// Dvě nezávislá měření:
///  * `cmap` fontu (co font deklaruje),
///  * `TextPainter`: šířka znaku v řezu *bez* fallbacku proti šířce
///    `.notdef` téhož řezu (plán CuteKidFonts, „Ověření“). To je to, co
///    Flutter opravdu vykreslí — HarfBuzz umí znak bez předsloženého
///    glyfu poskládat z base + kombinující diakritiky, cmap to nevidí.
///
/// Výstup: build/cute_kid_fonts_battle/coverage.md (do dokumentu).
/// Známé díry jsou připnuté v [_knownDataGaps] — když balíček přidá
/// glyfy nebo data přinesou nový znak, test spadne a řekne co přepsat.

/// Znaky, které data zatím nemají, ale přijdou s dalšími zeměmi a
/// cizími jmény (řecké a pálijské přepisy, evropská diakritika,
/// typografie). Hlídají, co se stane, až je pipeline vypíše.
const _probe = {
  'řečtina': 'αβγδεζηθικλμνξοπρστυφχψω ΑΒΓΔΘΛΞΠΣΦΨΩ άέήίόύώ',
  'pálí / sanskrt (IAST)': 'āīūṃṁṅñṭḍṇḷṛṝśṣ ĀĪŪṂṄṬḌṆḶṚŚṢ',
  'evropská diakritika': 'łŁőŐűŰşŞţŢñÑäÄöÖüÜßøØåÅæÆœŒğĞıİçÇàâêëîïôûąężćńĄĘŻĆŃľĽĺĹŕŔ',
  'azbuka': 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя АБВГДЕЁЖЗИЙ',
  'typografie': '„“‚‘’«»‹›–—…·•°№×÷′″ʼ€§',
  'emoji': '🦊👑🐉✨🌅',
};

const _skip = {0x20, 0xA0, 0xFE0F, 0x200D};

/// Řetězec rodin pro roli.
List<String> _chain(KidRole role) => [role.spec.family, ...KidFonts.fallback];

/// Váha, kterou role pro danou rodinu použije (osa wght je u každého řezu jinak dlouhá).
double _weightFor(String family, double w) => switch (family) {
      KidFonts.dynaPuff => w.clamp(400, 700),
      KidFonts.baloo2 => w.clamp(400, 800),
      KidFonts.grandstanderItalic => w.clamp(100, 900),
      _ => w.clamp(200, 1000),
    };

TextStyle _only(String family, KidRole role) => TextStyle(
      fontFamily: family,
      fontFamilyFallback: const [],
      fontSize: 40,
      fontStyle: role.spec.italic && family == KidFonts.grandstanderItalic ? FontStyle.italic : FontStyle.normal,
      fontVariations: [FontVariation.weight(_weightFor(family, role.spec.weight))],
    );

double _width(String text, TextStyle style) {
  final p = TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr)..layout();
  final w = p.width;
  p.dispose();
  return w;
}

/// Glyf .notdef: kódový bod, který žádný z řezů nemapuje.
const _notdefProbe = '\u{10FFFD}';

enum Verdict { primary, fallback, missing }

class _Hit {
  _Hit(this.verdict, this.face, this.cmapAgrees);
  final Verdict verdict;
  final String? face; // kdo znak opravdu vykreslí
  final bool cmapAgrees;
}

void main() {
  late Map<String, Set<int>> cmaps;
  final dataChars = loadDataChars();

  setUpAll(() async {
    cmaps = {for (final f in kidFontFiles.keys) f: await loadCmap(f)};
  });

  _Hit judge(KidRole role, String ch) {
    final text = role.spec.apply(ch);
    for (final (i, family) in _chain(role).indexed) {
      final style = _only(family, role);
      final notdef = _width(_notdefProbe, style);
      final w = _width(text, style);
      // Víc znaků po transformaci (ß → SS): notdef by dal n× šířku.
      final differs = (w - notdef * text.runes.length).abs() > 0.01;
      final inCmap = text.runes.every(cmaps[family]!.contains);
      // Šířka shodná s .notdef u glyfu, který cmap má = náhodná kolize
      // šířek, ne chybějící glyf; opačný případ = HarfBuzz rozklad.
      if (differs || inCmap) {
        return _Hit(i == 0 ? Verdict.primary : Verdict.fallback, faceName(family), differs == inCmap);
      }
    }
    return _Hit(Verdict.missing, null, !_chain(role).any((f) => text.runes.every(cmaps[f]!.contains)));
  }

  test('pokrytí znaků z dat a sondy pro každou roli', () {
    final report = StringBuffer()
      ..writeln('# Pokrytí znaků — vygenerováno `test/fonts/glyph_coverage_test.dart`')
      ..writeln()
      ..writeln('${dataChars.length} unikátních znaků v datech + UI.')
      ..writeln();
    final dataGaps = <String, String>{}; // role → znaky mimo primární řez (data)
    final disagreements = <String>[];

    for (final role in KidRole.values) {
      final fallback = <DataChar>[];
      final missing = <DataChar>[];
      for (final c in dataChars) {
        if (c.char.runes.any(_skip.contains)) continue;
        final hit = judge(role, c.char);
        if (!hit.cmapAgrees) disagreements.add('${role.name} ${c.cp} ${c.char} → ${hit.verdict.name} (${hit.face})');
        switch (hit.verdict) {
          case Verdict.primary:
            break;
          case Verdict.fallback:
            fallback.add(c);
          case Verdict.missing:
            missing.add(c);
        }
      }
      dataGaps[role.name] = [...fallback, ...missing].where((c) => c.category != 'emoji').map((c) => c.char).join();

      report
        ..writeln('## ${role.name} — ${faceName(role.spec.family)} ${role.spec.weight.round()}')
        ..writeln();
      if (fallback.isEmpty && missing.where((c) => c.category != 'emoji').isEmpty) {
        report.writeln('Data: vše v primárním řezu (kromě emoji).');
      }
      for (final (label, list) in [('spadne do fallbacku', fallback), ('nemá nikdo z řetězce', missing)]) {
        final shown = list.where((c) => c.category != 'emoji').toList();
        if (shown.isEmpty) continue;
        report
          ..writeln()
          ..writeln('**Data — $label:**')
          ..writeln()
          ..writeln('| znak | kód | výskytů | kdo vykreslí | kde v datech |')
          ..writeln('|---|---|---|---|---|');
        for (final c in shown) {
          final face = judge(role, c.char).face ?? '— (systém / tofu)';
          final where = c.sources.entries.take(3).map((e) => '${e.key} ×${e.value}').join(', ');
          final ex = c.examples.first.replaceAll('|', '\\|');
          report.writeln('| `${c.char}` | ${c.cp} | ${c.count} | $face | $where — $ex |');
        }
      }
      final emoji = missing.where((c) => c.category == 'emoji').length;
      if (emoji > 0) report.writeln('\nEmoji v datech/UI: $emoji, žádný řez je nemá (očekávané, na zařízení kreslí systémový emoji font).');

      report
        ..writeln()
        ..writeln('**Sonda (znaky, které data zatím nemají):**')
        ..writeln()
        ..writeln('| skupina | primární | fallback | nikdo |')
        ..writeln('|---|---|---|---|');
      for (final MapEntry(key: group, value: chars) in _probe.entries) {
        final prim = StringBuffer(), fb = StringBuffer(), none = StringBuffer();
        for (final ch in chars.characters) {
          if (ch.runes.any(_skip.contains)) continue;
          final hit = judge(role, ch);
          (switch (hit.verdict) { Verdict.primary => prim, Verdict.fallback => fb, Verdict.missing => none }).write(ch);
        }
        String cell(StringBuffer b) => b.isEmpty ? '—' : '`$b`';
        report.writeln('| $group | ${cell(prim)} | ${cell(fb)} | ${cell(none)} |');
      }
      report.writeln();
    }

    if (disagreements.isNotEmpty) {
      report
        ..writeln('## Nesoulad cmap × TextPainter')
        ..writeln()
        ..writeln('Znaky, kde font v cmap glyf nemá, ale Flutter ho přesto vykreslí (HarfBuzz rozklad na base + kombinující znaménko), nebo naopak.')
        ..writeln();
      for (final d in disagreements.toSet()) {
        report.writeln('- $d');
      }
    }

    File('${reportDir().path}/coverage.md').writeAsStringSync(report.toString());
    expect(dataGaps, _knownDataGaps,
        reason: 'Pokrytí znaků z dat se změnilo — přegeneruj coverage.md, '
            'aktualizuj docs/cute-kid-fonts-battle-test.md §1 a _knownDataGaps.');
  });
}

/// Znaky z dat (bez emoji), které role NEvykreslí svým primárním řezem.
/// Stav pro cute_kid_fonts v0.1.1 a data k 2026-10-04.
///
/// `бимнощ` jsou cyrilské homoglyfy uvnitř českých slov („napodобиá“,
/// „zvоном“, „plщщem“) — chyba generování dat, ne fontu; fonty ji jen
/// zviditelnily (Nunito je jediný řez s azbukou). `→` v Grandstanderu
/// chybí (UI „Pokračovat →“ by v `titleItalic` spadlo do Baloo 2).
const _cyrillicDataBug = 'бимнощ';
const _knownDataGaps = <String, String>{
  'title': _cyrillicDataBug,
  'titleItalic': '$_cyrillicDataBug→',
  'upper': _cyrillicDataBug,
  'lower': _cyrillicDataBug,
  'body': _cyrillicDataBug,
  'dialog': _cyrillicDataBug,
  'key': _cyrillicDataBug,
  'number': _cyrillicDataBug,
};
