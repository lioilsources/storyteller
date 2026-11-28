import 'package:flutter/widgets.dart' show Locale, WidgetsBinding;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Jazyky rozhraní (lib/l10n/app_*.arb). Obsah balíčků (karty, nápovědy,
/// přechody) jde za ním, pokud ho binárka v tom jazyce nese — jinak česky,
/// viz `RagStore.openBundled`.
const supportedLangs = ['cs', 'en'];

/// `--dart-define=STORYTELLER_LANG=en` přebije jazyk zařízení (screenshoty, vývoj).
const _forced = String.fromEnvironment('STORYTELLER_LANG');

/// Jazyk zařízení → jazyk appky: čeština a slovenština česky (Slovák
/// češtině rozumí líp než angličtině), všechno ostatní anglicky.
String resolveLang(Iterable<Locale> device) {
  if (supportedLangs.contains(_forced)) return _forced;
  for (final l in device) {
    switch (l.languageCode) {
      case 'cs' || 'sk':
        return 'cs';
      case 'en':
        return 'en';
    }
  }
  return 'en';
}

/// Jazyk rozhraní pro tenhle běh appky. Přepnutí jazyka v systému iOS
/// i Android appku restartuje, takže se počítá jednou. Přes binding,
/// ne `PlatformDispatcher.instance`: testy jazyk nastavují na bindingu.
final appLangProvider = Provider<String>((ref) => resolveLang(WidgetsBinding.instance.platformDispatcher.locales));

/// Jméno z geo assetu (`assets/geo/*.json`): `n` je česky, `n_<lang>`
/// ostatní jazyky; kde překlad chybí, zůstane české.
String geoName(Map<String, dynamic> j, String lang) => (lang == 'cs' ? null : j['n_$lang'] as String?) ?? j['n'] as String;
