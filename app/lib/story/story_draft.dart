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
  const StoryDraft({this.characters = const [], this.task, this.problem, this.ending, this.countryIso, this.countryName});

  final List<CastMember> characters;
  final Motif? task;
  final Motif? problem;
  final Motif? ending;

  /// Set by the globe (§1.1b). When present, every picker downstream
  /// offers only motifs from this tradition; when null the child is in
  /// free play and sees everything.
  final String? countryIso;
  final String? countryName;

  bool get isComplete => characters.isNotEmpty && task != null && problem != null && ending != null;

  StoryDraft copyWith({List<CastMember>? characters, Motif? task, Motif? problem, Motif? ending, String? countryIso, String? countryName}) => StoryDraft(
        characters: characters ?? this.characters,
        task: task ?? this.task,
        problem: problem ?? this.problem,
        ending: ending ?? this.ending,
        countryIso: countryIso ?? this.countryIso,
        countryName: countryName ?? this.countryName,
      );
}

class StoryDraftController extends Notifier<StoryDraft> {
  @override
  StoryDraft build() => const StoryDraft();

  void setCharacters(List<CastMember> characters) => state = state.copyWith(characters: characters);

  /// One entry point for all three picker steps, so a new category can't
  /// be routed without being stored.
  void setMotif(MotifCategory category, Motif m) {
    state = switch (category) {
      MotifCategory.task => state.copyWith(task: m),
      MotifCategory.problem => state.copyWith(problem: m),
      MotifCategory.ending => state.copyWith(ending: m),
    };
  }
  /// Picking a country restarts the story: the cast and motifs chosen
  /// under a previous country don't belong to this one.
  void setCountry(String iso, String name) => state = StoryDraft(countryIso: iso, countryName: name);

  void reset() => state = const StoryDraft();
}

final storyDraftProvider = NotifierProvider<StoryDraftController, StoryDraft>(StoryDraftController.new);
