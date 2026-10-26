import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'pack_fetcher.dart';
import 'pack_manifest.dart';
import 'pack_repository.dart';
import 'store_gateway.dart';

/// `manifest.v4.json` of the build, fetched with the bundled packs
/// (app/rag_packs.sha256).
const bundledManifestAsset = 'assets/rag/packs/manifest.v4.json';

/// The App Store / Play on phones; no store elsewhere (desktop, widget
/// tests), and everything owned in `STORYTELLER_UNLOCK_ALL` builds.
final storeGatewayProvider = Provider<StoreGateway>((ref) {
  if (unlockAllForDev) return const UnlockedStoreGateway();
  if (kIsWeb || !(Platform.isIOS || Platform.isAndroid)) return const NoStoreGateway();
  final g = InAppStoreGateway(file: getApplicationSupportDirectory().then((d) => File('${d.path}/entitlements.json')));
  ref.onDispose(g.dispose);
  return g;
});

/// Product ids the user owns (`*` = everything, development builds), then
/// again after every purchase or restore.
final entitlementsProvider = StreamProvider<Set<String>>((ref) async* {
  final store = ref.watch(storeGatewayProvider);
  yield await store.entitlements();
  yield* store.changes;
});

/// What the store sells of the manifest's parts, with prices; empty where
/// nothing can be bought, so the app then offers no purchase at all.
final storeProductsProvider = FutureProvider<Map<String, StoreProduct>>((ref) async {
  final manifest = await ref.watch(packManifestProvider.future);
  final ids = {for (final r in manifest?.regions.values ?? const <RegionPacks>[]) for (final p in r.parts) p.productId};
  final store = ref.watch(storeGatewayProvider);
  try {
    if (ids.isEmpty || !await store.isAvailable()) return const {};
    return await store.products(ids);
  } catch (e) {
    debugPrint('store products: $e');
    return const {};
  }
});

/// The downloadable packs, or null where the platform has no support dir
/// (widget tests never resolve it — screens read it with `.value`).
final packRepositoryProvider = FutureProvider<PackRepository?>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    List<int>? bundled;
    try {
      bundled = (await rootBundle.load(bundledManifestAsset)).buffer.asUint8List();
    } catch (_) {
      // a build without packs (CI): nothing to fall back to
    }
    final repo = PackRepository(
      root: Directory('${(await getApplicationSupportDirectory()).path}/content'),
      manifestUrl: Uri.parse(PackRepository.defaultManifestUrl),
      fetcher: HttpPackFetcher(),
      store: ref.watch(storeGatewayProvider),
      appVersion: info.version,
      bundledManifest: bundled,
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

/// Download progress per region code (or [partKey], or [scenesKey] of a country), 0..1;
/// -1 while a part is being bought; absent when idle.
class PackDownloads extends Notifier<Map<String, double>> {
  @override
  Map<String, double> build() => const {};

  /// The progress key of [iso]'s all-scenes pack.
  static String scenesKey(String iso) => 'scenes:$iso';

  /// The progress key of part [n] of region [code].
  static String partKey(String code, int n) => '$code:p$n';

  /// Installs region [code]'s free pack; returns an error message for the UI, or null.
  Future<String?> installRegionFree(String code) => _install(code, 'Pohádky se nepodařilo stáhnout.', (repo, onProgress) => repo.installRegionFree(code, onProgress: onProgress));

  /// Installs part [n] of region [code] (the store must say it's owned); an error message, or null.
  Future<String?> installPart(String code, int n) => _install(partKey(code, n), 'Pohádky se nepodařilo stáhnout.', (repo, onProgress) => repo.installPart(code, n, onProgress: onProgress));

  /// Buys part [n] of region [code] and, once it's owned, downloads it.
  /// A message for the UI, or null (bought and here, or the user cancelled).
  Future<String?> buyPart(String code, int n) async {
    final key = partKey(code, n);
    if (state.containsKey(key)) return null;
    final manifest = await ref.read(packManifestProvider.future);
    final part = manifest?.regions[code]?.part(n);
    if (part == null) return 'Tenhle díl teď koupit nejde.';
    state = {...state, key: -1}; // in the store's hands
    final Purchase outcome;
    try {
      outcome = await ref.read(storeGatewayProvider).buy(part.productId);
    } finally {
      state = {...state}..remove(key);
    }
    return switch (outcome) {
      Purchase.bought => installPart(code, n),
      Purchase.pending => 'Nákup čeká na schválení. Díl se stáhne, až projde.',
      Purchase.cancelled => null,
      Purchase.failed => 'Nákup se nepovedl.',
    };
  }

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

/// "Obnovit nákupy": what the store gives back is owned again and the globe
/// offers it to download (not all at once: a new phone may be short of space).
Future<String> restorePurchases(WidgetRef ref) async {
  try {
    final got = await ref.read(storeGatewayProvider).restore();
    final parts = got.length;
    return switch (parts) {
      0 => 'Na tomhle účtu nejsou žádné nákupy.',
      1 => 'Obnoven 1 díl. Stáhneš ho z planety.',
      _ => 'Obnoveno $parts ${parts < 5 ? 'díly' : 'dílů'}. Stáhneš je z planety.',
    };
  } catch (e) {
    debugPrint('restore: $e');
    return 'Nákupy se nepodařilo obnovit — zkus to, až bude signál.';
  }
}
