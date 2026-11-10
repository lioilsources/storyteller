import 'dart:math';

import '../cast/cast_member.dart';
import '../l10n/l10n.dart';

/// The four beats the parent tells through, in order. They are the same
/// four the osnova confirmed (§4), reused here as the spine of the live
/// telling (§1.2).
enum StoryBeat { cast, task, problem, ending }

extension StoryBeatText on StoryBeat {
  String title(AppLocalizations l) => switch (this) {
        StoryBeat.cast => l.beatCastTitle,
        StoryBeat.task => l.beatTaskTitle,
        StoryBeat.problem => l.beatProblemTitle,
        StoryBeat.ending => l.beatEndingTitle,
      };

  /// What the parent is doing right now — guidance, never a script.
  String caption(AppLocalizations l) => switch (this) {
        StoryBeat.cast => l.beatCastCaption,
        StoryBeat.task => l.beatTaskCaption,
        StoryBeat.problem => l.beatProblemCaption,
        StoryBeat.ending => l.beatEndingCaption,
      };
}

/// Open prompts, one per line, in the spirit of §1.2: a hint "nabízí
/// směr, ne text k přečtení". Every one of these is a question or an
/// unfinished thought the parent answers *in their own words* — none of
/// them is a sentence you could read aloud and have it be the story.
/// That distinction is the whole product: the app never narrates for the
/// parent (§7).
///
/// `{who}` is replaced with one of the cast the parent actually
/// picked, which is the cheapest way to make a generic prompt feel like
/// it belongs to this story. It comes with **two hard rules**, both
/// learned by reading a rendered screen in Czech and kept in every
/// language:
///
/// 1. **`{who}` may only stand in the nominative, as the subject.**
///    The labels are descriptive phrases from the corpus ("Král se
///    strašidelným hradem"), not names, and nothing here declines them.
///    "Podle čeho bys *Král se strašidelným hradem* poznal?" is wrong
///    Czech; it needs the accusative "Krále", which we cannot produce.
///    So the prompt gets rephrased until the name is the subject.
/// 2. **No pronoun may refer to the character.** "Kdo *jí* to poradil?"
///    silently assumes a feminine character, and half the cast is not.
///    Where a pronoun is tempting, drop it.
///
/// A declension library would lift rule 1, and grammatical gender stored
/// per cast member would lift rule 2. Neither exists yet, and the
/// rephrased prompts read fine, so neither is urgent.
typedef _Hint = String Function(AppLocalizations l, String who);

final _hints = <StoryBeat, List<_Hint>>{
  StoryBeat.cast: [
    (l, w) => l.hintCast1(w),
    (l, w) => l.hintCast2(w),
    (l, w) => l.hintCast3(w),
    (l, w) => l.hintCast4(w),
    (l, w) => l.hintCast5,
    (l, w) => l.hintCast6,
    (l, w) => l.hintCast7(w),
  ],
  StoryBeat.task: [
    (l, w) => l.hintTask1(w),
    (l, w) => l.hintTask2(w),
    (l, w) => l.hintTask3(w),
    (l, w) => l.hintTask4,
    (l, w) => l.hintTask5(w),
    (l, w) => l.hintTask6,
  ],
  StoryBeat.problem: [
    (l, w) => l.hintProblem1,
    (l, w) => l.hintProblem2,
    (l, w) => l.hintProblem3(w),
    (l, w) => l.hintProblem4,
    (l, w) => l.hintProblem5,
    (l, w) => l.hintProblem6,
    (l, w) => l.hintProblem7(w),
  ],
  StoryBeat.ending: [
    (l, w) => l.hintEnding1(w),
    (l, w) => l.hintEnding2,
    (l, w) => l.hintEnding3(w),
    (l, w) => l.hintEnding4,
    (l, w) => l.hintEnding5(w),
    (l, w) => l.hintEnding6,
  ],
};

/// The templates for [beat] with the character name left as `{postava}`.
/// Exposed so tests can check the two rules above against the template
/// rather than against a rendered string, where the name would hide them.
List<String> rawHints(StoryBeat beat, AppLocalizations l) => [for (final h in _hints[beat]!) h(l, '{postava}')];

/// Hints for [beat], shuffled, with `{postava}` filled from [cast].
///
/// The shuffle is per call, so tapping "Napověz" walks a fresh order
/// every telling — the same four beats should not produce the same
/// bedtime twice.
List<String> hintsFor(StoryBeat beat, List<CastMember> cast, AppLocalizations l, {Random? rng}) {
  final r = rng ?? Random();
  final pool = List<_Hint>.of(_hints[beat]!)..shuffle(r);
  if (cast.isEmpty) {
    // Nothing to name: fall back to a neutral word rather than printing
    // the placeholder at a parent mid-story.
    return [for (final h in pool) h(l, l.hintHero)];
  }
  return [
    for (final h in pool) h(l, castLabel(l, cast[r.nextInt(cast.length)])),
  ];
}
