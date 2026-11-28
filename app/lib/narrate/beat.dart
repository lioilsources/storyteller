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
/// `{postava}` is replaced with one of the cast the parent actually
/// picked, which is the cheapest way to make a generic prompt feel like
/// it belongs to this story. It comes with **two hard rules about
/// Czech**, both learned by reading a rendered screen:
///
/// 1. **`{postava}` may only stand in the nominative, as the subject.**
///    The labels are descriptive phrases from the corpus ("Král se
///    strašidelným hradem"), not names, and nothing here declines them.
///    "Podle čeho bys *Král se strašidelným hradem* poznal?" is wrong
///    Czech; it needs the accusative "Krále", which we cannot produce.
///    So the prompt gets rephrased until the name is the subject.
/// 2. **No pronoun may refer to the character.** "Kdo *jí* to poradil?"
///    silently assumes a feminine character, and half the cast is not.
///    Where a pronoun is tempting, drop it — Czech allows it.
///
/// A declension library would lift rule 1, and grammatical gender stored
/// per cast member would lift rule 2. Neither exists yet, and the
/// rephrased prompts read fine, so neither is urgent.
const _hints = <StoryBeat, List<String>>{
  StoryBeat.cast: [
    'Jak {postava} vypadá, když se poprvé objeví?',
    'Co {postava} zrovna dělá, než celý příběh začne?',
    'Čeho se {postava} bojí?',
    'Podle čeho poznáš, že přichází {postava}?',
    'Kdo z nich se zná už dlouho a odkud?',
    'Jaké je počasí, když se potkají?',
    'Co má {postava} v kapse?',
  ],
  StoryBeat.task: [
    'Kdy {postava} pochopí, že se do toho musí pustit?',
    'Kdo to poradil a proč {postava} poslechne?',
    'Co musí {postava} nechat doma?',
    'Jak dlouhá je ta cesta a přes co vede?',
    'Co si {postava} slíbí, než vyrazí?',
    'Proč to nemůže udělat někdo jiný?',
  ],
  StoryBeat.problem: [
    'V tu chvíli se ozve zvuk — jaký?',
    'Co se pokazí jako první?',
    'Co {postava} zkusí nejdřív a proč to nevyjde?',
    'Kdo odmítne pomoct, i když by mohl?',
    'Co by se stalo, kdyby to teď všichni vzdali?',
    'Je na té překážce něco smutného?',
    'Co {postava} v tu chvíli řekne nahlas?',
  ],
  StoryBeat.ending: [
    'Čím to {postava} nakonec zlomí — silou, nebo nápadem?',
    'Kdo pomůže, i když by nemusel?',
    'Co {postava} udělá jako úplně první, když je po všem?',
    'Co je na konci jinak než na začátku?',
    'Kam se {postava} vrátí a kdo tam čeká?',
    'Jaká je poslední věta, než se rozsvítí?',
  ],
};

/// The same prompts in English. `{postava}` follows the same two rules:
/// the character is always the subject, and no pronoun refers to them
/// (English would need "he"/"she" where Czech just drops it).
const _hintsEn = <StoryBeat, List<String>>{
  StoryBeat.cast: [
    'What does {postava} look like on first appearing?',
    'What is {postava} doing just before the whole story begins?',
    'What is {postava} afraid of?',
    'How can you tell that {postava} is coming?',
    'Which of them have known each other for a long time, and from where?',
    'What is the weather like when they meet?',
    'What does {postava} have in a pocket?',
  ],
  StoryBeat.task: [
    'When does {postava} realise there is no way around it?',
    'Who gave the advice, and why does {postava} listen?',
    'What does {postava} have to leave at home?',
    'How long is the journey and what does it cross?',
    'What does {postava} promise before setting off?',
    'Why can\'t somebody else do it?',
  ],
  StoryBeat.problem: [
    'Right then a sound is heard — what sound?',
    'What goes wrong first?',
    'What does {postava} try first, and why doesn\'t it work?',
    'Who refuses to help, even though they could?',
    'What would happen if everyone gave up now?',
    'Is there something sad about this obstacle?',
    'What does {postava} say out loud at that moment?',
  ],
  StoryBeat.ending: [
    'How does {postava} finally break it — by strength or by a clever idea?',
    'Who helps, even without having to?',
    'What is the very first thing {postava} does once it is all over?',
    'What is different at the end compared with the beginning?',
    'Where does {postava} go back to, and who is waiting there?',
    'What is the last sentence before the lights go out?',
  ],
};

Map<StoryBeat, List<String>> _hintsIn(String lang) => lang == 'cs' ? _hints : _hintsEn;

/// The raw templates for [beat], `{postava}` unfilled. Exposed so tests
/// can check the two Czech rules above against the template rather than
/// against a rendered string, where the name would hide them.
List<String> rawHints(StoryBeat beat, {String lang = 'cs'}) => List.unmodifiable(_hintsIn(lang)[beat]!);

/// Hints for [beat], shuffled, with `{postava}` filled from [cast].
///
/// The shuffle is per call, so tapping "Napověz" walks a fresh order
/// every telling — the same four beats should not produce the same
/// bedtime twice.
List<String> hintsFor(StoryBeat beat, List<CastMember> cast, {Random? rng, String lang = 'cs'}) {
  final r = rng ?? Random();
  final pool = List<String>.of(_hintsIn(lang)[beat]!)..shuffle(r);
  if (cast.isEmpty) {
    // Nothing to name: fall back to a neutral word rather than printing
    // the placeholder at a parent mid-story.
    return [for (final h in pool) h.replaceAll('{postava}', lang == 'cs' ? 'hrdina' : 'the hero')];
  }
  return [
    for (final h in pool) h.replaceAll('{postava}', cast[r.nextInt(cast.length)].label),
  ];
}
