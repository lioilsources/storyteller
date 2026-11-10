import 'dart:async';
import 'dart:ui';

import 'package:cute_kid_fonts/cute_kid_fonts_testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/l10n/l10n.dart';

/// Každý test vidí skutečné fonty CuteKidFonts místo placeholderu
/// FlutterTest (čtverečky). Bez toho by layoutové testy měřily šířku
/// čtverečků a goldeny by nic neříkaly — viz
/// docs/cute-kid-fonts-battle-test.md.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // The expectations in the suite are Czech: pin the language the app resolves.
  debugLocale = const Locale('cs');
  await loadKidFonts();
  await testMain();
}
