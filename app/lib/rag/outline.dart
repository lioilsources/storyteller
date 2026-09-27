import 'package:flutter/foundation.dart';

import '../story/story_draft.dart';
import 'rag_store.dart';

/// One paragraph of the composed outline: a bridge phrase from the pack's
/// `transitions` (null for the opening) and the beat itself.
@immutable
class OutlineLine {
  const OutlineLine({required this.beat, this.bridge, required this.text});

  final String beat; // character | task | problem | ending
  final String? bridge;
  final String text;
}

/// RAG_PLAN §3 "Osnova: compose(outline_template, verbalizations[selected],
/// transitions by tags)" — the 4-beat template, the pack's Czech sentences
/// for the picked motifs, bridged by transitions that share the most tags
/// with them. Null when the osnova wasn't composed from pack motifs.
///
/// Which of the best-matching phrases is used is fixed per osnova (hash of
/// the motif ids), so the text doesn't reshuffle on every rebuild.
List<OutlineLine>? composeOutline(RagStore store, StoryDraft d) {
  final task = d.task, problem = d.problem, ending = d.ending;
  final ids = [for (final m in [task, problem, ending]) if (m?.packMotifId != null) m!.packMotifId!];
  if (ids.isEmpty || task == null || problem == null || ending == null) return null;
  final tags = store.motifTags(ids);
  final seed = ids.join('|').codeUnits.fold<int>(0, (a, c) => (a * 31 + c) & 0x7fffffff);

  String? bridge(String from, String to) {
    // only among the phrases tied for the best tag overlap — a phrase about
    // the sea shouldn't bridge into a forest just because it came up third
    final options = store.transitions(from, to, tags: tags, bestOnly: true);
    if (options.isEmpty) return null;
    return options[(seed + from.length * 7 + to.length) % options.length];
  }

  final who = d.characters.map((c) => c.label).join(', ');
  return [
    OutlineLine(beat: 'character', text: who.isEmpty ? 'Hrdina' : who),
    OutlineLine(beat: 'task', bridge: bridge('character', 'task'), text: task.sentence ?? task.label),
    OutlineLine(beat: 'problem', bridge: bridge('task', 'problem'), text: problem.sentence ?? problem.label),
    OutlineLine(beat: 'ending', bridge: bridge('problem', 'ending'), text: ending.sentence ?? ending.label),
  ];
}
