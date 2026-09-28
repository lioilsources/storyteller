import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/packs/pack_fetcher.dart';
import 'package:storyteller/packs/pack_repository.dart';
import 'package:storyteller/packs/store_gateway.dart';
import 'package:storyteller/rag/rag_store.dart';

/// Serves bytes by URL; [cutAfter] simulates a dropped connection once.
class FakeFetcher implements PackFetcher {
  final files = <String, Uint8List>{};
  int? cutAfter;
  final ranges = <int>[];

  @override
  Future<Uint8List> get(Uri url) async {
    final b = files[url.toString()];
    if (b == null) throw const SocketException('offline');
    return b;
  }

  @override
  Future<void> download(Uri url, File part, {void Function(int)? onBytes}) async {
    final b = files[url.toString()];
    if (b == null) throw const SocketException('offline');
    final have = part.existsSync() ? part.lengthSync() : 0;
    ranges.add(have);
    var chunk = b.sublist(have);
    final cut = cutAfter;
    if (cut != null) {
      cutAfter = null;
      part.writeAsBytesSync(chunk.sublist(0, cut), mode: FileMode.append);
      throw const SocketException('connection reset');
    }
    part.writeAsBytesSync(chunk, mode: FileMode.append);
    onBytes?.call(have + chunk.length);
  }
}

Uint8List packZip({required String id, int version = 1, String minApp = '1.0.0', Map<String, List<int>>? extra}) {
  final db = utf8.encode('sqlite bytes of $id v$version');
  final dbName = '$id.db';
  final meta = {
    'id': id, 'version': version, 'min_app_version': minApp,
    'files': {dbName: {'size': db.length, 'sha256': sha256.convert(db).toString()}},
  };
  final a = Archive()
    ..add(ArchiveFile.bytes('pack.json', utf8.encode(jsonEncode(meta))))
    ..add(ArchiveFile.bytes(dbName, db));
  extra?.forEach((k, v) => a.add(ArchiveFile.bytes(k, v)));
  return Uint8List.fromList(ZipEncoder().encode(a));
}

const base = 'https://example.test/releases/download/';
const manifestUrl = 'https://example.test/manifest.json';

Map<String, dynamic> manifest({int freeV = 1, int paidV = 1, required Uint8List free, required Uint8List paid, int schema = 2, String minApp = '1.0.0'}) => {
      'schema': schema, 'lang': 'cs', 'min_app_version': minApp,
      'base_urls': {'free': '${base}free-v1/', 'paid': base},
      'countries': {
        'gh': {
          'name': {'en': 'Ghana'},
          'free': {'version': freeV, 'size': free.length, 'sha256': sha256.convert(free).toString(), 'tales': 5, 'file': 'gh-free-v$freeV.zip'},
          'paid': {'product_id': 'pack_gh', 'version': paidV, 'tales': 15, 'tiers': {'lite': {'size': paid.length, 'sha256': sha256.convert(paid).toString()}}},
        },
      },
    };

void main() {
  late Directory tmp;
  late FakeFetcher net;
  late DateTime now;

  PackRepository repo({StoreGateway store = const NoStoreGateway()}) => PackRepository(
        root: tmp, manifestUrl: Uri.parse(manifestUrl), fetcher: net, store: store, appVersion: '1.4.0', clock: () => now);

  void publish({int freeV = 1, int paidV = 1, Uint8List? free, Uint8List? paid, int schema = 2, String minApp = '1.0.0'}) {
    free ??= packZip(id: 'country.GH.cs.free', version: freeV);
    paid ??= packZip(id: 'country.GH.cs.paid', version: paidV);
    net.files['${base}free-v1/gh-free-v$freeV.zip'] = free;
    net.files['${base}pack-gh-v$paidV/gh-lite.zip'] = paid;
    net.files[manifestUrl] = utf8.encode(jsonEncode(manifest(freeV: freeV, paidV: paidV, free: free, paid: paid, schema: schema, minApp: minApp)));
  }

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('packs');
    net = FakeFetcher();
    now = DateTime(2026, 9, 29);
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  test('free pack installs, verifies and shows up as a db path', () async {
    publish();
    final r = repo();
    expect((await r.syncManifest())!.countries.keys, ['GH']);
    await r.installFree('GH');
    expect(r.hasFree('GH'), isTrue);
    expect(r.dbPaths().single, endsWith('country.GH.cs.free-v1/country.GH.cs.free.db'));
    expect(Directory('${tmp.path}/downloads').listSync(), isEmpty);
    r.close();
  });

  test('an interrupted download resumes from where it stopped', () async {
    publish();
    final r = repo();
    await r.syncManifest();
    net.cutAfter = 40;
    await expectLater(r.installFree('GH'), throwsA(isA<SocketException>()));
    await r.installFree('GH');
    expect(net.ranges, [0, 40]);
    expect(r.hasFree('GH'), isTrue);
    r.close();
  });

  test('a corrupted download is rejected and not installed', () async {
    publish();
    final good = net.files['${base}free-v1/gh-free-v1.zip']!;
    net.files['${base}free-v1/gh-free-v1.zip'] = Uint8List.fromList([...good]..[10] ^= 0xff);
    final r = repo();
    await r.syncManifest();
    await expectLater(r.installFree('GH'), throwsA(isA<PackError>()));
    expect(r.installed(), isEmpty);
    expect(Directory('${tmp.path}/downloads').listSync(), isEmpty); // next try starts clean
    r.close();
  });

  test('a zip escaping its directory is refused', () async {
    publish(free: packZip(id: 'country.GH.cs.free', extra: {'../evil.txt': [1]}));
    final r = repo();
    await r.syncManifest();
    await expectLater(r.installFree('GH'), throwsA(isA<PackError>()));
    expect(File('${tmp.path}/packs/evil.txt').existsSync(), isFalse);
    r.close();
  });

  test('paid pack needs the entitlement, then brings the free one along', () async {
    publish();
    final locked = repo();
    await locked.syncManifest();
    await expectLater(locked.installPaid('GH'), throwsA(isA<NotEntitled>()));
    locked.close();

    final r = repo(store: const UnlockedStoreGateway());
    await r.syncManifest();
    await r.installPaid('GH');
    expect(r.hasFree('GH') && r.hasPaid('GH'), isTrue);
    expect(r.dbPaths(), hasLength(2));
    r.close();
  });

  test('a newer version replaces the old one', () async {
    publish();
    final r = repo();
    await r.syncManifest();
    await r.installFree('GH');
    publish(freeV: 2);
    await r.syncManifest();
    expect(r.updatable().single.id, 'country.GH.cs.free');
    await r.installFree('GH');
    expect(r.installed().single.version, 2);
    expect(Directory('${tmp.path}/packs/country.GH.cs.free-v1').existsSync(), isFalse);
    r.close();
  });

  test('freeing space drops only stale free packs of countries not bought', () async {
    publish();
    final r = repo(store: const UnlockedStoreGateway());
    await r.syncManifest();
    await r.installFree('GH');
    now = now.add(const Duration(days: 31));
    expect(r.freeUpSpace(keep: {'GH'}), 0);
    expect(r.freeUpSpace(), greaterThan(0));
    expect(r.installed(), isEmpty);

    await r.installPaid('GH');
    now = now.add(const Duration(days: 60));
    expect(r.freeUpSpace(), 0); // bought: removed only by hand
    r.remove('GH');
    expect(r.installed(), isEmpty);
    r.close();
  });

  test('offline start uses the cached manifest; an unreadable one is ignored', () async {
    publish();
    final r = repo();
    await r.syncManifest();
    r.close();

    net.files.clear();
    final offline = repo();
    expect((await offline.syncManifest())?.countries.keys, ['GH']);
    offline.close();

    publish(schema: 3);
    final newer = repo();
    expect((await newer.syncManifest())?.schema, 2); // schema 3 ignored, cache kept
    newer.close();

    publish(minApp: '9.0.0');
    final tooOld = repo();
    expect((await tooOld.syncManifest())?.minAppVersion, '1.0.0');
    tooOld.close();
  });

  // A real rag.pack_builder zip (Madagascar's free tier, 2026-09-29):
  // the pipeline and the client agree on the format, end to end.
  test('a pack_builder zip installs and opens in RagStore', () async {
    final zip = File('test/fixtures/mg-free-v1.zip').readAsBytesSync();
    net.files['${base}free-v1/mg-free-v1.zip'] = zip;
    net.files[manifestUrl] = utf8.encode(jsonEncode({
      'schema': 2, 'lang': 'cs', 'min_app_version': '1.4.0',
      'base_urls': {'free': '${base}free-v1/', 'paid': base},
      'countries': {'mg': {'name': {'en': 'Madagascar'}, 'free': {'version': 1, 'size': zip.length, 'sha256': sha256.convert(zip).toString(), 'tales': 1, 'file': 'mg-free-v1.zip'}}},
    }));
    final r = repo();
    await r.syncManifest();
    await r.installFree('MG');
    final store = RagStore.openFiles(r.dbPaths());
    final cast = store.motifs('character', country: 'MG');
    expect(cast, isNotEmpty);
    expect(cast.first.title, isNotEmpty);
    store.close();
    r.close();
  });
}
