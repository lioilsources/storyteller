import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'cast/cast_composer_screen.dart';
import 'motifs/motif.dart';
import 'motifs/motif_picker_screen.dart';
import 'story/osnova_screen.dart';
import 'story/story_draft.dart';

void main() {
  runApp(const ProviderScope(child: StorytellerApp()));
}

/// The story-assembly flow (STORYTELLER_PLAN.md §1.1/§1.1a/§4): cast →
/// task → problem → ending → osnova. Each picker writes its choice into
/// [storyDraftProvider] (not go_router `extra`) before advancing, so
/// popping back to an earlier screen doesn't lose what came after it.
GoRouter _buildRouter() => GoRouter(
      initialLocation: '/cast',
      routes: [
        GoRoute(path: '/cast', builder: (context, state) => const CastComposerScreen()),
        GoRoute(
          path: '/task',
          builder: (context, state) => Consumer(
            builder: (context, ref, _) => MotifPickerScreen(
              category: MotifCategory.task,
              onSelected: (m) {
                ref.read(storyDraftProvider.notifier).setTask(m);
                context.go('/problem');
              },
            ),
          ),
        ),
        GoRoute(
          path: '/problem',
          builder: (context, state) => Consumer(
            builder: (context, ref, _) => MotifPickerScreen(
              category: MotifCategory.problem,
              onSelected: (m) {
                ref.read(storyDraftProvider.notifier).setProblem(m);
                context.go('/ending');
              },
            ),
          ),
        ),
        GoRoute(
          path: '/ending',
          builder: (context, state) => Consumer(
            builder: (context, ref, _) => MotifPickerScreen(
              category: MotifCategory.ending,
              onSelected: (m) {
                ref.read(storyDraftProvider.notifier).setEnding(m);
                context.go('/osnova');
              },
            ),
          ),
        ),
        GoRoute(path: '/osnova', builder: (context, state) => const OsnovaScreen()),
      ],
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
      theme: ThemeData(colorSchemeSeed: const Color(0xFF8D6E63), useMaterial3: true, fontFamily: 'Roboto'),
      routerConfig: _router,
    );
  }
}
