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

/// Download progress per continent code (or [scenesKey] of a country), 0..1; absent when idle.
class PackDownloads extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => const {};

  /// The progress key of [iso]'s all-scenes pack — continent codes are
  /// two letters too (AF), so it can't be the bare ISO.
  static String scenesKey(String iso) => 'scenes:$iso';

  /// Installs continent [code]'s free pack; returns an error message for the UI, or null.
  Future<String?> installContinent(String code) => _install(code, 'Pohádky se nepodařilo stáhnout.', (repo, onProgress) => repo.installContinent(code, onProgress: onProgress));

  /// Installs every scene of [iso] (`scenes.<CC>.<lang>.free`); an error message, or null.
  Future<String?> installScenes(String iso) => _install(scenesKey(iso), 'Obrázky se nepodařilo stáhnout.', (repo, onProgress) => repo.installScenes(iso, onProgress: onProgress));

  Future<String?> _install(String key, String failed, Future<void> Function(PackRepository repo, void Function(int, int) onProgress) body) async {
    final repo = await ref.read(packRepositoryProvider.future);
    if (repo == null) return 'Stahování tu není k dispozici.';
    if (repo.manifest == null) await repo.syncManifest();
    state = {...state, key: 0};
    try {
      await body(repo, (n, total) => state = {...state, key: total == 0 ? 0 : n / total});
      ref.read(installedPacksRevisionProvider.notifier).bump();
      return null;
    } on SocketException {
      return 'Nejsme na internetu — zkus to, až bude signál.';
    } catch (e) {
      debugPrint('install $key: $e');
      return failed;
    } finally {
      state = {...state}..remove(key);
    }
  }
}

final packDownloadsProvider = NotifierProvider<PackDownloads, Map<String, double>>(PackDownloads.new);
