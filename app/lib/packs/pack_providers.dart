import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'pack_fetcher.dart';
import 'pack_manifest.dart';
import 'pack_repository.dart';
import 'store_gateway.dart';

final storeGatewayProvider = Provider<StoreGateway>((ref) => unlockAllForDev ? const UnlockedStoreGateway() : const NoStoreGateway());

/// The downloadable packs, or null where the platform has no support dir
/// (widget tests never resolve it — screens read it with `.value`).
final packRepositoryProvider = FutureProvider<PackRepository?>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    final repo = PackRepository(
      root: Directory('${(await getApplicationSupportDirectory()).path}/content'),
      manifestUrl: Uri.parse(PackRepository.defaultManifestUrl),
      fetcher: HttpPackFetcher(),
      store: ref.watch(storeGatewayProvider),
      appVersion: info.version,
    );
    ref.onDispose(repo.close);
    return repo;
  } catch (e) {
    debugPrint('content packs unavailable: $e');
    return null;
  }
});

/// Synced once per app start, in the background; the cached copy serves
/// offline starts.
final packManifestProvider = FutureProvider<PackManifest?>((ref) async {
  final repo = await ref.watch(packRepositoryProvider.future);
  return repo?.syncManifest();
});

/// Bumped after every install or removal so [ragStoreProvider] reopens
/// with the new set of pack files.
class InstalledPacksRevision extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final installedPacksRevisionProvider = NotifierProvider<InstalledPacksRevision, int>(InstalledPacksRevision.new);

/// Download progress per continent code, 0..1; absent when idle.
class PackDownloads extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => const {};

  /// Installs continent [code]'s free pack; returns an error message for the UI, or null.
  Future<String?> installContinent(String code) async {
    final repo = await ref.read(packRepositoryProvider.future);
    if (repo == null) return 'Stahování tu není k dispozici.';
    if (repo.manifest == null) await repo.syncManifest();
    state = {...state, code: 0};
    try {
      await repo.installContinent(code, onProgress: (n, total) => state = {...state, code: total == 0 ? 0 : n / total});
      ref.read(installedPacksRevisionProvider.notifier).bump();
      return null;
    } on SocketException {
      return 'Nejsme na internetu — zkus to, až bude signál.';
    } catch (e) {
      debugPrint('install $code: $e');
      return 'Pohádky se nepodařilo stáhnout.';
    } finally {
      state = {...state}..remove(code);
    }
  }
}

final packDownloadsProvider = NotifierProvider<PackDownloads, Map<String, double>>(PackDownloads.new);
