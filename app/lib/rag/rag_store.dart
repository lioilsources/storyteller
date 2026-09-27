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
  static Future<RagStore> openBundled() async {
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
    return openFiles(paths);
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
        if (title == null) continue;
        out.add(PackMotif(id: r['id'] as String, type: r['type'] as String, textEn: r['text_en'] as String, country: r['country_code'] as String? ?? '', title: title, sentence: r['sentence'] as String?, hintCount: r['hints'] as int, jpeg: r['jpeg'] as Uint8List?));
      }
    }
    return out;
  }

  /// Per country, how many motifs already have a Czech title — i.e. what
  /// the pickers can actually offer from there right now.
  Map<String, int> titledMotifCounts({String lang = 'cs'}) {
    final out = <String, int>{};
    for (final db in _dbs) {
      for (final r in db.select(
        'SELECT m.country_code AS cc, COUNT(DISTINCT m.id) AS n FROM motifs m JOIN verbalizations v ON v.motif_id = m.id '
        'WHERE v.lang = ? AND v.length = \'title\' AND m.type IN (\'task\', \'problem\', \'ending\') GROUP BY m.country_code',
        [lang],
      )) {
        final cc = r['cc'] as String?;
        if (cc != null && cc.isNotEmpty) out[cc] = (out[cc] ?? 0) + (r['n'] as int);
      }
    }
    return out;
  }

  /// Nearest hints to [query] (already quantized, `query:` prefix) at
  /// [phases], for the outline's [motifIds] plus generic ones.
  List<ScoredHint> hints({required Iterable<String> phases, required Iterable<String> motifIds, required Int8List query, int k = 8, bool includeGeneric = true, String lang = 'cs'}) {
    final ph = phases.toList(), ids = motifIds.toList();
    if (ph.isEmpty) return const [];
    final scored = <ScoredHint>[];
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
        final emb = Int8List.view((r['emb'] as Uint8List).buffer, (r['emb'] as Uint8List).offsetInBytes, (r['emb'] as Uint8List).length);
        scored.add(ScoredHint(id: r['id'] as String, motifId: r['motif_id'] as String?, phase: r['phase'] as String, text: r['text'] as String, situationEn: r['situation_en'] as String, score: cosineInt8(query, emb)));
      }
    }
    scored.sort((a, b) => b.score.compareTo(a.score));
    return scored.take(k).toList();
  }

  void close() {
    for (final db in _dbs) {
      db.close();
    }
  }
}
