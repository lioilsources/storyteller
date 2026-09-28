import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../packs/pack_providers.dart';
import 'embedder.dart';
import 'rag_store.dart';

/// The bundled packs plus the downloaded ones (lib/packs/), or null when there are none / they can't be opened —
/// every caller then falls back to the hand-curated content, so a build
/// without packs behaves exactly like the app did before RAG.
///
/// Widget tests never resolve this (asset I/O doesn't complete inside
/// `testWidgets`, see app/README.md), which is why screens read it with
/// `.value` and never show a spinner for it.
final ragStoreProvider = FutureProvider<RagStore?>((ref) async {
  ref.watch(installedPacksRevisionProvider);
  final repo = await ref.watch(packRepositoryProvider.future);
  try {
    final store = await RagStore.openBundled(extra: repo?.dbPaths() ?? const []);
    ref.onDispose(store.close);
    return store;
  } catch (e) {
    debugPrint('RAG packs unavailable: $e');
    return null;
  }
});

/// Pack motifs with a Czech title, per country — added to the globe's
/// coverage so a country the packs can serve (CZ first) becomes pickable.
final packMotifCountsProvider = Provider<Map<String, int>>((ref) => ref.watch(ragStoreProvider).value?.titledMotifCounts() ?? const {});

/// The on-device e5 model, loaded on first use (~5 s). Null when the model
/// isn't bundled (e.g. a CI build without the release asset).
final embedderProvider = FutureProvider<Embedder?>((ref) async {
  try {
    final e = await Embedder.load();
    ref.onDispose(e.close);
    return e;
  } catch (e) {
    debugPrint('Embedder unavailable: $e');
    return null;
  }
});
