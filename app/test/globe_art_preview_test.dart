@Tags(['art-preview'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/globe/globe_icons.dart';

import 'globe_entry.dart';

/// The globe with whatever sticker art has been rendered so far, to judge
/// the style on the real thing before a full batch is paid for:
///
///     python3 tool/build_globe_atlas.py
///     flutter test test/globe_art_preview_test.dart --update-goldens
///
/// Reads `rag/data/globe_sprites/atlas/` and writes `…/preview/*.png` —
/// both gitignored, so this is skipped wherever the art hasn't been built
/// (CI included) and is tagged out of the normal run like the screenshots.
void main() {
  final sprites = Directory('../rag/data/globe_sprites');
  final webp = File('${sprites.path}/atlas/atlas.webp');
  final json = File('${sprites.path}/atlas/atlas.json');

  for (final (name, iso) in [('01-planeta', null), ('02-evropa', 'CZ'), ('03-amerika', 'US'), ('04-asie', 'CN'), ('05-afrika', 'EG')]) {
    testWidgets('globe art preview — $name', skip: !webp.existsSync(), (tester) async {
      tester.view.physicalSize = const Size(412, 915) * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      final atlas = (await tester.runAsync(() async {
        final icons = FontLoader('MaterialIcons')
          ..addFont(File('${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf').readAsBytes().then((b) => ByteData.sublistView(b)));
        await icons.load();
        return SpriteAtlas.decode(webp.readAsBytesSync(), json.readAsStringSync());
      }))!;

      await openGlobe(tester, overrides: [spriteAtlasProvider.overrideWithValue(atlas)]);
      if (iso != null) await turnTo(tester, iso);
      await expectLater(find.byType(MaterialApp), matchesGoldenFile('${sprites.absolute.path}/preview/$name.png'));
    });
  }
}
