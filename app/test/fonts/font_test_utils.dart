import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

/// Pomůcky battle testu CuteKidFonts (docs/cute-kid-fonts-battle-test.md).

/// Soubor fontu pro každou rodinu z [KidFonts]. Balíček tohle mapování
/// nevystavuje (je jen v `cute_kid_fonts_testing.dart` jako privátní
/// `_files`), proto ho tu opakujeme — viz nález „Pro CuteKidFonts“.
const kidFontFiles = {
  KidFonts.dynaPuff: 'DynaPuff-Variable.ttf',
  KidFonts.baloo2: 'Baloo2-Variable.ttf',
  KidFonts.grandstanderItalic: 'Grandstander-Italic-Variable.ttf',
  KidFonts.nunito: 'Nunito-Variable.ttf',
};

/// Krátké jméno rodiny do výpisů.
String faceName(String family) => family.split('/').last;

Future<Set<int>> loadCmap(String family) async {
  final data = await rootBundle.load('packages/${KidFonts.package}/fonts/${kidFontFiles[family]}');
  return readCmap(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

/// Minimální čtečka tabulky `cmap` (formáty 4 a 12, jen unicodové
/// podtabulky): všechny kódové body namapované na nenulový glyf.
/// Převzato z `CuteKidFonts/test/cmap.dart` — balíček ji neexportuje.
Set<int> readCmap(Uint8List bytes) {
  final d = ByteData.sublistView(bytes);
  final numTables = d.getUint16(4);
  int? cmapOffset;
  for (var i = 0; i < numTables; i++) {
    final rec = 12 + i * 16;
    if (String.fromCharCodes(bytes.sublist(rec, rec + 4)) == 'cmap') cmapOffset = d.getUint32(rec + 8);
  }
  if (cmapOffset == null) throw StateError('no cmap table');
  final result = <int>{};
  final n = d.getUint16(cmapOffset + 2);
  for (var i = 0; i < n; i++) {
    final rec = cmapOffset + 4 + i * 8;
    final platform = d.getUint16(rec);
    final encoding = d.getUint16(rec + 2);
    if (!(platform == 0 || (platform == 3 && (encoding == 1 || encoding == 10)))) continue;
    final sub = cmapOffset + d.getUint32(rec + 4);
    switch (d.getUint16(sub)) {
      case 4:
        final segX2 = d.getUint16(sub + 6);
        final ends = sub + 14;
        final starts = ends + segX2 + 2;
        final deltas = starts + segX2;
        final ranges = deltas + segX2;
        for (var s = 0; s < segX2 ~/ 2; s++) {
          final end = d.getUint16(ends + s * 2);
          final start = d.getUint16(starts + s * 2);
          final delta = d.getInt16(deltas + s * 2);
          final rangeAt = ranges + s * 2;
          final range = d.getUint16(rangeAt);
          for (var c = start; c <= end && c != 0xFFFF; c++) {
            int glyph;
            if (range == 0) {
              glyph = (c + delta) & 0xFFFF;
            } else {
              final g = d.getUint16(rangeAt + range + (c - start) * 2);
              glyph = g == 0 ? 0 : (g + delta) & 0xFFFF;
            }
            if (glyph != 0) result.add(c);
          }
        }
      case 12:
        final groups = d.getUint32(sub + 12);
        for (var g = 0; g < groups; g++) {
          final at = sub + 16 + g * 12;
          final start = d.getUint32(at);
          final end = d.getUint32(at + 4);
          final glyph = d.getUint32(at + 8);
          for (var c = start; c <= end; c++) {
            if (glyph + (c - start) != 0) result.add(c);
          }
        }
    }
  }
  return result;
}

/// Jeden znak z `test/fixtures/font_charset.json` (tool/collect_font_charset.py).
class DataChar {
  DataChar(Map<String, Object?> j)
      : char = j['char']! as String,
        cp = j['cp']! as String,
        name = j['name']! as String,
        category = j['category']! as String,
        count = j['count']! as int,
        sources = (j['sources']! as Map).cast<String, int>(),
        examples = (j['examples']! as List).cast<String>();

  final String char;
  final String cp;
  final String name;
  final String category;
  final int count;
  final Map<String, int> sources;
  final List<String> examples;
}

List<DataChar> loadDataChars() {
  final j = jsonDecode(File('test/fixtures/font_charset.json').readAsStringSync()) as Map<String, Object?>;
  return [for (final c in j['chars']! as List) DataChar((c as Map).cast<String, Object?>())];
}

Map<String, List<Map<String, Object?>>> loadLayoutSamples() {
  final j = jsonDecode(File('test/fixtures/font_layout_samples.json').readAsStringSync()) as Map<String, Object?>;
  return {for (final e in j.entries) e.key: [for (final s in e.value! as List) (s as Map).cast<String, Object?>()]};
}

/// Kam testy píšou čitelné výstupy (build/ je v .gitignore).
Directory reportDir() => Directory('build/cute_kid_fonts_battle')..createSync(recursive: true);

/// Obdélník skutečně namalovaných pixelů (alfa > 0) vůči levému hornímu
/// rohu layoutového boxu painteru. Painter se maluje s okrajem [margin]
/// na všechny strany, takže inkoust mimo box je vidět jako záporné
/// left/top nebo right/bottom větší než [KidBubblePainter.size].
Future<Rect?> inkBounds(KidBubblePainter painter, {double margin = 60}) async {
  final size = painter.size;
  final w = (size.width + margin * 2).ceil();
  final h = (size.height + margin * 2).ceil();
  final rec = ui.PictureRecorder();
  painter.paint(Canvas(rec), Offset(margin, margin));
  final image = rec.endRecording().toImageSync(w, h);
  final bytes = (await image.toByteData())!;
  image.dispose();
  int? l, t, r, b;
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      if (bytes.getUint8((y * w + x) * 4 + 3) == 0) continue;
      l = l == null || x < l ? x : l;
      r = r == null || x > r ? x : r;
      t ??= y;
      b = y;
    }
  }
  if (l == null) return null;
  return Rect.fromLTRB(l - margin, t! - margin, r! + 1 - margin, b! + 1 - margin);
}
