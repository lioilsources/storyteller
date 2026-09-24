import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../cast/cast_member.dart';
import '../motifs/motif.dart';
import 'story_draft.dart';

/// STORYTELLER_PLAN.md §4: "Osnova (potvrzení)" — the 4-point outline
/// (cast + task + problem + ending) confirmed before "Vyprávím" (live
/// narration, not built yet). Characters show real art
/// (app/assets/cast/); task/problem/ending are still the hand-written
/// mock motifs from lib/motifs/motif.dart — real art for those waits on
/// the RAG pass over the fetched corpus (see the session's own plan).
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
                      ref.read(storyDraftProvider.notifier).reset();
                      context.go('/cast');
                    },
                    child: const Text('Znovu'),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: draft.isComplete
                        ? () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Vyprávění (živé) ještě není hotové — přichází příště.')),
                            )
                        : null,
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
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(gradient: LinearGradient(colors: motif.gradient), borderRadius: BorderRadius.circular(14)),
            child: Text(motif.emoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(motif.label, style: const TextStyle(color: Color(0xFF3E2723), fontSize: 15))),
        ],
      ),
    );
  }
}
