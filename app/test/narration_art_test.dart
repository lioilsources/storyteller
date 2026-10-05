// Every beat of the telling has text and a picture (rozhodnutí 2026-10-05):
// the scene from the packs — bundled first, then the downloaded all-scenes
// pack (scenes.CZ.cs.free) — else the card of the beat's motif. Real packs:
// test/fixtures/mini.CZ.cs.db (bundled stand-in) and scenes-cz-v1.zip from
// rag/tests/make_app_fixture_scenes.py.
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/narrate/beat.dart';
import 'package:storyteller/narrate/narration_screen.dart';
import 'package:storyteller/rag/rag_providers.dart';
import 'package:storyteller/rag/rag_store.dart';
import 'package:storyteller/story/story_draft.dart';
import 'package:storyteller/theme/kid_text.dart';

const _bundled = 'test/fixtures/mini.CZ.cs.db';

class _Fixed extends StoryDraftController {
  _Fixed(this.draft);
  final StoryDraft draft;
  @override
  StoryDraft build() => draft;
}

Future<void> _pump(WidgetTester tester, StoryDraft draft, {RagStore? store}) async {
  // a tall phone, so the picture and its caption are both laid out
  tester.view.physicalSize = const Size(1170, 3600);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      storyDraftProvider.overrideWith(() => _Fixed(draft)),
      ragStoreProvider.overrideWith((ref) async => store),
      embedderProvider.overrideWith((ref) async => null), // no ONNX in tests: exact scenes only
    ],
    child: MaterialApp(
      theme: storyThemeData(),
      builder: (context, child) => KidTheme(data: storyKidTheme, child: child!),
      home: const NarrationScreen(),
    ),
  ));
  await tester.pumpAndSettle();
}

Future<void> _next(WidgetTester tester) async {
  await tester.tap(find.byKey(narrationNextKey));
  await tester.pumpAndSettle();
}

/// The picture under the current beat: its bytes or asset, or null for none.
Object? _art(WidgetTester tester) {
  final f = find.descendant(of: find.byKey(narrationArtKey), matching: find.byType(Image));
  if (f.evaluate().isEmpty) return null;
  return switch (tester.widget<Image>(f).image) {
    final MemoryImage m => m.bytes,
    final AssetImage a => a.assetName,
    final other => other,
  };
}

Uint8List _sceneBytes(String db, String sceneId) {
  final d = sqlite3.open(db, mode: OpenMode.readOnly);
  try {
    return d.select('SELECT jpeg FROM scene_images WHERE scene_id = ?', [sceneId]).single['jpeg'] as Uint8List;
  } finally {
    d.close();
  }
}

void main() {
  late Directory tmp;
  late String scenesDb;

  setUpAll(() {
    tmp = Directory.systemTemp.createTempSync('narration_art');
    final zip = ZipDecoder().decodeBytes(File('test/fixtures/scenes-cz-v1.zip').readAsBytesSync());
    final f = zip.files.firstWhere((f) => f.name.endsWith('.db'));
    scenesDb = (File('${tmp.path}/${f.name}')..writeAsBytesSync(f.content as List<int>)).path;
  });
  tearDownAll(() => tmp.deleteSync(recursive: true));

  test('NarrationArt.card: the beat\'s motif, characters first on the cast beat, null without any art', () {
    final a = Uint8List.fromList([1]), b = Uint8List.fromList([2]);
    const g = [Colors.red, Colors.blue];
    final draft = StoryDraft(
      characters: [
        const CastMember(id: 'c0', label: 'Bez obrázku', emoji: '?', gradient: g, imagePath: null),
        CastMember(id: 'c1', label: 'Liška', emoji: '🦊', gradient: g, imagePath: null, imageBytes: a),
      ],
      task: Motif(id: 't', label: 'Úkol', emoji: '?', gradient: g, imagePath: 'assets/motifs/task-wine.jpg', country: 'CZ', imageBytes: b),
      problem: const Motif(id: 'p', label: 'Problém', emoji: '?', gradient: g, imagePath: null, country: 'CZ'),
      ending: const Motif(id: 'e', label: 'Konec', emoji: '?', gradient: g, imagePath: 'assets/motifs/ending-slipper.jpg', country: 'CZ'),
    );
    expect(NarrationArt.card(StoryBeat.cast, draft)!.bytes, a);
    expect(NarrationArt.card(StoryBeat.task, draft)!.bytes, b); // pack art wins over the asset
    expect(NarrationArt.card(StoryBeat.problem, draft), isNull); // not drawn yet: text only
    expect(NarrationArt.card(StoryBeat.ending, draft)!.asset, 'assets/motifs/ending-slipper.jpg');
    final noCast = StoryDraft(characters: [draft.characters.first], task: draft.task, problem: draft.problem, ending: draft.ending);
    expect(NarrationArt.card(StoryBeat.cast, noCast)!.bytes, b); // no character drawn → the task's card
  });

  testWidgets('a curated osnova (no packs) shows each beat\'s card', (tester) async {
    final draft = StoryDraft(characters: [mockCastPool.first], task: taskPool.first, problem: problemPool.first, ending: endingPool.first);
    await _pump(tester, draft);
    expect(_art(tester), mockCastPool.first.imagePath);
    for (final m in [taskPool.first, problemPool.first, endingPool.first]) {
      await _next(tester);
      expect(_art(tester), m.imagePath);
      expect(find.text('karta motivu · scénu k tomuhle kroku zatím nemáme'), findsOneWidget);
    }
  });

  group('pack osnova', () {
    late StoryDraft draft;
    late Uint8List taskCard;

    StoryDraft packDraft(RagStore s) {
      final task = s.motifs('task', country: 'CZ').single, problem = s.motifs('problem', country: 'CZ').single;
      taskCard = task.jpeg!;
      return StoryDraft(
        countryIso: 'CZ',
        characters: const [CastMember(id: 'c', label: 'Hrdina', emoji: '🧚', gradient: [Colors.red, Colors.blue], imagePath: null, packMotifId: 'not-drawn')],
        task: Motif.fromPack(task),
        problem: Motif.fromPack(problem), // no card, no scene in the bundled pack
        // a motif with a card and no scene anywhere
        ending: Motif(id: 'pack:e', label: 'Konec', emoji: '🌅', gradient: const [Colors.red, Colors.blue], imagePath: null, country: 'CZ', packMotifId: 'no-scenes', imageBytes: task.jpeg),
      );
    }

    testWidgets('bundled only: scene, else card, else (no art at all) text alone', (tester) async {
      final store = RagStore.openFiles([_bundled]);
      addTearDown(store.close);
      draft = packDraft(store);
      await _pump(tester, draft, store: store);

      expect(_art(tester), taskCard, reason: 'cast beat: no intro scene, no character drawn → the task card');
      await _next(tester);
      expect(_art(tester), _sceneBytes(_bundled, 's-well'));
      expect(find.text('ilustrace · k tomuhle motivu'), findsOneWidget);
      await _next(tester);
      expect(_art(tester), isNull, reason: 'problem motif has neither a scene nor a card');
      expect(find.byKey(narrationArtKey), findsNothing);
      await _next(tester);
      expect(_art(tester), taskCard);
      expect(find.text('karta motivu · scénu k tomuhle kroku zatím nemáme'), findsOneWidget);
    });

    testWidgets('with the downloaded scenes pack: its scene fills the gap, the bundled one still wins', (tester) async {
      final store = RagStore.openFiles([_bundled, scenesDb]);
      addTearDown(store.close);
      draft = packDraft(store);
      await _pump(tester, draft, store: store);

      await _next(tester);
      expect(_art(tester), _sceneBytes(_bundled, 's-well'), reason: 'bundled before downloaded');
      await _next(tester);
      expect(_art(tester), _sceneBytes(scenesDb, 's-dragon-all'));
      expect(find.text('ilustrace · k tomuhle motivu'), findsOneWidget);
      await _next(tester);
      expect(_art(tester), taskCard, reason: 'no scene in any pack → card');
    });
  });
}
