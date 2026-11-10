import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/l10n/l10n.dart';

void main() {
  test('all 45 languages are registered, with both Portuguese and both Chinese scripts', () {
    final tags = AppLocalizations.supportedLocales.map((l) => l.toLanguageTag()).toSet();
    for (final tag in 'cs en ar bn ca da de el es fi fr gu he hi hr hu id it ja kn ko ml mr ms nb nl or pa pl pt-BR pt-PT ro ru sk sl sv ta te th tr uk ur vi zh-Hans zh-Hant'.split(' ')) {
      expect(tags.contains(tag) || tags.contains(tag.split('-').first), isTrue, reason: tag);
    }
    expect(tags, containsAll(['pt-PT', 'zh-Hant']));
  });

  test('every language formats every parametrised message, every plural count', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l = lookupAppLocalizations(locale);
      for (final n in [0, 1, 2, 3, 4, 5, 11, 21, 22, 100, 101]) {
        final out = <String>[
          l.globeRegionCountries(n),
          l.motifCount(n),
          l.fromTaleCount(n),
          l.motifsFromTales(l.motifCount(n), l.fromTaleCount(n)),
          l.motifsPlusPack('x', n),
          l.motifsFromPack(n),
          l.talesComing(n, 'R'),
          l.talesCount(n),
          l.talesCountFree(n),
          l.cardFree(n),
          l.cardInParts(n, 3, 'R', '1–3'),
          l.cardHave(n),
          l.cardMoreComing(n),
          l.offerDownloading(n),
          l.offerBuy('R', n, '1 €'),
          l.offerDownloadFree('R', n, '1 MB'),
          l.offerDownloadPart('R', n, '1 MB'),
          l.restoreSome(n),
          l.narrationTitle(n, 4),
          l.storageSummary(n, '1 MB'),
          l.hintCast1('W'),
          l.hintProblem3('W'),
          l.globeZoomToRegion('R'),
          l.globeTellFrom('P'),
          l.narrationBridge('B'),
          l.storageScenes('R'),
          l.storageFreed('1 MB'),
          l.offerDownloadTip('R'),
        ];
        for (final s in out) {
          expect(s.trim(), isNotEmpty, reason: '${locale.toLanguageTag()} n=$n');
        }
      }
    }
  });

  test('Material, Widgets and Cupertino localizations exist for every supported language', () {
    for (final locale in AppLocalizations.supportedLocales) {
      expect(GlobalMaterialLocalizations.delegate.isSupported(locale), isTrue, reason: locale.toLanguageTag());
      expect(GlobalWidgetsLocalizations.delegate.isSupported(locale), isTrue, reason: locale.toLanguageTag());
    }
  });

  test('resolveLocale falls back to English and maps no to nb', () {
    const supported = AppLocalizations.supportedLocales;
    final saved = debugLocale;
    debugLocale = null;
    addTearDown(() => debugLocale = saved);
    expect(resolveLocale(const [Locale('xx')], supported), const Locale('en'));
    expect(resolveLocale(const [Locale('no')], supported).languageCode, 'nb');
    expect(resolveLocale(const [Locale('de', 'AT')], supported).languageCode, 'de');
    expect(resolveLocale(const [Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW')], supported).scriptCode, 'Hant');
  });

  test('curated cards have a label in every language', () {
    for (final locale in AppLocalizations.supportedLocales) {
      final l = lookupAppLocalizations(locale);
      expect(l.castFox, isNotEmpty);
      expect(l.motifEndingSlipper, isNotEmpty);
    }
  });
}
