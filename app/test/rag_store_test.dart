// RagStore against a real pack (test/fixtures/mini.CZ.cs.db, built by
// rag/tests/make_app_fixture_pack.py with real e5 vectors). No ONNX here:
// a stored hint vector doubles as the query, so the ranking and filters are
// exercised on the exact bytes the Python side wrote.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:storyteller/cast/cast_member.dart';
import 'package:storyteller/motifs/motif.dart';
import 'package:storyteller/rag/outline.dart';
import 'package:storyteller/narrate/beat.dart';
import 'package:storyteller/rag/rag_store.dart';
import 'package:storyteller/rag/soundboard.dart';
import 'package:storyteller/story/story_draft.dart';

const _fixture = 'test/fixtures/mini.CZ.cs.db';
const _core = 'test/fixtures/mini.core.cs.db';

Int8List _embOf(String id, {String table = 'hint_emb'}) {
  final db = sqlite3.open(_fixture, mode: OpenMode.readOnly);
  try {
    final b = db.select('SELECT emb FROM $table WHERE id = ?', [id]).first['emb'] as Uint8List;
    return Int8List.fromList(b.map((x) => x > 127 ? x - 256 : x).toList());
  } finally {
    db.close();
  }
}

void main() {
  late RagStore store;
  setUp(() => store = RagStore.openFiles([_fixture, _core]));
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

  test('tale counts come from pack_tales, each tale once across packs', () {
    expect(store.taleCounts(), {'CZ': 1}); // "2 motivy z 1 pohádky" on the globe
    final twice = RagStore.openFiles([_fixture, _fixture, _core]); // bundled + downloaded copy
    expect(twice.taleCounts(), {'CZ': 1});
    twice.close();
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

  test('transitions: the one sharing the motif tags comes first', () {
    final tags = store.motifTags([store.motifs('task', country: 'CZ').single.id]);
    expect(tags, containsAll(['forest', 'well']));
    expect(store.transitions('character', 'task', tags: tags).first, 'A tak se vydal do lesa…');
    expect(store.transitions('character', 'task', tags: {'sea'}).first, 'A tak se vypravil k moři…');
    expect(store.transitions('task', 'problem'), isEmpty);
  });

  test('scene: exact motif+phase first, else nearest by vector above the bar', () {
    final task = store.motifs('task', country: 'CZ').single.id;
    final exact = store.scene(motifIds: [task], phases: ['task'])!;
    expect((exact.sceneId, exact.exact, exact.jpeg.isNotEmpty), ('s-well', true, true));
    expect(store.scene(motifIds: [task], phases: ['ending']), isNull); // no scene at that phase

    final near = store.scene(motifIds: const [], phases: ['task'], query: _embOf('s-well', table: 'scene_emb'))!;
    expect((near.sceneId, near.exact), ('s-well', false));
    expect(near.score, closeTo(1, 1e-9));
  });

  test('composeOutline bridges the pack sentences with transitions', () {
    Motif pick(String type) => Motif.fromPack(store.motifs(type, country: 'CZ').single);
    final draft = StoryDraft(characters: [mockCastPool.first], task: pick('task'), problem: pick('problem'), ending: Motif.fromPack(store.motifs('task', country: 'CZ').single));
    final lines = composeOutline(store, draft)!;
    expect(lines.map((l) => l.beat), ['character', 'task', 'problem', 'ending']);
    expect(lines[1].bridge, 'A tak se vydal do lesa…');
    expect(lines[1].text, 'Musí přinést vodu ze studny, kterou někdo hlídá.');
    expect(lines[2].bridge, isNull); // no task→problem phrase in the fixture
  });

  test('soundboard: loop for the beat setting, no effects guessed from tags', () {
    Motif task = Motif.fromPack(store.motifs('task', country: 'CZ').single);
    final draft = StoryDraft(characters: [mockCastPool.first], task: task, problem: Motif.fromPack(store.motifs('problem', country: 'CZ').single), ending: task);
    expect(store.motifCreatures([task.packMotifId!]), {'fox'});

    final calm = pickSounds(store, draft, StoryBeat.task);
    expect((calm.music?.key, calm.music?.mood), ('forest', 'calm'));
    expect(calm.effects, isEmpty); // nothing picked for this tale: no buttons guessed from tags
    expect(pickSounds(store, draft, StoryBeat.problem).music?.mood, 'tense');
    expect(String.fromCharCodes(store.soundBytes('creature-fox')!), 'fake-m4a:creature-fox');
  });
  test('soundboard: only the story\'s own sounds — each character under its name, then the beat\'s cues', () {
    // The mini fixture predates motif_sounds: add the table to a copy.
    final tmp = Directory.systemTemp.createTempSync('sounds');
    addTearDown(() => tmp.deleteSync(recursive: true));
    final copy = File('test/fixtures/mini.CZ.cs.db').copySync('${tmp.path}/mini.CZ.cs.db');
    final base = RagStore.openFiles([copy.path]);
    final task = Motif.fromPack(base.motifs('task', country: 'CZ').single);
    final problem = Motif.fromPack(base.motifs('problem', country: 'CZ').single);
    base.close();
    final db = sqlite3.open(copy.path);
    final heroId = db.select("SELECT id FROM motifs WHERE type = 'character'").single['id'] as String; // no title in the fixture
    final hero = CastMember(id: 'pack:$heroId', label: 'Chytrá liška', emoji: '🦊', gradient: const [Color(0xFF8D6E63), Color(0xFFBCAAA4)], imagePath: null, packMotifId: heroId);
    db.execute('CREATE TABLE motif_sounds (motif_id TEXT NOT NULL, sound_id TEXT NOT NULL, role TEXT NOT NULL, PRIMARY KEY (motif_id, sound_id))');
    for (final (motif, sound, role) in [
      (heroId, 'creature-wolf', 'character'),
      (task.packMotifId!, 'action-waves', 'cue'),
      (problem.packMotifId!, 'action-magic', 'cue'),
      (problem.packMotifId!, 'action-gone', 'cue'), // not in the catalog (any more): skipped
    ]) {
      db.execute('INSERT INTO motif_sounds VALUES (?,?,?)', [motif, sound, role]);
    }
    db.close();
    final withSounds = RagStore.openFiles([copy.path, 'test/fixtures/mini.core.cs.db']);
    addTearDown(withSounds.close);

    final draft = StoryDraft(characters: [hero], task: task, problem: problem, ending: task);
    final atProblem = pickSounds(withSounds, draft, StoryBeat.problem).effects;
    expect(atProblem.map((s) => s.id), ['creature-wolf', 'action-magic']);
    expect(atProblem.first.label, 'Chytrá liška'); // the parent looks for the character, not for "Vlk"
    expect(pickSounds(withSounds, draft, StoryBeat.task).effects.map((s) => s.id), ['creature-wolf', 'action-waves']);
    expect(pickSounds(withSounds, draft, StoryBeat.cast).effects.map((s) => s.id), ['creature-wolf']); // no plot yet
    // a cast without pack characters has no character sound, the cues stay
    final curated = StoryDraft(characters: [mockCastPool.first], task: task, problem: problem, ending: task);
    expect(pickSounds(withSounds, curated, StoryBeat.task).effects.map((s) => s.id), ['action-waves']);
  });
}
