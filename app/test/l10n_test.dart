import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/l10n/l10n.dart';
import 'package:storyteller/l10n/lang.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/narrate/beat.dart';
import 'package:storyteller/rag/rag_store.dart';

void main() {
  test('every ARB has the same keys as the Czech template', () {
    Set<String> keys(String f) => {for (final k in (jsonDecode(File('lib/l10n/$f').readAsStringSync()) as Map).keys) if (!(k as String).startsWith('@')) k};
    expect(keys('app_en.arb'), keys('app_cs.arb'));
  });

  test('Czech and Slovak devices get Czech, everything else English', () {
    expect(resolveLang(const [Locale('cs', 'CZ')]), 'cs');
    expect(resolveLang(const [Locale('sk')]), 'cs');
    expect(resolveLang(const [Locale('de'), Locale('en', 'GB')]), 'en');
    expect(resolveLang(const [Locale('ja')]), 'en');
  });

  test('English plurals', () {
    final en = lookupAppLocalizations(const Locale('en')), cs = lookupAppLocalizations(const Locale('cs'));
    expect(en.motifsFromTales(1, 2), '1 motif from 2 tales');
    expect(cs.motifsFromTales(3, 1), '3 motivy z 1 pohádky');
    expect(cs.motifsFromTales(5, 7), '5 motivů z 7 pohádek');
    expect(cs.restoreDone(3), 'Obnoveno 3 díly. Stáhneš je z planety.');
  });

  test('English prompts stay open questions and fill the character in', () {
    for (final beat in StoryBeat.values) {
      for (final h in rawHints(beat, lang: 'en')) {
        expect(h.endsWith('?') || h.endsWith('…'), isTrue, reason: h);
        expect(h, isNot(matches(RegExp(r'\b(he|she|him|her|his)\b'))), reason: 'no gendered pronoun: $h');
      }
      for (final h in hintsFor(beat, const [], lang: 'en')) {
        expect(h, isNot(contains('{postava}')));
      }
    }
  });

  test('every curated card has an English label', () {
    for (final m in castPoolIn('en')) {
      expect(m.label, isNot(equals(mockCastPool.firstWhere((c) => c.id == m.id).label)), reason: m.id);
    }
    for (final c in MotifCategory.values) {
      for (final m in motifPoolIn(c, 'en')) {
        expect(m.label, isNot(equals(motifPools[c]!.firstWhere((x) => x.id == m.id).label)), reason: m.id);
      }
    }
  });

  test('packs are picked by the language in their file name', () {
    expect(RagStore.isPackInLang('assets/rag/packs/core.cs.db', 'cs'), isTrue);
    expect(RagStore.isPackInLang('assets/rag/packs/core.cs.db', 'en'), isFalse);
    expect(RagStore.isPackInLang('region.CZSK.en.free.db', 'en'), isTrue);
    expect(RagStore.isPackInLang('/x/packs/region.CZSK.cs.p1/kz.db', 'en'), isTrue); // no language in the name
    expect(RagStore.contentLangOf(['assets/rag/packs/core.cs.db'], 'en'), 'cs');
    expect(RagStore.contentLangOf(['assets/rag/packs/core.cs.db', 'assets/rag/packs/core.en.db'], 'en'), 'en');
  });
}
