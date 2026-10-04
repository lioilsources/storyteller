import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:sqlite3/sqlite3.dart';

import 'pack_fetcher.dart';
import 'pack_manifest.dart';
import 'store_gateway.dart';

/// Downloadable packs (STORYTELLER_MONETIZATION_PLAN.md §4-§7, §11): free
/// tales per continent (`continent.<K>.<lang>.free`; Evropa is in the
/// binary, never here), paid tales per country (`country.<CC>.<lang>.paid`):
/// manifest sync, download with resume, sha256 verification, atomic
/// install recorded in SQLite `installed_packs`, and "Uvolnit místo".
///
/// Layout under [root] (application support dir):
///
///     manifest.json                   last good manifest (offline start)
///     index.db                        installed_packs
///     downloads/<id>-v<n>.zip.part    partial download, resumed by Range
///     packs/<id>-v<n>/                pack.json + the pack's SQLite file
///
/// Lexify, which the plan points at, turned out to have no zip/manifest/
/// hash layer to copy (it fetches deck.json and loose images); what this
/// keeps from it is the "newer version wins, a tie keeps what's there"
/// rule and a const content URL.
class PackRepository {
  PackRepository({required this.root, required this.manifestUrl, required this.fetcher, required this.store, required this.appVersion, DateTime Function()? clock})
      : _clock = clock ?? DateTime.now {
    Directory('${root.path}/packs').createSync(recursive: true);
    Directory('${root.path}/downloads').createSync(recursive: true);
    _db = sqlite3.open('${root.path}/index.db');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS installed_packs (
        id TEXT PRIMARY KEY,          -- continent.<K>.<lang>.free | country.<CC>.<lang>.paid
        country TEXT NOT NULL,        -- ISO země, u kontinentu jeho kód (AF koliduje s Afghánistánem — rozliší id)
        tier TEXT NOT NULL,           -- free | lite (| full, phase 4)
        version INTEGER NOT NULL,
        dir TEXT NOT NULL,            -- relative to root
        size INTEGER NOT NULL,        -- bytes on disk
        sha256 TEXT NOT NULL,         -- of the downloaded zip
        installed_at INTEGER NOT NULL,
        last_used_at INTEGER NOT NULL
      )''');
  }

  static const defaultManifestUrl = 'https://lioilsources.github.io/storyteller-content/manifest.json';

  final Directory root;
  final Uri manifestUrl;
  final PackFetcher fetcher;
  final StoreGateway store;
  final String appVersion;
  final DateTime Function() _clock;
  late final Database _db;
  PackManifest? _manifest;
  final _busy = <String, Future<void>>{};

  PackManifest? get manifest => _manifest;

  /// Fetches the manifest; on any failure keeps the last good one from
  /// disk. A manifest this app can't read (newer schema, newer app
  /// required) is ignored the same way.
  Future<PackManifest?> syncManifest() async {
    final cached = File('${root.path}/manifest.json');
    try {
      final bytes = await fetcher.get(manifestUrl);
      final m = _usable(bytes);
      if (m != null) {
        await cached.writeAsBytes(bytes, flush: true);
        return _manifest = m;
      }
    } catch (_) {
      // offline, Pages down, garbage: fall through to the cached copy
    }
    if (_manifest == null && cached.existsSync()) _manifest = _usable(cached.readAsBytesSync());
    return _manifest;
  }

  PackManifest? _usable(List<int> bytes) {
    try {
      final m = PackManifest.fromJson(jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>);
      if (m.schema > PackManifest.supportedSchema || compareVersions(appVersion, m.minAppVersion) < 0) return null;
      return m;
    } catch (_) {
      return null;
    }
  }

  List<InstalledPack> installed() => [
        for (final r in _db.select('SELECT * FROM installed_packs ORDER BY id'))
          InstalledPack(id: r['id'] as String, country: r['country'] as String, tier: r['tier'] as String, version: r['version'] as int, dir: '${root.path}/${r['dir']}', size: r['size'] as int, lastUsed: DateTime.fromMillisecondsSinceEpoch(r['last_used_at'] as int)),
      ];

  /// The SQLite files of every installed pack, for [RagStore.openFiles].
  List<String> dbPaths() => [
        for (final p in installed())
          ...Directory(p.dir).listSync().whereType<File>().where((f) => f.path.endsWith('.db')).map((f) => f.path),
      ];

  /// The free pack of continent [code] is on the device (downloaded; a
  /// bundled one is not recorded here).
  bool hasContinent(String code) => installed().any((p) => p.id == _continentId(code));
  bool hasPaid(String iso) => installed().any((p) => p.continent == null && p.country == iso && p.tier != 'free');

  /// The free pack of continent [code] — never gated by the store. A
  /// continent the binary carries ([ContinentPacks.bundled]) is refused:
  /// it would be the same tales twice.
  Future<void> installContinent(String code, {void Function(int received, int total)? onProgress}) async {
    final c = _manifest?.continents[code];
    final f = c?.free;
    if (c == null || f == null) throw PackError('$code has no free pack');
    if (c.bundled) throw PackError('$code is bundled with the app');
    final id = _continentId(code);
    return _serial(id, () => _install(id: id, country: code, tier: 'free', file: f, url: Uri.parse('${_manifest!.freeBase}${f.file}'), onProgress: onProgress));
  }

  /// The paid pack of [iso]; needs the store to say the user owns
  /// `pack_<cc>` (or a bundle containing it). Self-contained: unlike §5's
  /// plan it doesn't pull the continent's free pack along — there are no
  /// shared per-country assets (music and sounds live in core), and a
  /// whole continent would be a heavy surprise after buying one country.
  Future<void> installPaid(String iso, {String tier = 'lite', void Function(int received, int total)? onProgress}) async {
    final c = _country(iso);
    final p = c.paid;
    final f = p?.tiers[tier];
    if (p == null || f == null) throw PackError('$iso has no paid $tier pack');
    if (!await store.owns(p.productId)) throw NotEntitled(p.productId);
    final id = _paidId(iso);
    return _serial(id, () => _install(id: id, country: iso, tier: tier, file: f, url: Uri.parse(p.url(_manifest!.paidBase, iso, tier)), onProgress: onProgress));
  }

  /// Installed packs the manifest has a newer version of.
  List<InstalledPack> updatable() {
    final m = _manifest;
    if (m == null) return const [];
    return [
      for (final p in installed())
        if ((p.continent != null ? m.continents[p.continent]?.free?.version : m.countries[p.country]?.paid?.version) case final v? when v > p.version) p,
    ];
  }

  /// The user told a story from [iso]: its packs are in use, keep them —
  /// the country's paid pack and the continent pack its free tales are in.
  void touch(String iso) {
    final now = _clock().millisecondsSinceEpoch;
    _db.execute("UPDATE installed_packs SET last_used_at = ? WHERE country = ? AND id NOT LIKE 'continent.%'", [now, iso]);
    final k = _manifest?.continentOf(iso);
    if (k != null) _db.execute('UPDATE installed_packs SET last_used_at = ? WHERE id = ?', [now, _continentId(k.code)]);
  }

  int bytesOnDisk() => installed().fold(0, (a, p) => a + p.size);

  /// "Uvolnit místo" (§4): removes free (continent) packs unused for
  /// [olderThan], except continents in [keep]. Bought packs go only by
  /// hand ([remove]). Returns bytes freed.
  int freeUpSpace({Duration olderThan = const Duration(days: 30), Set<String> keep = const {}}) {
    final cutoff = _clock().subtract(olderThan);
    var freed = 0;
    for (final p in installed()) {
      if (p.tier == 'free' && !keep.contains(p.country) && p.lastUsed.isBefore(cutoff)) {
        freed += p.size;
        _uninstall(p);
      }
    }
    return freed;
  }

  /// Removes the paid pack of country [iso]; it can be downloaded again.
  void remove(String iso) {
    for (final p in installed().where((p) => p.continent == null && p.country == iso)) {
      _uninstall(p);
    }
  }

  /// Removes the free pack of continent [code].
  void removeContinent(String code) {
    for (final p in installed().where((p) => p.id == _continentId(code))) {
      _uninstall(p);
    }
  }

  void close() => _db.close();

  // ---------------------------------------------------------------------

  String _continentId(String code) => 'continent.$code.${_manifest?.lang ?? 'cs'}.free';
  String _paidId(String iso) => 'country.$iso.${_manifest?.lang ?? 'cs'}.paid';

  CountryPacks _country(String iso) {
    final c = _manifest?.countries[iso];
    if (c == null) throw PackError('no manifest entry for $iso');
    return c;
  }

  Future<void> _serial(String id, Future<void> Function() body) {
    final running = _busy[id];
    if (running != null) return running; // a second tap joins the first download
    // A block body: `=> _busy.remove(id)` would hand whenComplete the
    // removed future — this one — and it would wait on itself forever.
    final f = body().whenComplete(() {
      _busy.remove(id);
    });
    return _busy[id] = f;
  }

  Future<void> _install({required String id, required String country, required String tier, required PackFile file, required Uri url, void Function(int, int)? onProgress}) async {
    final have = _db.select('SELECT version FROM installed_packs WHERE id = ?', [id]);
    if (have.isNotEmpty && (have.first['version'] as int) >= file.version) return;

    // The sha prefix keeps a resumed .part from mixing two builds of one version.
    final part = File('${root.path}/downloads/$id-v${file.version}-${file.sha256.substring(0, 12)}.zip.part');
    if (part.existsSync() && part.lengthSync() > file.size) part.deleteSync();
    if (!part.existsSync() || part.lengthSync() < file.size) {
      await fetcher.download(url, part, onBytes: (n) => onProgress?.call(n, file.size));
    }
    final digest = _sha256File(part);
    if (digest != file.sha256) {
      part.deleteSync(); // corrupt or a different build: next attempt starts clean
      throw PackError('$id: sha256 mismatch');
    }

    final rel = 'packs/$id-v${file.version}';
    final target = Directory('${root.path}/$rel');
    final tmp = Directory('${target.path}.tmp');
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
    tmp.createSync(recursive: true);
    try {
      await _unzip(part, tmp);
      await _verifyContents(tmp);
      if (target.existsSync()) target.deleteSync(recursive: true);
      tmp.renameSync(target.path);
    } catch (_) {
      if (tmp.existsSync()) tmp.deleteSync(recursive: true);
      rethrow;
    }

    final old = installed().where((p) => p.id == id).toList();
    final now = _clock().millisecondsSinceEpoch;
    _db.execute(
      'INSERT INTO installed_packs (id, country, tier, version, dir, size, sha256, installed_at, last_used_at) VALUES (?,?,?,?,?,?,?,?,?) '
      'ON CONFLICT(id) DO UPDATE SET tier = excluded.tier, version = excluded.version, dir = excluded.dir, size = excluded.size, sha256 = excluded.sha256, installed_at = excluded.installed_at',
      [id, country, tier, file.version, rel, _dirSize(target), file.sha256, now, now],
    );
    // An open RagStore may still read the old file; unlinking is safe
    // (the handle keeps it alive) and it goes when the store reopens.
    for (final o in old) {
      if (o.dir != target.path && Directory(o.dir).existsSync()) Directory(o.dir).deleteSync(recursive: true);
    }
    part.deleteSync();
  }

  Future<void> _unzip(File zip, Directory into) async {
    final input = InputFileStream(zip.path);
    try {
      final archive = ZipDecoder().decodeStream(input);
      for (final f in archive.files) {
        if (!f.isFile) continue;
        final name = f.name;
        if (name.startsWith('/') || name.split('/').contains('..')) throw PackError('unsafe path in zip: $name');
        final out = File('${into.path}/$name')..parent.createSync(recursive: true);
        final os = OutputFileStream(out.path);
        f.writeContent(os);
        await os.close();
      }
    } finally {
      await input.close();
    }
  }

  /// Every file pack.json lists is there with its size and sha256, and
  /// the pack doesn't need a newer app.
  Future<void> _verifyContents(Directory dir) async {
    final pj = File('${dir.path}/pack.json');
    if (!pj.existsSync()) throw PackError('pack.json missing');
    final meta = jsonDecode(await pj.readAsString()) as Map<String, dynamic>;
    final minApp = meta['min_app_version'] as String? ?? '0.0.0';
    if (compareVersions(appVersion, minApp) < 0) throw PackError('pack needs app $minApp, this is $appVersion');
    for (final e in (meta['files'] as Map<String, dynamic>).entries) {
      final f = File('${dir.path}/${e.key}');
      final want = e.value as Map<String, dynamic>;
      if (!f.existsSync() || f.lengthSync() != want['size']) throw PackError('${e.key}: missing or wrong size');
      if (_sha256File(f) != want['sha256']) throw PackError('${e.key}: sha256 mismatch');
    }
  }

  /// Chunked, synchronous: a pack is up to ~60 MB (lite), so never whole
  /// in memory, and no stream plumbing to stall.
  static String _sha256File(File f) {
    final out = _DigestSink();
    final conv = sha256.startChunkedConversion(out);
    final raf = f.openSync();
    try {
      final buf = Uint8List(1 << 20);
      for (var n = raf.readIntoSync(buf); n > 0; n = raf.readIntoSync(buf)) {
        conv.add(Uint8List.sublistView(buf, 0, n));
      }
    } finally {
      raf.closeSync();
    }
    conv.close();
    return out.value.toString();
  }

  void _uninstall(InstalledPack p) {
    _db.execute('DELETE FROM installed_packs WHERE id = ?', [p.id]);
    final d = Directory(p.dir);
    if (d.existsSync()) d.deleteSync(recursive: true);
  }

  int _dirSize(Directory d) => d.listSync(recursive: true).whereType<File>().fold(0, (a, f) => a + f.lengthSync());
}

class InstalledPack {
  InstalledPack({required this.id, required this.country, required this.tier, required this.version, required this.dir, required this.size, required this.lastUsed});

  final String id;
  final String country; // ISO, or the continent code of a continent pack
  final String tier;
  final int version;
  final String dir;
  final int size;
  final DateTime lastUsed;

  /// Continent code for `continent.<K>.<lang>.free`, null for country packs.
  String? get continent => id.startsWith('continent.') ? id.split('.')[1] : null;
}

class PackError implements Exception {
  PackError(this.message);
  final String message;
  @override
  String toString() => 'PackError: $message';
}

class NotEntitled extends PackError {
  NotEntitled(String productId) : super('not entitled to $productId');
}

class _DigestSink implements Sink<Digest> {
  late Digest value;

  @override
  void add(Digest data) => value = data;

  @override
  void close() {}
}
