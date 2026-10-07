import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rag_embed/rag_embed.dart';
import 'package:sqlite3/sqlite3.dart';

/// A motif from a pack, with the Czech phrasing `rag.verbalize` wrote for it.
@immutable
class PackMotif {
  const PackMotif({required this.id, required this.type, required this.textEn, required this.country, required this.title, this.sentence, this.hintCount = 0, this.jpeg});

  final String id;
  final String type; // character | task | problem | ending
  final String textEn;
  final String country;
  final String title; // verbalization, length=title
  final String? sentence; // verbalization, length=sentence

  /// Hints the pack has about this motif. While the pipeline is still
  /// running most motifs have none, and a Suflér over them would be empty.
  final int hintCount;

  /// Card art from the pack's `motif_images` (512 px JPEG), when rendered.
  final Uint8List? jpeg;
}

@immutable
class ScoredHint {
  const ScoredHint({required this.id, required this.motifId, required this.phase, required this.text, required this.situationEn, required this.score});

  final String id;
  final String? motifId; // null = generic hint from the core pack
  final String phase;
  final String text;
  final String situationEn;
  final double score; // cosine, query vs situation_en
}

/// A pre-rendered scene illustration (`scene_prompts` + `scene_images`).
@immutable
class ScenePick {
  const ScenePick({required this.sceneId, required this.motifId, required this.phase, required this.jpeg, required this.score, required this.exact});

  final String sceneId;
  final String motifId;
  final String phase;
  final Uint8List jpeg;
  final double score; // 1.0 for an exact motif+phase match
  final bool exact; // false = nearest by vector, from another motif
}

/// A soundboard entry from the core pack's `sounds` (rag/audio/catalog.json).
@immutable
class PackSound {
  const PackSound({required this.id, required this.kind, required this.key, required this.label, this.mood, this.match = const {}});

  final String id;
  final String kind; // music | creature | action
  final String key; // environment for music, catalog key otherwise
  final String label; // Czech, for the button
  final String? mood; // calm | tense (music only)
  final Set<String> match; // motif tags / environments / creatures it belongs to
}

/// Read-only view over the SQLite packs `rag.build_pack` produces
/// (STORYTELLER_RAG_PLAN.md §3, §6): `core.<lang>.db` + `country.<CC>.<lang>.db`.
///
/// Retrieval ranks `hint_emb` (the int8 vectors as plain BLOBs) in Dart
/// instead of querying `hint_vec` through the sqlite-vec extension — a few
/// thousand vectors per pack is a few milliseconds, and it keeps a second
/// native build out of the app for now. Same vectors, same cosine as the
/// pack's own `nearest_hints` reference query.
class RagStore {
  RagStore._(this._dbs);

  /// Packs whose vectors came from another model are refused: the query
  /// vector would live in a different space and every score would be noise.
  static const embedModel = 'intfloat/multilingual-e5-small';
  static const embedDim = 384;
  static const packDir = 'assets/rag/packs/';

  final List<Database> _dbs;

  // motifs() is called from a route builder; cache so a rebuild doesn't
  // re-read (and the UI doesn't re-decode) the card images.
  final _motifCache = <String, List<PackMotif>>{};

  /// Every `.db` bundled under [packDir], copied out of the asset bundle
  /// (SQLite needs a real file) and opened read-only.
  ///
  /// [extra] are downloaded packs (lib/packs/): one that fails to open is
  /// skipped rather than taking the bundled content down with it.
  static Future<RagStore> openBundled({List<String> extra = const []}) async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest.listAssets().where((a) => a.startsWith(packDir) && a.endsWith('.db')).toList()..sort();
    final dir = Directory('${(await getApplicationSupportDirectory()).path}/rag_packs')..createSync(recursive: true);
    final paths = <String>[];
    for (final a in assets) {
      final bytes = (await rootBundle.load(a)).buffer.asUint8List();
      final f = File('${dir.path}/${a.substring(packDir.length)}');
      if (!f.existsSync() || f.lengthSync() != bytes.length) f.writeAsBytesSync(bytes, flush: true);
      paths.add(f.path);
    }
    // A pack an older version of the app carried (the 130 MB of free
    // Evropa, before packs went per region) would otherwise stay forever.
    for (final f in dir.listSync().whereType<File>()) {
      if (!paths.contains(f.path)) f.deleteSync();
    }
    final store = openFiles(paths);
    for (final p in extra) {
      try {
        store._dbs.addAll(openFiles([p])._dbs);
      } catch (e) {
        debugPrint('pack $p skipped: $e');
      }
    }
    return store;
  }

  static RagStore openFiles(List<String> paths) {
    final dbs = <Database>[];
    for (final p in paths) {
      final db = sqlite3.open(p, mode: OpenMode.readOnly);
      final meta = db.select('SELECT pack_id, embed_model, embed_dim FROM meta').first;
      final model = meta['embed_model'] as String;
      if (model.isNotEmpty && (model != embedModel || meta['embed_dim'] != embedDim)) {
        db.close();
        throw StateError('${meta['pack_id']}: embedded with $model/${meta['embed_dim']}, device has $embedModel/$embedDim');
      }
      dbs.add(db);
    }
    return RagStore._(dbs);
  }

  /// Motifs of [type] that already have a Czech title — a motif without
  /// one can't be shown yet (verbalize is still running over the corpus).
  List<PackMotif> motifs(String type, {String? country, String lang = 'cs', String ageBand = '3-6'}) =>
      _motifCache.putIfAbsent('$type|$country|$lang|$ageBand', () => _motifs(type, country, lang, ageBand));

  List<PackMotif> _motifs(String type, String? country, String lang, String ageBand) {
    const pick = 'SELECT text FROM verbalizations v WHERE v.motif_id = m.id AND v.lang = ? AND v.length = ? '
        'ORDER BY (v.age_band = ?) DESC, (v.tone = \'neutral\') DESC LIMIT 1';
    final out = <PackMotif>[];
    final seen = <String>{}; // a motif can be in a bundled and a downloaded pack
    for (final db in _dbs) {
      final hasImages = db.select("SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = 'motif_images'").isNotEmpty;
      final rows = db.select(
        'SELECT m.id, m.type, m.text_en, m.country_code, ($pick) AS title, ($pick) AS sentence, '
        '(SELECT COUNT(*) FROM hint_bank h WHERE h.motif_id = m.id AND h.lang = ?) AS hints, '
        '${hasImages ? '(SELECT jpeg FROM motif_images i WHERE i.motif_id = m.id)' : 'NULL'} AS jpeg '
        'FROM motifs m WHERE m.type = ? AND (? IS NULL OR m.country_code = ?)',
        [lang, 'title', ageBand, lang, 'sentence', ageBand, lang, type, country, country],
      );
      for (final r in rows) {
        final title = r['title'] as String?;
        if (title == null || !seen.add(r['id'] as String)) continue;
        out.add(PackMotif(id: r['id'] as String, type: r['type'] as String, textEn: r['text_en'] as String, country: r['country_code'] as String? ?? '', title: title, sentence: r['sentence'] as String?, hintCount: r['hints'] as int, jpeg: r['jpeg'] as Uint8List?));
      }
    }
    return out;
  }

  /// Per country, how many motifs already have a Czech title — i.e. what
  /// the pickers can actually offer from there right now.
  Map<String, int> titledMotifCounts({String lang = 'cs'}) {
    final ids = <String, Set<String>>{};
    for (final db in _dbs) {
      for (final r in db.select(
        'SELECT DISTINCT m.country_code AS cc, m.id FROM motifs m JOIN verbalizations v ON v.motif_id = m.id '
        'WHERE v.lang = ? AND v.length = \'title\' AND m.type IN (\'task\', \'problem\', \'ending\')',
        [lang],
      )) {
        final cc = r['cc'] as String?;
        if (cc != null && cc.isNotEmpty) (ids[cc] ??= {}).add(r['id'] as String);
      }
    }
    return {for (final e in ids.entries) e.key: e.value.length};
  }

  /// Per country, from how many source tales the pickers' motifs come —
  /// the "M" in the globe's "N motivů z M pohádek". Read from `pack_tales`
  /// (rag.build_pack), counting each tale once across bundled and
  /// downloaded packs; packs built before the table existed add nothing.
  Map<String, int> taleCounts() {
    final refs = <String, Set<String>>{};
    for (final db in _dbs) {
      final ResultSet rows;
      try {
        rows = db.select('SELECT source_ref, country_code FROM pack_tales WHERE shown > 0');
      } on SqliteException {
        continue;
      }
      for (final r in rows) {
        (refs[r['country_code'] as String] ??= {}).add(r['source_ref'] as String);
      }
    }
    return {for (final e in refs.entries) e.key: e.value.length};
  }

  /// Nearest hints to [query] (already quantized, `query:` prefix) at
  /// [phases], for the outline's [motifIds] plus generic ones.
  List<ScoredHint> hints({required Iterable<String> phases, required Iterable<String> motifIds, required Int8List query, int k = 8, bool includeGeneric = true, String lang = 'cs'}) {
    final ph = phases.toList(), ids = motifIds.toList();
    if (ph.isEmpty) return const [];
    final scored = <ScoredHint>[];
    final seen = <String>{};
    for (final db in _dbs) {
      final ResultSet rows;
      try {
        rows = db.select(
          'SELECT h.id, h.motif_id, h.phase, h.text, h.situation_en, e.emb FROM hint_bank h JOIN hint_emb e ON e.id = h.id '
          'WHERE h.lang = ? AND h.phase IN (${List.filled(ph.length, '?').join(',')}) '
          'AND (${ids.isEmpty ? '0' : 'h.motif_id IN (${List.filled(ids.length, '?').join(',')})'} OR (h.motif_id IS NULL AND ?))',
          [lang, ...ph, ...ids, includeGeneric ? 1 : 0],
        );
      } on SqliteException {
        continue; // pack built before hint_emb existed
      }
      for (final r in rows) {
        if (!seen.add(r['id'] as String)) continue;
        final emb = Int8List.view((r['emb'] as Uint8List).buffer, (r['emb'] as Uint8List).offsetInBytes, (r['emb'] as Uint8List).length);
        scored.add(ScoredHint(id: r['id'] as String, motifId: r['motif_id'] as String?, phase: r['phase'] as String, text: r['text'] as String, situationEn: r['situation_en'] as String, score: cosineInt8(query, emb)));
      }
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(k).toList();
  }

  /// Tags and environments of [motifIds] — what a transition phrase is
  /// matched on (RAG_PLAN §2.3: transitions "by tags").
  Set<String> motifTags(Iterable<String> motifIds) {
    final ids = motifIds.toList();
    if (ids.isEmpty) return const {};
    final out = <String>{};
    for (final db in _dbs) {
      for (final r in db.select('SELECT tags, environments FROM motifs WHERE id IN (${List.filled(ids.length, '?').join(',')})', ids)) {
        for (final col in ['tags', 'environments']) {
          final raw = (r[col] as String?) ?? '[]';
          out.addAll(RegExp(r'"([^"]+)"').allMatches(raw).map((m) => m.group(1)!.toLowerCase()));
        }
      }
    }
    return out;
  }

  /// Bridge phrases from a [from] beat to a [to] beat (`character`, `task`,
  /// `problem`, `ending`), best tag overlap with [tags] first. With
  /// [bestOnly], just the ones tied for the best overlap.
  List<String> transitions(String from, String to, {Set<String> tags = const {}, String lang = 'cs', bool bestOnly = false}) {
    final scored = <(int, int, String)>[];
    var i = 0;
    for (final db in _dbs) {
      final ResultSet rows;
      try {
        rows = db.select('SELECT tags, text FROM transitions WHERE from_type = ? AND to_type = ? AND lang = ?', [from, to, lang]);
      } on SqliteException {
        continue;
      }
      for (final r in rows) {
        final t = RegExp(r'"([^"]+)"').allMatches(r['tags'] as String).map((m) => m.group(1)!).toSet();
        scored.add((t.intersection(tags).length, i++, r['text'] as String));
      }
    }
    scored.sort((a, b) => a.$1 != b.$1 ? b.$1.compareTo(a.$1) : a.$2.compareTo(b.$2));
    final top = scored.isEmpty ? 0 : scored.first.$1;
    return [for (final s in scored) if (!bestOnly || s.$1 == top) s.$3];
  }

  /// The illustration for a beat: a scene rendered for one of [motifIds] at
  /// one of [phases] if there is one, else — given a [query] — the nearest
  /// rendered scene at those phases, if it's at least [minScore] alike.
  ScenePick? scene({required Iterable<String> motifIds, required Iterable<String> phases, Int8List? query, double minScore = 0.8}) {
    final ids = motifIds.toList(), ph = phases.toList();
    if (ph.isEmpty) return null;
    final phIn = List.filled(ph.length, '?').join(',');
    ScenePick? best;
    for (final db in _dbs) {
      try {
        if (ids.isNotEmpty) {
          final rows = db.select(
            'SELECT s.id, s.motif_id, s.phase, i.jpeg FROM scene_prompts s JOIN scene_images i ON i.scene_id = s.id '
            'WHERE s.motif_id IN (${List.filled(ids.length, '?').join(',')}) AND s.phase IN ($phIn) ORDER BY s.id LIMIT 1',
            [...ids, ...ph],
          );
          if (rows.isNotEmpty) {
            final r = rows.first;
            return ScenePick(sceneId: r['id'] as String, motifId: r['motif_id'] as String, phase: r['phase'] as String, jpeg: r['jpeg'] as Uint8List, score: 1, exact: true);
          }
        }
        if (query == null) continue;
        for (final r in db.select(
          'SELECT s.id, s.motif_id, s.phase, e.emb, i.jpeg FROM scene_prompts s JOIN scene_emb e ON e.id = s.id '
          'JOIN scene_images i ON i.scene_id = s.id WHERE s.phase IN ($phIn)',
          ph,
        )) {
          final b = r['emb'] as Uint8List;
          final score = cosineInt8(query, Int8List.view(b.buffer, b.offsetInBytes, b.length));
          if (score >= minScore && (best == null || score > best.score)) {
            best = ScenePick(sceneId: r['id'] as String, motifId: r['motif_id'] as String, phase: r['phase'] as String, jpeg: r['jpeg'] as Uint8List, score: score, exact: false);
          }
        }
      } on SqliteException {
        continue; // pack without scene tables
      }
    }
    return best;
  }

  /// Creatures of the tales [motifIds] come from (`motif_creatures`).
  Set<String> motifCreatures(Iterable<String> motifIds) {
    final ids = motifIds.toList();
    if (ids.isEmpty) return const {};
    final out = <String>{};
    for (final db in _dbs) {
      try {
        out.addAll(db.select('SELECT creature FROM motif_creatures WHERE motif_id IN (${List.filled(ids.length, '?').join(',')})', ids).map((r) => r['creature'] as String));
      } on SqliteException {
        continue;
      }
    }
    return out;
  }

  /// Sounds the pipeline picked for [motifIds] from the catalog
  /// (`motif_sounds`): role `character` — the character's own sound,
  /// `cue` — a sound the motif's plot calls for. Packs built before the
  /// table existed simply have none.
  List<({String motifId, String soundId, String role})> motifSounds(Iterable<String> motifIds) {
    final ids = motifIds.toList();
    if (ids.isEmpty) return const [];
    final out = <({String motifId, String soundId, String role})>[];
    final seen = <String>{};
    for (final db in _dbs) {
      try {
        for (final r in db.select('SELECT motif_id, sound_id, role FROM motif_sounds WHERE motif_id IN (${List.filled(ids.length, '?').join(',')}) ORDER BY motif_id, sound_id', ids)) {
          if (seen.add('${r['motif_id']}|${r['sound_id']}')) out.add((motifId: r['motif_id'] as String, soundId: r['sound_id'] as String, role: r['role'] as String));
        }
      } on SqliteException {
        continue;
      }
    }
    return out;
  }

  List<PackSound>? _sounds;

  /// Every sound in the packs, without the audio bytes ([soundBytes]).
  List<PackSound> sounds() => _sounds ??= [
        for (final db in _dbs)
          ...() {
            try {
              return db.select('SELECT id, kind, key, mood, label_cs, match FROM sounds ORDER BY id');
            } on SqliteException {
              return const <Row>[];
            }
          }()
              .map((r) => PackSound(
                    id: r['id'] as String,
                    kind: r['kind'] as String,
                    key: r['key'] as String,
                    mood: r['mood'] as String?,
                    label: r['label_cs'] as String,
                    match: RegExp(r'"([^"]+)"').allMatches(r['match'] as String).map((m) => m.group(1)!.toLowerCase()).toSet(),
                  )),
      ];

  Uint8List? soundBytes(String id) {
    for (final db in _dbs) {
      try {
        final rows = db.select('SELECT m4a FROM sounds WHERE id = ?', [id]);
        if (rows.isNotEmpty) return rows.first['m4a'] as Uint8List;
      } on SqliteException {
        continue;
      }
    }
    return null;
  }

  void close() {
    for (final db in _dbs) {
      db.close();
    }
  }
}
