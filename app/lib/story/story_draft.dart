import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cast/cast_member.dart';
import '../motifs/motif.dart';

/// The osnova (outline) being assembled across screens: cast (§1.1a,
/// variable 1-6) + one task + one problem + one ending (always
/// singular). Accumulated by CastComposerScreen → the three
/// MotifPickerScreens → read by OsnovaScreen. Lives in Riverpod, not
/// go_router `extra`, so a screen can be popped back to and re-entered
/// without losing what came before it.
@immutable
class StoryDraft {
  const StoryDraft({this.characters = const [], this.task, this.problem, this.ending});

  final List<CastMember> characters;
  final Motif? task;
  final Motif? problem;
  final Motif? ending;

  bool get isComplete => characters.isNotEmpty && task != null && problem != null && ending != null;

  StoryDraft copyWith({List<CastMember>? characters, Motif? task, Motif? problem, Motif? ending}) => StoryDraft(
        characters: characters ?? this.characters,
        task: task ?? this.task,
        problem: problem ?? this.problem,
        ending: ending ?? this.ending,
      );
}

class StoryDraftController extends Notifier<StoryDraft> {
  @override
  StoryDraft build() => const StoryDraft();

  void setCharacters(List<CastMember> characters) => state = state.copyWith(characters: characters);
  void setTask(Motif m) => state = state.copyWith(task: m);
  void setProblem(Motif m) => state = state.copyWith(problem: m);
  void setEnding(Motif m) => state = state.copyWith(ending: m);
  void reset() => state = const StoryDraft();
}

final storyDraftProvider = NotifierProvider<StoryDraftController, StoryDraft>(StoryDraftController.new);
