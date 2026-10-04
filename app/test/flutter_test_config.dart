import 'dart:async';

import 'package:cute_kid_fonts/cute_kid_fonts_testing.dart';
import 'package:flutter_test/flutter_test.dart';

/// Každý test vidí skutečné fonty CuteKidFonts místo placeholderu
/// FlutterTest (čtverečky). Bez toho by layoutové testy měřily šířku
/// čtverečků a goldeny by nic neříkaly — viz
/// docs/cute-kid-fonts-battle-test.md.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadKidFonts();
  await testMain();
}
