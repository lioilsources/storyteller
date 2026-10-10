// "Stažené pohádky" offers the all-scenes pack (scenes.CZ.cs.free) with its
// size, lists it once installed, and deletes it. Real pipeline zip:
// test/fixtures/scenes-cz-v1.zip (rag/tests/make_app_fixture_scenes.py).
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyteller/packs/pack_fetcher.dart';
import 'package:storyteller/packs/pack_providers.dart';
import 'package:storyteller/packs/pack_repository.dart';
import 'package:storyteller/packs/storage_sheet.dart';
import 'package:storyteller/packs/store_gateway.dart';

class _Net implements PackFetcher {
  final files = <String, Uint8List>{};

  @override
  Future<Uint8List> get(Uri url) async => files[url.toString()] ?? (throw const SocketException('offline'));

  @override
  Future<void> download(Uri url, File part, {void Function(int)? onBytes}) async {
    final b = files[url.toString()] ?? (throw const SocketException('offline'));
    part.writeAsBytesSync(b);
    onBytes?.call(b.length);
  }
}

void main() {
  late Directory tmp;
  late PackRepository repo;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('sheet');
    final zip = File('test/fixtures/scenes-cz-v1.zip').readAsBytesSync();
    final net = _Net()
      ..files['https://example.test/free-v1/scenes-cz-v1.zip'] = zip
      ..files['https://example.test/manifest.json'] = utf8.encode(jsonEncode({
        'schema': 4, 'lang': 'cs', 'min_app_version': '1.4.0',
        'base_urls': {'free': 'https://example.test/free-v1/', 'paid': 'https://example.test/'},
        'regions': {}, 'countries': {},
        'scenes': {
          'cz': {'name': {'cs': 'Česko – všechny scény'}, 'country': 'CZ', 'free': {'version': 1, 'size': zip.length, 'sha256': sha256.convert(zip).toString(), 'images': 4, 'file': 'scenes-cz-v1.zip'}},
        },
      }));
    repo = PackRepository(root: tmp, manifestUrl: Uri.parse('https://example.test/manifest.json'), fetcher: net, store: const NoStoreGateway(), appVersion: '1.4.0');
    await repo.syncManifest();
  });
  tearDown(() {
    repo.close();
    tmp.deleteSync(recursive: true);
  });

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        packRepositoryProvider.overrideWith((ref) async => repo),
        packManifestProvider.overrideWith((ref) async => repo.manifest),
      ],
      child: const MaterialApp(home: Scaffold(body: StorageSheet())),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('offers the scenes pack with its size until it is installed, then lists and deletes it', (tester) async {
    await pump(tester);
    expect(find.byKey(storageScenesOfferKey), findsOneWidget);
    expect(find.text('Česko – všechny scény'), findsOneWidget);
    expect(find.text('Obrázek ke každému kroku vyprávění · ${formatBytes(repo.manifest!.scenes['CZ']!.free!.size)} · zdarma'), findsOneWidget);

    // what the download button does, with real file I/O outside fake async
    final container = ProviderScope.containerOf(tester.element(find.byType(StorageSheet)));
    expect(await tester.runAsync(() => container.read(packDownloadsProvider.notifier).installScenes('CZ')), isNull);
    await tester.pumpAndSettle();
    expect(find.byKey(storageScenesOfferKey), findsNothing);
    expect(find.text('Česko – všechny scény'), findsOneWidget); // now as installed
    expect(find.textContaining('· zdarma'), findsOneWidget);

    await tester.tap(find.byTooltip('Smazat'));
    await tester.pumpAndSettle();
    expect(repo.hasScenes('CZ'), isFalse);
    expect(find.byKey(storageScenesOfferKey), findsOneWidget); // offered again
  });
}
