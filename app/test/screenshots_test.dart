@Tags(['screenshots'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/cast/cast_composer_screen.dart';
import 'package:storyteller/globe/globe_screen.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/motifs/motif_picker_screen.dart';
import 'package:storyteller/narrate/narration_screen.dart';
import 'package:storyteller/story/osnova_screen.dart';

import 'globe_entry.dart';

/// Renders every screen to `test/screenshots/*.png` so the app can be
/// looked at without a device:
///
///     flutter test test/screenshots_test.dart --update-goldens
///
/// Run without `--update-goldens` and it becomes a visual regression
/// suite instead. It is tagged so the normal `flutter test` skips it —
/// goldens are rendering-sensitive and would otherwise fail the build on
/// any harmless Skia or font change:
///
///     flutter test --exclude-tags screenshots
///
/// Two things make this work where a naive golden test shows black boxes
/// and blank cards: real fonts have to be loaded by hand (the test
/// environment otherwise uses a placeholder font that renders every
/// glyph as a rectangle), and asset images have to be decoded inside
/// `tester.runAsync`, because image decoding is real async work that the
/// fake-async zone never completes.
const _phone = Size(412, 915); // a common Android viewport

Future<void> _loadRealFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) {
    fail('FLUTTER_ROOT is unset — run this through `flutter test`, not `dart test`.');
  }
  final dir = Directory('$root/bin/cache/artifacts/material_fonts');
  if (!dir.existsSync()) {
    fail('no material_fonts in the SDK at ${dir.path} — run `flutter precache`.');
  }

  Future<ByteData> read(String name) async =>
      ByteData.sublistView(Uint8List.fromList(await File('${dir.path}/$name').readAsBytes()));

  // Roboto is what main.dart asks for; MaterialIcons is what every
  // Icon() widget needs.
  final roboto = FontLoader('Roboto')
    ..addFont(read('Roboto-Regular.ttf'))
    ..addFont(read('Roboto-Medium.ttf'))
    ..addFont(read('Roboto-Bold.ttf'));
  await roboto.load();

  final icons = FontLoader('MaterialIcons')..addFont(read('MaterialIcons-Regular.otf'));
  await icons.load();
}

/// Lets every `Image.asset` on screen finish decoding.
Future<void> _settleImages(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() async {
      // Real time has to pass in the real zone for the decode to land.
      await Future<void>.delayed(const Duration(milliseconds: 60));
    });
    await tester.pumpAndSettle();
  }
}

/// Fixes the logical viewport so goldens stay comparable between runs
/// and machines. Must be called before the first pump.
void _phoneView(WidgetTester tester) {
  tester.view.physicalSize = _phone * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _shoot(WidgetTester tester, String name) async {
  await _settleImages(tester);
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('screenshots/$name.png'));
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadRealFonts();
  });

  testWidgets('01 globe — the country we have most from', (tester) async {
    _phoneView(tester);
    await openGlobe(tester);
    expect(find.byType(GlobeScreen), findsOneWidget);
    await _shoot(tester, '01-globus-nemecko');
  });

  testWidgets('02 globe — a grey country is a dead end', (tester) async {
    _phoneView(tester);
    await openGlobe(tester);
    await turnTo(tester, 'CZ');
    await _shoot(tester, '02-globus-cesko-sede');
  });

  testWidgets('03 globe — Denmark, with its corpus coverage', (tester) async {
    _phoneView(tester);
    await openGlobe(tester);
    await turnTo(tester, 'DK');
    await _shoot(tester, '03-globus-dansko');
  });

  testWidgets('04 cast composer, filtered to Denmark', (tester) async {
    _phoneView(tester);
    await enterFlowFrom(tester, iso: 'DK');
    expect(find.byType(CastComposerScreen), findsOneWidget);
    await _shoot(tester, '04-obsazeni-dansko');
  });

  testWidgets('05 task picker, filtered to Germany', (tester) async {
    _phoneView(tester);
    await enterFlowFrom(tester, iso: 'DE');
    await tester.tap(find.text('Pokračovat →'));
    await tester.pumpAndSettle();
    expect(find.byType(MotifPickerScreen), findsOneWidget);
    expect(find.text(MotifCategory.task.title), findsOneWidget);
    await _shoot(tester, '05-ukol-nemecko');
  });

  testWidgets('06 the assembled outline', (tester) async {
    _phoneView(tester);
    await enterFlowFrom(tester, iso: 'DE');
    await tester.tap(find.text('Pokračovat →'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
    }
    expect(find.byType(OsnovaScreen), findsOneWidget);
    await _shoot(tester, '06-osnova');
  });

  testWidgets('07 the prompter, before any hint is asked for', (tester) async {
    _phoneView(tester);
    await _toNarration(tester);
    await _shoot(tester, '07-supler');
  });

  testWidgets('08 the prompter, with two open prompts', (tester) async {
    _phoneView(tester);
    await _toNarration(tester);
    await tester.tap(find.byKey(narrationHintKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(narrationHintKey));
    await tester.pumpAndSettle();
    await _shoot(tester, '08-supler-napovedy');
  });
}

Future<void> _toNarration(WidgetTester tester) async {
  await enterFlowFrom(tester, iso: 'DE');
  await tester.tap(find.text('Pokračovat →'));
  await tester.pumpAndSettle();
  for (var i = 0; i < 3; i++) {
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
  }
  await tester.tap(find.text('Vyprávím →'));
  await tester.pumpAndSettle();
  expect(find.byType(NarrationScreen), findsOneWidget);
}
