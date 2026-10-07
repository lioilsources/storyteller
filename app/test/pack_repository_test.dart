import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
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
const manifestUrl = 'https://example.test/manifest.v4.json';

Map<String, dynamic> manifest({int freeV = 1, int partV = 1, required Uint8List free, required Uint8List part, Uint8List? scenes, int scenesV = 1, int schema = 4, String minApp = '1.0.0'}) => {
      'schema': schema, 'lang': 'cs', 'min_app_version': minApp,
      'base_urls': {'free': '${base}free-v2/', 'paid': base},
      'regions': {
        'czsk': {
          'name': {'cs': 'Česko a Slovensko'}, 'bundled': true, 'countries': ['CZ', 'SK'],
          'free': {'version': 1, 'size': 1, 'sha256': '00', 'tales': 10, 'file': 'region-czsk-free-v1.zip'},
          'parts': [],
        },
        'afri': {
          'name': {'cs': 'Afrika', 'en': 'Africa'}, 'bundled': false, 'countries': ['GH', 'NG'],
          'free': {'version': freeV, 'size': free.length, 'sha256': sha256.convert(free).toString(), 'tales': 10, 'file': 'region-afri-free-v$freeV.zip'},
          'parts': [
            {'n': 1, 'product_id': 'pack_afri_1', 'version': partV, 'size': part.length, 'sha256': sha256.convert(part).toString(), 'tales': 50, 'file': 'afri-p1.zip'},
          ],
        },
      },
      'countries': {
        'gh': {'name': {'en': 'Ghana'}, 'region': 'AFRI', 'tales': 36, 'in': {'free': 6, 'parts': {'1': 30}}, 'coming': 4},
        'ng': {'name': {'en': 'Nigeria'}, 'region': 'AFRI', 'tales': 24, 'in': {'free': 4, 'parts': {'1': 20}}, 'coming': 0},
        'cz': {'name': {'en': 'Czechia'}, 'region': 'CZSK', 'tales': 9, 'in': {'free': 9, 'parts': {}}, 'coming': 110},
      },
      if (scenes != null)
        'scenes': {
          'cz': {
            'name': {'cs': 'Česko – všechny scény'}, 'country': 'CZ',
            'free': {'version': scenesV, 'size': scenes.length, 'sha256': sha256.convert(scenes).toString(), 'images': 16145, 'file': 'scenes-cz-v$scenesV.zip'},
          },
        },
    };

void main() {
  late Directory tmp;
  late FakeFetcher net;
  late DateTime now;

  PackRepository repo({StoreGateway store = const NoStoreGateway()}) => PackRepository(
        root: tmp, manifestUrl: Uri.parse(manifestUrl), fetcher: net, store: store, appVersion: '1.7.0', clock: () => now);

  void publish({int freeV = 1, int partV = 1, Uint8List? free, Uint8List? part, int? scenesV, Uint8List? scenes, int schema = 4, String minApp = '1.0.0'}) {
    free ??= packZip(id: 'region.AFRI.cs.free', version: freeV);
    part ??= packZip(id: 'region.AFRI.cs.p1', version: partV);
    if (scenesV != null) scenes ??= packZip(id: 'scenes.CZ.cs.free', version: scenesV);
    net.files['${base}free-v2/region-afri-free-v$freeV.zip'] = free;
    net.files['${base}region-afri-p1-v$partV/afri-p1.zip'] = part;
    if (scenes != null) net.files['${base}free-v2/scenes-cz-v${scenesV ?? 1}.zip'] = scenes;
    net.files[manifestUrl] = utf8.encode(jsonEncode(manifest(freeV: freeV, partV: partV, free: free, part: part, scenes: scenes, scenesV: scenesV ?? 1, schema: schema, minApp: minApp)));
  }

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('packs');
    net = FakeFetcher();
    now = DateTime(2026, 9, 29);
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  test('a region free pack installs, verifies and shows up as a db path', () async {
    publish();
    final r = repo();
    final m = (await r.syncManifest())!;
    expect(m.regions.keys, ['CZSK', 'AFRI']);
    expect(m.regionOf('NG')!.code, 'AFRI');
    expect(m.regionOf('CZ')!.bundled, isTrue);
    expect(m.regionOf('FR'), isNull); // no tales from there
    await r.installRegionFree('AFRI');
    expect(r.hasRegionFree('AFRI'), isTrue);
    expect(r.hasPart('AFRI', 1), isFalse);
    expect(r.dbPaths().single, endsWith('region.AFRI.cs.free-v1/region.AFRI.cs.free.db'));
    expect(Directory('${tmp.path}/downloads').listSync(), isEmpty);
    r.close();
  });

  test('the manifest says how many tales of a country are in which pack', () async {
    publish();
    final r = repo();
    final m = (await r.syncManifest())!;
    final gh = m.countries['GH']!;
    expect((gh.region, gh.tales, gh.free, gh.inParts, gh.coming), ('AFRI', 36, 6, 30, 4));
    expect(gh.parts, {1: 30});
    expect(m.countries['CZ']!.inParts, 0);
    final p = m.regions['AFRI']!.part(1)!;
    expect((p.productId, p.file.tales), ('pack_afri_1', 50));
    expect(p.url(m.paidBase, 'AFRI'), '${base}region-afri-p1-v1/afri-p1.zip');
    expect(m.regions['AFRI']!.part(2), isNull);
    r.close();
  });

  test('a free pack the binary carries is never downloaded', () async {
    publish();
    final r = repo();
    await r.syncManifest();
    await expectLater(r.installRegionFree('CZSK'), throwsA(isA<PackError>()));
    expect(r.installed(), isEmpty);
    r.close();
  });

  test('an interrupted download resumes from where it stopped', () async {
    publish();
    final r = repo();
    await r.syncManifest();
    net.cutAfter = 40;
    await expectLater(r.installRegionFree('AFRI'), throwsA(isA<SocketException>()));
    await r.installRegionFree('AFRI');
    expect(net.ranges, [0, 40]);
    expect(r.hasRegionFree('AFRI'), isTrue);
    r.close();
  });

  test('a corrupted download is rejected and not installed', () async {
    publish();
    final good = net.files['${base}free-v2/region-afri-free-v1.zip']!;
    net.files['${base}free-v2/region-afri-free-v1.zip'] = Uint8List.fromList([...good]..[10] ^= 0xff);
    final r = repo();
    await r.syncManifest();
    await expectLater(r.installRegionFree('AFRI'), throwsA(isA<PackError>()));
    expect(r.installed(), isEmpty);
    expect(Directory('${tmp.path}/downloads').listSync(), isEmpty); // next try starts clean
    r.close();
  });

  test('a zip escaping its directory is refused', () async {
    publish(free: packZip(id: 'region.AFRI.cs.free', extra: {'../evil.txt': [1]}));
    final r = repo();
    await r.syncManifest();
    await expectLater(r.installRegionFree('AFRI'), throwsA(isA<PackError>()));
    expect(File('${tmp.path}/packs/evil.txt').existsSync(), isFalse);
    r.close();
  });

  test('a paid part needs the entitlement and stands on its own', () async {
    publish();
    final locked = repo();
    await locked.syncManifest();
    await expectLater(locked.installPart('AFRI', 1), throwsA(isA<NotEntitled>()));
    locked.close();

    final r = repo(store: const UnlockedStoreGateway());
    await r.syncManifest();
    await expectLater(r.installPart('AFRI', 2), throwsA(isA<PackError>())); // no such part yet
    await r.installPart('AFRI', 1);
    expect(r.hasPart('AFRI', 1), isTrue);
    expect(r.hasRegionFree('AFRI'), isFalse); // the free ten isn't dragged along
    final p = r.installed().single;
    expect((p.region, p.part, p.tier), ('AFRI', 1, 'part'));
    r.close();
  });

  test('a newer version replaces the old one', () async {
    publish();
    final r = repo(store: const UnlockedStoreGateway());
    await r.syncManifest();
    await r.installRegionFree('AFRI');
    await r.installPart('AFRI', 1);
    publish(freeV: 2, partV: 3);
    await r.syncManifest();
    expect(r.updatable().map((p) => p.id), ['region.AFRI.cs.free', 'region.AFRI.cs.p1']);
    await r.installRegionFree('AFRI');
    await r.installPart('AFRI', 1);
    expect(r.installed().map((p) => p.version), [2, 3]);
    expect(r.updatable(), isEmpty);
    expect(Directory('${tmp.path}/packs/region.AFRI.cs.free-v1').existsSync(), isFalse);
    r.close();
  });

  test('freeing space drops only stale free packs, never bought parts', () async {
    publish();
    final r = repo(store: const UnlockedStoreGateway());
    await r.syncManifest();
    await r.installRegionFree('AFRI');
    now = now.add(const Duration(days: 31));
    expect(r.freeUpSpace(keep: {'AFRI'}), 0);
    r.touch('NG'); // a story from Nigeria keeps Africa
    expect(r.freeUpSpace(), 0);
    now = now.add(const Duration(days: 31));
    expect(r.freeUpSpace(), greaterThan(0));
    expect(r.installed(), isEmpty);

    await r.installPart('AFRI', 1);
    await r.installRegionFree('AFRI');
    now = now.add(const Duration(days: 60));
    expect(r.freeUpSpace(), greaterThan(0)); // the free ten goes…
    expect(r.hasPart('AFRI', 1), isTrue); // …the bought part stays: removed only by hand
    r.remove('region.AFRI.cs.p1');
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
    expect((await offline.syncManifest())?.regions.keys, ['CZSK', 'AFRI']);
    offline.close();

    for (final other in [3, 5]) {
      publish(schema: other);
      final r = repo();
      expect((await r.syncManifest())?.schema, 4); // another schema is ignored, cache kept
      r.close();
    }

    publish(minApp: '9.0.0');
    final tooOld = repo();
    expect((await tooOld.syncManifest())?.minAppVersion, '1.0.0');
    tooOld.close();
  });

  test('a first start offline falls back to the manifest the app was built with', () async {
    publish();
    final built = net.files[manifestUrl]!;
    net.files.clear();
    final r = PackRepository(root: tmp, manifestUrl: Uri.parse(manifestUrl), fetcher: net, store: const NoStoreGateway(), appVersion: '1.7.0', bundledManifest: built);
    expect((await r.syncManifest())?.countries['GH']?.tales, 36);
    expect(File('${tmp.path}/manifest.v4.json').existsSync(), isFalse); // not a sync: the next start tries the net again
    r.close();
  });

  test('packs of the continent era are removed: their tales are in the regions now', () async {
    publish();
    final r = repo();
    await r.syncManifest();
    await r.installRegionFree('AFRI');
    r.close();
    // what a 1.6 install left behind
    final db = sqlite3.open('${tmp.path}/index.db');
    for (final id in ['continent.AF.cs.free', 'country.GH.cs.paid']) {
      Directory('${tmp.path}/packs/$id-v1').createSync(recursive: true);
      db.execute("INSERT INTO installed_packs VALUES (?, 'AF', 'free', 1, ?, 10, '00', 0, 0)", [id, 'packs/$id-v1']);
    }
    db.close();
    File('${tmp.path}/manifest.json').writeAsStringSync('{"schema": 3}');

    final upgraded = repo();
    expect(upgraded.installed().single.id, 'region.AFRI.cs.free');
    expect(Directory('${tmp.path}/packs/continent.AF.cs.free-v1').existsSync(), isFalse);
    expect(File('${tmp.path}/manifest.json').existsSync(), isFalse);
    upgraded.close();
  });

  // A real pipeline zip (Africa's free pack with only Madagascar in it,
  // rag.pack_builder 2026-10-04 — the pack format didn't change with the
  // regions, only its id and the manifest around it): the pipeline and
  // the client agree on the format, end to end — pack_tales included.
  test('a pipeline pack zip installs and opens in RagStore', () async {
    final zip = File('test/fixtures/continent-af-free-v1.zip').readAsBytesSync();
    net.files['${base}free-v2/region-afri-free-v1.zip'] = zip;
    net.files[manifestUrl] = utf8.encode(jsonEncode({
      'schema': 4, 'lang': 'cs', 'min_app_version': '1.4.0',
      'base_urls': {'free': '${base}free-v2/', 'paid': base},
      'regions': {
        'afri': {'name': {'cs': 'Afrika'}, 'bundled': false, 'countries': ['MG'], 'free': {'version': 1, 'size': zip.length, 'sha256': sha256.convert(zip).toString(), 'tales': 1, 'file': 'region-afri-free-v1.zip'}, 'parts': []},
      },
      'countries': {'mg': {'name': {'en': 'Madagascar'}, 'region': 'AFRI', 'tales': 1, 'in': {'free': 1, 'parts': {}}, 'coming': 0}},
    }));
    final r = repo();
    await r.syncManifest();
    await r.installRegionFree('AFRI');
    final store = RagStore.openFiles(r.dbPaths());
    final cast = store.motifs('character', country: 'MG');
    expect(cast, isNotEmpty);
    expect(cast.first.title, isNotEmpty);
    expect(store.taleCounts()['MG'], 1);
    expect(store.motifSounds([cast.first.id]), isEmpty); // built before motif_sounds existed
    store.close();
    r.close();
  });

  test('the all-scenes pack installs, goes last, updates and goes with "Uvolnit místo"', () async {
    publish(scenesV: 1);
    final r = repo(store: const UnlockedStoreGateway());
    final m = (await r.syncManifest())!;
    expect(m.scenes.keys, ['CZ']);
    expect(m.scenes['CZ']!.name, 'Česko – všechny scény');
    expect(m.scenes['CZ']!.free!.images, 16145);
    await r.installScenes('CZ');
    await r.installRegionFree('AFRI');
    expect(r.hasScenes('CZ'), isTrue);
    expect(r.installed().firstWhere((p) => p.scenes != null).tier, 'free');
    // RagStore takes the first exact scene in pack order: scenes come last
    expect(r.dbPaths().last, endsWith('scenes.CZ.cs.free-v1/scenes.CZ.cs.free.db'));

    publish(scenesV: 2);
    await r.syncManifest();
    expect(r.updatable().map((p) => p.id), ['scenes.CZ.cs.free']);
    await r.installScenes('CZ');
    expect(r.installed().firstWhere((p) => p.scenes == 'CZ').version, 2);

    now = now.add(const Duration(days: 31));
    r.touch('CZ'); // a Czech story keeps them
    expect(r.freeUpSpace(keep: {'AFRI'}), 0);
    now = now.add(const Duration(days: 31));
    expect(r.freeUpSpace(keep: {'AFRI'}), greaterThan(0));
    expect(r.hasScenes('CZ'), isFalse);
    expect(r.hasRegionFree('AFRI'), isTrue);

    await r.installScenes('CZ');
    r.remove('scenes.CZ.cs.free');
    expect(r.hasScenes('CZ'), isFalse);
    r.close();
  });

  test('a manifest without scenes offers none (older pipeline)', () async {
    publish();
    final r = repo();
    expect((await r.syncManifest())!.scenes, isEmpty);
    await expectLater(r.installScenes('CZ'), throwsA(isA<PackError>()));
    r.close();
  });

  // A real rag.pack_builder scenes zip (rag/tests/make_app_fixture_scenes.py):
  // two real Czech renders plus a scene for the mini fixture's task and
  // problem motifs. Order: the bundled pack's scene wins, the scenes pack
  // fills in where the bundled one has none.
  test('a pack_builder scenes zip installs and RagStore finds scenes in it', () async {
    final zip = File('test/fixtures/scenes-cz-v1.zip').readAsBytesSync();
    publish(scenesV: 1, scenes: zip);
    final r = repo();
    await r.syncManifest();
    await r.installScenes('CZ');
    final store = RagStore.openFiles(['test/fixtures/mini.CZ.cs.db', ...r.dbPaths()]);
    final task = store.motifs('task', country: 'CZ').single.id;
    final problem = store.motifs('problem', country: 'CZ').single.id;

    expect(store.scene(motifIds: [task], phases: ['task'])!.sceneId, 's-well'); // bundled first
    final p = store.scene(motifIds: [problem], phases: ['problem', 'climax'])!;
    expect((p.sceneId, p.exact), ('s-dragon-all', true)); // only in the scenes pack
    expect(String.fromCharCodes(p.jpeg.sublist(8, 12)), 'WEBP');
    expect(store.scene(motifIds: ['98a283cd49943f48'], phases: ['climax'])?.sceneId, 'a1770370f5a30646'); // a real render

    // pictures only: nothing new for the pickers or the globe
    expect(store.motifs('task', country: 'CZ'), hasLength(1));
    expect(store.taleCounts(), {'CZ': 1});
    store.close();

    final bundledOnly = RagStore.openFiles(['test/fixtures/mini.CZ.cs.db']);
    expect(bundledOnly.scene(motifIds: [problem], phases: ['problem', 'climax']), isNull);
    bundledOnly.close();
    r.close();
  });
}
