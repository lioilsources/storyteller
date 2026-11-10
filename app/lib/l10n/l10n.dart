import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Picks the best supported locale for the system locales, falling back to English
/// (Flutter would otherwise fall back to the first supported locale alphabetically).
Locale resolveLocale(List<Locale>? locales, Iterable<Locale> supported) {
  final pinned = debugLocale;
  if (pinned != null) return pinned;
  final wanted = [
    for (final l in locales ?? const <Locale>[])
      if (l.languageCode == 'no')
        Locale.fromSubtags(languageCode: 'nb', scriptCode: l.scriptCode, countryCode: l.countryCode)
      else
        l,
  ];
  final r = basicLocaleListResolution(wanted, supported);
  return wanted.any((l) => l.languageCode == r.languageCode) ? r : const Locale('en');
}

/// Tests pin the language here.
Locale? debugLocale;

/// Localizations for code that has no BuildContext (providers, services).
/// Resolves against the device locales the same way MaterialApp does.
AppLocalizations get deviceL10n => lookupAppLocalizations(
  debugLocale ?? resolveLocale(PlatformDispatcher.instance.locales, AppLocalizations.supportedLocales),
);

/// Size in kB / MB with the decimal separator of [locale].
String formatBytes(int b, String locale) {
  if (b < 1024 * 1024) return '${(b / 1024).ceil()} kB';
  final mb = b / (1024 * 1024);
  try {
    return '${NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: 1).format(mb)} MB';
  } on ArgumentError {
    return '${mb.toStringAsFixed(1)} MB';
  }
}
