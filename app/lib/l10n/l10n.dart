import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

extension L10nContext on BuildContext {
  /// Texty rozhraní v jazyce appky (lib/l10n/app_*.arb).
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Totéž mimo widgety (notifiery, čisté funkce), podle `appLangProvider`.
AppLocalizations l10nFor(String lang) => lookupAppLocalizations(Locale(lang));
