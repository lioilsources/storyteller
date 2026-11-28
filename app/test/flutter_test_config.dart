import 'dart:async';

import 'package:cute_kid_fonts/cute_kid_fonts_testing.dart';
import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';

/// Každý test vidí skutečné fonty CuteKidFonts místo placeholderu
/// FlutterTest (čtverečky). Bez toho by layoutové testy měřily šířku
/// čtverečků a goldeny by nic neříkaly — viz
/// docs/cute-kid-fonts-battle-test.md.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Testy píšou česky a čekají češtinu; testovací platforma by jinak
  // hlásila en-US a appka by se přepnula do angličtiny (lib/l10n/lang.dart).
  TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.localesTestValue = const [Locale('cs', 'CZ')];
  await loadKidFonts();
  await testMain();
}
