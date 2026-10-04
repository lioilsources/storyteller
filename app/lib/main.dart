import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'cast/cast_composer_screen.dart';
import 'globe/globe_screen.dart';
import 'motifs/motif.dart';
import 'motifs/motif_picker_screen.dart';
import 'narrate/narration_screen.dart';
import 'rag/rag_providers.dart';
import 'story/osnova_screen.dart';
import 'story/story_draft.dart';
import 'theme/kid_text.dart';

void main() {
  runApp(const ProviderScope(child: StorytellerApp()));
}

/// The story-assembly flow (STORYTELLER_PLAN.md §1.1/§1.1a/§4): cast →
/// task → problem → ending → osnova. Each picker writes its choice into
/// [storyDraftProvider] (not go_router `extra`) before advancing, so
/// popping back to an earlier screen doesn't lose what came after it.
GoRouter _buildRouter() => GoRouter(
      initialLocation: '/globe',
      routes: [
        GoRoute(path: '/globe', builder: (context, state) => const GlobeScreen()),
        GoRoute(path: '/cast', builder: (context, state) => const CastComposerScreen()),
        _motifRoute(path: '/task', category: MotifCategory.task, next: '/problem'),
        _motifRoute(path: '/problem', category: MotifCategory.problem, next: '/ending'),
        _motifRoute(path: '/ending', category: MotifCategory.ending, next: '/osnova'),
        GoRoute(path: '/osnova', builder: (context, state) => const OsnovaScreen()),
        GoRoute(path: '/vypravim', builder: (context, state) => const NarrationScreen()),
      ],
    );

/// The three picker steps differ only in category and where they go
/// next. They're built from one place because they must agree on
/// everything else — notably [StoryDraft.countryIso]: the globe's filter
/// silently did nothing for a while because it was wired into the screen
/// but into none of the three route builders.
GoRoute _motifRoute({required String path, required MotifCategory category, required String next}) => GoRoute(
      path: path,
      builder: (context, state) => Consumer(
        builder: (context, ref, _) {
          final iso = ref.watch(storyDraftProvider).countryIso;
          // Pack motifs (lib/rag/) for this country, once the packs have
          // loaded; until then — and in widget tests, where they never
          // load — the curated pool, with no spinner in between.
          final store = ref.watch(ragStoreProvider).value;
          final all = store?.motifs(category.packType, country: iso) ?? const [];
          // While the pipeline runs, few motifs have hints yet: offer those
          // first so the Suflér has something to retrieve. Endings never
          // get hints of their own (spoilers), so they're offered as-is.
          final hinted = [for (final m in all) if (m.hintCount > 0) m];
          final offered = category == MotifCategory.ending || hinted.length < 3 ? all : hinted;
          final pack = store == null ? null : [for (final m in offered) Motif.fromPack(m)];
          return MotifPickerScreen(
            category: category,
            countryIso: iso,
            packPool: pack,
            onSelected: (m) {
              ref.read(storyDraftProvider.notifier).setMotif(category, m);
              context.go(next);
            },
          );
        },
      ),
    );

class StorytellerApp extends StatefulWidget {
  const StorytellerApp({super.key});

  @override
  State<StorytellerApp> createState() => _StorytellerAppState();
}

class _StorytellerAppState extends State<StorytellerApp> {
  // Built once per StorytellerApp *element*, not as a module-level
  // singleton: a top-level `final router = GoRouter(...)` would survive
  // across separate pumpWidget(StorytellerApp()) calls in different
  // tests (same Dart isolate, so the top-level var is only initialized
  // once), leaking one test's navigation (e.g. ending up on /osnova)
  // into the next test's fresh widget tree, which still expects to
  // start at /cast. In production there's exactly one StorytellerApp
  // element for the app's lifetime, so this is still built exactly once.
  late final GoRouter _router = _buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vyprávěj',
      debugShowCheckedModeBanner: false,
      // Dětská typografie CuteKidFonts (lib/theme/kid_text.dart): Material
      // téma v Baloo 2, KidTheme nad navigátorem, aby ho viděly i dialogy.
      theme: storyThemeData(),
      builder: (context, child) => KidTheme(data: storyKidTheme, child: child!),
      routerConfig: _router,
    );
  }
}
