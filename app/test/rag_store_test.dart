// RagStore against a real pack (test/fixtures/mini.CZ.cs.db, built by
// rag/tests/make_app_fixture_pack.py with real e5 vectors). No ONNX here:
// a stored hint vector doubles as the query, so the ranking and filters are
// exercised on the exact bytes the Python side wrote.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:storyteller/rag/rag_store.dart';

const _fixture = 'test/fixtures/mini.CZ.cs.db';

Int8List _embOf(String hintId) {
  final db = sqlite3.open(_fixture, mode: OpenMode.readOnly);
  try {
    final b = db.select('SELECT emb FROM hint_emb WHERE id = ?', [hintId]).first['emb'] as Uint8List;
    return Int8List.fromList(b.map((x) => x > 127 ? x - 256 : x).toList());
  } finally {
    db.close();
  }
}

void main() {
  late RagStore store;
  setUp(() => store = RagStore.openFiles([_fixture]));
  tearDown(() => store.close());

  test('only motifs with a Czech title are offered, with their sentence', () {
    final tasks = store.motifs('task', country: 'CZ');
    expect(tasks.map((m) => m.title), ['Voda ze střežené studny']);
    expect(tasks.single.sentence, 'Musí přinést vodu ze studny, kterou někdo hlídá.');
    expect(tasks.single.jpeg, isNotNull); // rendered card from motif_images
    expect(store.motifs('problem', country: 'CZ').single.jpeg, isNull);
    expect(store.motifs('ending', country: 'CZ'), isEmpty); // no verbalization yet
    expect(store.motifs('task', country: 'DE'), isEmpty);
    expect(store.titledMotifCounts(), {'CZ': 2});
  });

  test('retrieval ranks by cosine and respects phase and outline motifs', () {
    final problemMotif = store.motifs('problem', country: 'CZ').single.id;
    final taskMotif = store.motifs('task', country: 'CZ').single.id;

    final hits = store.hints(phases: ['problem'], motifIds: [problemMotif, taskMotif], query: _embOf('h-dragon'));
    expect(hits.first.id, 'h-dragon');
    expect(hits.first.score, closeTo(1, 1e-9));
    expect(hits.map((h) => h.id), isNot(contains('h-well'))); // task phase, filtered out

    // a motif outside the outline is never hinted about, however close
    expect(store.hints(phases: ['problem'], motifIds: [taskMotif], query: _embOf('h-dragon')), isEmpty);
  });

  test('a pack embedded with another model is refused', () {
    final dir = Directory.systemTemp.createTempSync('ragstore');
    final copy = File('${dir.path}/other.db')..writeAsBytesSync(File(_fixture).readAsBytesSync());
    final db = sqlite3.open(copy.path)..execute("UPDATE meta SET embed_model = 'some/other-model'");
    db.close();
    expect(() => RagStore.openFiles([copy.path]), throwsStateError);
    dir.deleteSync(recursive: true);
  });
}
