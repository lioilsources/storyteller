import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/l10n.dart';
import '../l10n/lang.dart';
import '../rag/rag_store.dart';
import 'pack_fetcher.dart';
import 'pack_manifest.dart';
import 'pack_repository.dart';
import 'store_gateway.dart';

/// `manifest.v4.json` of the build, fetched with the bundled packs
/// (app/rag_packs.sha256); other content languages `manifest.v4.<lang>.json`.
const bundledManifestAsset = 'assets/rag/packs/manifest.v4.json';

String bundledManifestAssetFor(String lang) => '${RagStore.packDir}${PackRepository.manifestName(lang)}';

/// The language of the content (packs, manifest): the UI's when the build
/// carries its core pack, else Czech (`RagStore.contentLangOf`). Async
/// because it reads the asset manifest; widget tests never resolve it, like
/// the packs themselves.
final contentLangProvider = FutureProvider<String>((ref) async {
  final ui = ref.watch(appLangProvider);
  if (ui == 'cs') return 'cs';
  try {
    final assets = (await AssetManifest.loadFromAssetBundle(rootBundle)).listAssets();
    return RagStore.contentLangOf(assets, ui);
  } catch (_) {
    return 'cs';
  }
});

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
    final lang = await ref.watch(contentLangProvider.future);
    List<int>? bundled;
    try {
      bundled = (await rootBundle.load(bundledManifestAssetFor(lang))).buffer.asUint8List();
    } catch (_) {
      // a build without packs (CI): nothing to fall back to
    }
    final repo = PackRepository(
      root: Directory('${(await getApplicationSupportDirectory()).path}/content'),
      manifestUrl: PackRepository.manifestUrlFor(lang),
      fetcher: HttpPackFetcher(),
      store: ref.watch(storeGatewayProvider),
      appVersion: info.version,
      bundledManifest: bundled,
      lang: lang,
      uiLang: ref.watch(appLangProvider),
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

  AppLocalizations get _l => l10nFor(ref.read(appLangProvider));

  /// Installs region [code]'s free pack; returns an error message for the UI, or null.
  Future<String?> installRegionFree(String code) => _install(code, _l.packDownloadFailed, (repo, onProgress) => repo.installRegionFree(code, onProgress: onProgress));

  /// Installs part [n] of region [code] (the store must say it's owned); an error message, or null.
  Future<String?> installPart(String code, int n) => _install(partKey(code, n), _l.packDownloadFailed, (repo, onProgress) => repo.installPart(code, n, onProgress: onProgress));

  /// Buys part [n] of region [code] and, once it's owned, downloads it.
  /// A message for the UI, or null (bought and here, or the user cancelled).
  Future<String?> buyPart(String code, int n) async {
    final key = partKey(code, n);
    if (state.containsKey(key)) return null;
    final manifest = await ref.read(packManifestProvider.future);
    final part = manifest?.regions[code]?.part(n);
    if (part == null) return _l.packPartUnavailable;
    state = {...state, key: -1}; // in the store's hands
    final Purchase outcome;
    try {
      outcome = await ref.read(storeGatewayProvider).buy(part.productId);
    } finally {
      state = {...state}..remove(key);
    }
    return switch (outcome) {
      Purchase.bought => installPart(code, n),
      Purchase.pending => _l.packPurchasePending,
      Purchase.cancelled => null,
      Purchase.failed => _l.packPurchaseFailed,
    };
  }

  /// Installs every scene of [iso] (`scenes.<CC>.<lang>.free`); an error message, or null.
  Future<String?> installScenes(String iso) => _install(scenesKey(iso), _l.packScenesFailed, (repo, onProgress) => repo.installScenes(iso, onProgress: onProgress));

  Future<String?> _install(String key, String failed, Future<void> Function(PackRepository repo, void Function(int, int) onProgress) body) async {
    final repo = await ref.read(packRepositoryProvider.future);
    if (repo == null) return _l.packNoDownloads;
    if (repo.manifest == null) await repo.syncManifest();
    state = {...state, key: 0};
    try {
      await body(repo, (n, total) => state = {...state, key: total == 0 ? 0 : n / total});
      ref.read(installedPacksRevisionProvider.notifier).bump();
      return null;
    } on SocketException {
      return _l.packOffline;
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
  final l = l10nFor(ref.read(appLangProvider));
  try {
    final got = await ref.read(storeGatewayProvider).restore();
    final parts = got.length;
    return parts == 0 ? l.restoreNone : l.restoreDone(parts);
  } catch (e) {
    debugPrint('restore: $e');
    return l.restoreFailed;
  }
}
