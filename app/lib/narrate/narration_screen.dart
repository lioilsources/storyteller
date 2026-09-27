import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rag_embed/rag_embed.dart';

import '../cast/cast_member.dart';
import '../motifs/motif.dart';
import '../rag/rag_providers.dart';
import '../rag/rag_store.dart';
import '../story/story_draft.dart';
import 'beat.dart';

const narrationHintKey = Key('narration-hint');
const narrationNextKey = Key('narration-next');
const narrationSituationKey = Key('narration-situation');

/// Which `hint_bank.phase` values serve each beat (RAG_PLAN §2.2 phases).
/// The problem beat covers the climax too — that's where the parent is
/// most likely to get stuck.
const _phasesFor = <StoryBeat, List<String>>{
  StoryBeat.cast: ['intro'],
  StoryBeat.task: ['task'],
  StoryBeat.problem: ['problem', 'climax'],
  StoryBeat.ending: ['ending'],
};

/// STORYTELLER_PLAN.md §1.2, the part of it that can exist without a
/// microphone: the parent tells the story, the app follows along and
/// hands over an open prompt when asked.
///
/// What §1.2 also asks for and this deliberately does *not* do: listen
/// via STT, work out where in the outline the parent is, and offer the
/// hint unprompted after 2.5 s of silence. All three are expensive and
/// none of them answers the question this screen exists to answer —
/// **are the prompts any use at all when you're telling a child a
/// story?** If they aren't, speech recognition would not save them, it
/// would only make them cost more. So: the parent taps.
class NarrationScreen extends ConsumerStatefulWidget {
  const NarrationScreen({super.key});

  @override
  ConsumerState<NarrationScreen> createState() => _NarrationScreenState();
}

class _NarrationScreenState extends ConsumerState<NarrationScreen> {
  int _index = 0;
  List<String> _hints = const [];
  int _shown = 0; // how many of _hints have been revealed

  // RAG mode (lib/rag/): when the osnova came from a pack, "Napověz"
  // retrieves the pack's hints instead of the templates in beat.dart.
  final _situation = TextEditingController();
  List<ScoredHint>? _ragHints; // null = not retrieved for this beat/situation yet
  bool _ragBusy = false;
  bool _ragFallback = false; // retrieval came back empty → templates for this beat
  String? _ragError;

  static const _beats = StoryBeat.values;

  StoryBeat get _beat => _beats[_index];

  @override
  void initState() {
    super.initState();
    _loadHints();
  }

  void _loadHints() {
    _hints = hintsFor(_beat, ref.read(storyDraftProvider).characters);
    _shown = 0;
    _ragHints = null;
    _ragError = null;
    _ragFallback = false;
  }

  @override
  void dispose() {
    _situation.dispose();
    super.dispose();
  }

  /// Pack motif ids in the osnova — what retrieval is allowed to hint
  /// about. Empty means the story was composed from curated cards.
  List<String> _packIds(StoryDraft d) => [for (final m in [d.task, d.problem, d.ending]) if (m?.packMotifId != null) m!.packMotifId!];

  /// What the parent says is happening, or — if they left it empty — the
  /// pack's own Czech sentence for this beat's motif.
  String _query(StoryDraft d) {
    final typed = _situation.text.trim();
    if (typed.isNotEmpty) return typed;
    Motif? m = switch (_beat) { StoryBeat.cast || StoryBeat.task => d.task, StoryBeat.problem => d.problem, StoryBeat.ending => d.ending };
    final who = d.characters.map((c) => c.label).join(', ');
    final what = m?.sentence ?? m?.label ?? '';
    return _beat == StoryBeat.cast ? '$who. $what' : what;
  }

  Future<void> _nudgeRag(RagStore store, StoryDraft d) async {
    if (_ragHints != null) {
      setState(() => _shown++);
      return;
    }
    _ragFallback = false;
    setState(() {
      _ragBusy = true;
      _ragError = null;
    });
    try {
      final embedder = await ref.read(embedderProvider.future);
      if (embedder == null) throw StateError('model pro nápovědy není v téhle sestavě');
      final q = quantizeInt8(await embedder.embed(_query(d), E5Prefix.query));
      final hits = store.hints(phases: _phasesFor[_beat]!, motifIds: _packIds(d), query: q, k: 8);
      if (!mounted) return;
      setState(() {
        _ragHints = hits;
        _shown = hits.isEmpty ? 0 : 1;
        if (hits.isEmpty) {
          // Nothing retrieved (the pipeline hasn't reached these motifs
          // yet): the templates are still better than an empty screen.
          _ragFallback = true;
          _ragError = 'Z balíčku k tomuhle zatím nic — obecná nápověda:';
          _shown = 1;
        }
      });
    } catch (e) {
      if (mounted) setState(() => _ragError = '$e');
    } finally {
      if (mounted) setState(() => _ragBusy = false);
    }
  }

  void _nudge() => setState(() {
        if (_shown < _hints.length) _shown++;
      });

  void _go(int delta) => setState(() {
        _index = (_index + delta).clamp(0, _beats.length - 1);
        _loadHints();
      });

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(storyDraftProvider);

    // Reachable only from a complete osnova, but a back-and-forward
    // through history can land here with a reset draft. Say so instead
    // of rendering four empty beats.
    if (!draft.isComplete) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFFBF2),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: const Color(0xFF3E2723)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tahle pohádka už není složená.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF3E2723), fontSize: 16)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.go('/globe'),
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3E2723)),
                  child: const Text('Složit novou'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final last = _index == _beats.length - 1;
    final store = ref.watch(ragStoreProvider).value;
    final packOsnova = store != null && _packIds(draft).isNotEmpty;
    final rag = packOsnova && !_ragFallback;
    final shownCount = rag ? (_ragHints?.length ?? 0) : _hints.length;
    final canNudge = !_ragBusy && (rag ? (_ragHints == null || _shown < _ragHints!.length) : _shown < _hints.length);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E2723),
        title: Text('Vyprávíš — ${_index + 1} ze ${_beats.length}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _Progress(index: _index, total: _beats.length),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                children: [
                  Text(_beat.title, style: const TextStyle(color: Color(0xFF3E2723), fontWeight: FontWeight.w700, fontSize: 22)),
                  const SizedBox(height: 6),
                  Text(_beat.caption, style: const TextStyle(color: Color(0x993E2723), fontSize: 14, height: 1.35)),
                  const SizedBox(height: 16),
                  _BeatAnchor(beat: _beat, draft: draft),
                  const SizedBox(height: 20),
                  if (packOsnova) ...[
                    TextField(
                      key: narrationSituationKey,
                      controller: _situation,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: (_) => setState(() {
                        _ragHints = null; // new situation → retrieve again on the next tap
                        _ragFallback = false;
                        _ragError = null;
                        _shown = 0;
                      }),
                      decoration: const InputDecoration(
                        labelText: 'Co se zrovna děje? (nepovinné, jde nadiktovat)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_ragError != null) Text(_ragError!, style: TextStyle(color: _ragFallback ? const Color(0x993E2723) : const Color(0xFFB71C1C), fontSize: 13)),
                  if (_shown > 0 && shownCount > 0) ...[
                    const Text(
                      'Nápověda — neříkej ji nahlas, jen se od ní odraz.',
                      style: TextStyle(color: Color(0x993E2723), fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                    if (rag)
                      for (final h in _ragHints!.take(_shown))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _HintCard(text: h.text, meta: '${h.score.toStringAsFixed(2)} · ${h.motifId == null ? 'obecná' : 'k motivu'} · ${h.phase}'),
                        )
                    else
                      for (final hint in _hints.take(_shown))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _HintCard(text: hint),
                        ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2))]),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: narrationHintKey,
                      onPressed: canNudge ? (rag ? () => _nudgeRag(store, draft) : _nudge) : null,
                      icon: _ragBusy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.lightbulb_outline, size: 18),
                      label: Text(_ragBusy ? 'Hledám…' : (_shown == 0 ? 'Napověz' : 'Ještě jednu')),
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF3E2723), side: const BorderSide(color: Color(0x333E2723))),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _index == 0 ? null : () => _go(-1),
                        child: const Text('Zpět'),
                      ),
                      const Spacer(),
                      FilledButton(
                        key: narrationNextKey,
                        onPressed: last ? () => _finish(context) : () => _go(1),
                        style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3E2723)),
                        child: Text(last ? 'Konec' : 'Dál →'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _finish(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFFBF2),
        title: const Text('Dobrou noc.'),
        // Honest about the two things §1.2 promises and this doesn't do:
        // the closing illustration and saving into Knihovna.
        content: const Text(
          'Závěrečný obrázek a ukládání do Knihovny zatím neumíme — '
          'tahle pohádka nikam neodchází, zůstala mezi vámi.',
          style: TextStyle(height: 1.35),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(storyDraftProvider.notifier).reset();
              context.go('/globe');
            },
            child: const Text('Zavřít'),
          ),
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.index, required this.total});
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < total; i++)
            Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
                decoration: BoxDecoration(
                  color: i <= index ? const Color(0xFF8D6E63) : const Color(0x228D6E63),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// What the parent chose for this beat, so they can see where they are
/// without leaving the screen.
class _BeatAnchor extends StatelessWidget {
  const _BeatAnchor({required this.beat, required this.draft});
  final StoryBeat beat;
  final StoryDraft draft;

  @override
  Widget build(BuildContext context) {
    if (beat == StoryBeat.cast) {
      return SizedBox(
        height: 132,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: draft.characters.length,
          separatorBuilder: (context, i) => const SizedBox(width: 10),
          itemBuilder: (context, i) => _Tile.cast(draft.characters[i]),
        ),
      );
    }
    final motif = switch (beat) {
      StoryBeat.task => draft.task,
      StoryBeat.problem => draft.problem,
      StoryBeat.ending => draft.ending,
      StoryBeat.cast => null,
    };
    if (motif == null) return const SizedBox.shrink();
    return _Tile.motif(motif);
  }
}

class _Tile extends StatelessWidget {
  const _Tile._({required this.label, required this.emoji, required this.gradient, required this.imagePath, required this.wide});

  factory _Tile.cast(CastMember c) =>
      _Tile._(label: c.label, emoji: c.emoji, gradient: c.gradient, imagePath: c.imagePath, wide: false);

  factory _Tile.motif(Motif m) =>
      _Tile._(label: m.label, emoji: m.emoji, gradient: m.gradient, imagePath: m.imagePath, wide: true);

  final String label;
  final String emoji;
  final List<Color> gradient;
  final String? imagePath;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: wide ? double.infinity : 100,
        height: 132,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: gradient))),
            if (imagePath == null)
              Center(child: Text(emoji, style: const TextStyle(fontSize: 34)))
            else
              Image.asset(imagePath!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Center(child: Text(emoji, style: const TextStyle(fontSize: 34)))),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
                decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54])),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard({required this.text, this.meta});
  final String text;

  /// Retrieval details for RAG hints (similarity, motif/generic, phase) —
  /// shown while we're judging whether the pack's hints are any good.
  final String? meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x22000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: const TextStyle(color: Color(0xFF3E2723), fontSize: 16, height: 1.35)),
          if (meta != null) ...[
            const SizedBox(height: 4),
            Text(meta!, style: const TextStyle(color: Color(0x993E2723), fontSize: 11)),
          ],
        ],
      ),
    );
  }
}
