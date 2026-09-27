import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../cast/cast_member.dart';
import '../motifs/motif.dart';
import 'story_draft.dart';

/// STORYTELLER_PLAN.md §4: "Osnova (potvrzení)" — the 4-point outline
/// (cast + task + problem + ending) confirmed before "Vyprávím", which
/// now leads into the prompter (`narrate/narration_screen.dart`) rather
/// than an apology. All four sections show real art from the corpus.
class OsnovaScreen extends ConsumerWidget {
  const OsnovaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(storyDraftProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E2723),
        title: const Text('Osnova'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _Section(title: 'Postavy', child: _CharacterRow(characters: draft.characters)),
                  if (draft.task != null) _Section(title: 'Úkol', child: _MotifRow(motif: draft.task!)),
                  if (draft.problem != null) _Section(title: 'Problém', child: _MotifRow(motif: draft.problem!)),
                  if (draft.ending != null) _Section(title: 'Konec', child: _MotifRow(motif: draft.ending!)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2))]),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      // Back to the globe, not to the cast: reset() drops
                      // the country too, and an unfiltered cast screen
                      // would quietly break the promise the globe made.
                      ref.read(storyDraftProvider.notifier).reset();
                      context.go('/globe');
                    },
                    child: const Text('Znovu'),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: draft.isComplete ? () => context.go('/vypravim') : null,
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3E2723)),
                    child: const Text('Vyprávím →'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(title, style: const TextStyle(color: Color(0xFF3E2723), fontWeight: FontWeight.w700, fontSize: 15)),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _CharacterRow extends StatelessWidget {
  const _CharacterRow({required this.characters});
  final List<CastMember> characters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: characters.length,
        separatorBuilder: (context, i) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final c = characters[i];
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 84,
              height: 108,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: c.gradient))),
                  Image.asset(c.imagePath, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Center(child: Text(c.emoji, style: const TextStyle(fontSize: 28)))),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.black45,
                      child: Text(c.label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MotifRow extends StatelessWidget {
  const _MotifRow({required this.motif});
  final Motif motif;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: motif.gradient))),
                  if (motif.imagePath == null)
                    Center(child: Text(motif.emoji, style: const TextStyle(fontSize: 26)))
                  else
                    Image.asset(motif.imagePath!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Center(child: Text(motif.emoji, style: const TextStyle(fontSize: 26)))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(motif.label, style: const TextStyle(color: Color(0xFF3E2723), fontSize: 15))),
        ],
      ),
    );
  }
}
