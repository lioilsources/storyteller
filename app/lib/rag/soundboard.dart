import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../narrate/beat.dart';
import '../story/story_draft.dart';
import 'rag_store.dart';

/// What the Suflér offers to play for the current osnova and beat: one
/// background loop for the beat's setting and mood, and buttons — first
/// the sound of each character in the cast and the sounds the beat's plot
/// calls for (the pipeline picked those per motif, `motif_sounds`), then
/// the creatures and actions the motifs' tags match (rag/audio/catalog.json).
/// Nothing here speaks — the parent tells the story, the app only adds
/// atmosphere when the parent asks for it.
class SoundboardPick {
  const SoundboardPick({this.music, this.effects = const []});
  final PackSound? music;
  final List<PackSound> effects;
}

/// Motif environments the catalog has no loop of its own for, mapped to the
/// nearest one it has.
const _envAlias = {
  'lake': 'river', 'well': 'river', 'meadow': 'field', 'pasture': 'field', 'steppe': 'field', 'desert': 'field',
  'mill': 'village', 'market': 'town', 'earth': 'forest', 'castle': 'palace', 'cave': 'underground',
};

SoundboardPick pickSounds(RagStore store, StoryDraft d, StoryBeat beat, {int maxEffects = 10}) {
  final all = store.sounds();
  if (all.isEmpty) return const SoundboardPick();
  final ids = [for (final m in [d.task, d.problem, d.ending]) if (m?.packMotifId != null) m!.packMotifId!];
  final tags = store.motifTags(ids);
  final creatures = store.motifCreatures(ids);

  // The beat's own motif sets the scene; its first environment picks the loop.
  final beatMotif = switch (beat) { StoryBeat.cast || StoryBeat.task => d.task, StoryBeat.problem => d.problem, StoryBeat.ending => d.ending };
  final envs = beatMotif?.packMotifId == null ? <String>{} : store.motifTags([beatMotif!.packMotifId!]);
  final mood = beat == StoryBeat.problem ? 'tense' : 'calm';
  PackSound? music;
  for (final e in [...envs, ...tags]) {
    final key = _envAlias[e] ?? e;
    music = all.where((s) => s.kind == 'music' && s.key == key && s.mood == mood).firstOrNull;
    if (music != null) break;
  }

  // Picked per motif by the pipeline: a character's sound carries the
  // character's name (the parent looks for "Chytrá liška", not "Liška");
  // the beat's own cues come before those of the other two motifs.
  final byId = {for (final s in all) s.id: s};
  final cast = {for (final ch in d.characters) if (ch.packMotifId != null) ch.packMotifId!: ch.label};
  final beatId = beatMotif?.packMotifId;
  final picked = store.motifSounds([...cast.keys, ...ids]);
  final effects = <PackSound>[
    for (final p in picked)
      if (p.role == 'character' && cast.containsKey(p.motifId))
        if (byId[p.soundId] case final s?) PackSound(id: s.id, kind: s.kind, key: s.key, label: cast[p.motifId]!, mood: s.mood, match: s.match),
    for (final own in [true, false])
      for (final p in picked)
        if (p.role == 'cue' && (p.motifId == beatId) == own)
          if (byId[p.soundId] case final s? when s.kind != 'music') s,
    ...all.where((s) => s.kind == 'creature' && s.match.intersection(creatures).isNotEmpty),
    ...all.where((s) => s.kind == 'action' && s.match.intersection(tags).isNotEmpty),
  ];
  if (effects.length < 4) {
    effects.addAll(all.where((s) => s.kind == 'action' && ['magic', 'trick', 'steps-forest', 'door'].contains(s.key)));
  }
  // One button per sound: the first mention wins (a character's name over
  // the creature's, a cue over a tag match).
  final seen = <String>{};
  return SoundboardPick(music: music, effects: effects.where((s) => seen.add(s.id)).take(maxEffects).toList());
}

/// Two channels: a quiet looping bed and one-shot effects over it. Sounds
/// are unpacked from the pack to files once — just_audio plays files.
class SoundPlayer {
  SoundPlayer(this._store);

  final RagStore _store;
  final _bed = AudioPlayer();
  final _fx = AudioPlayer();
  String? playingBed;

  Future<String?> _file(String id) async {
    final dir = Directory('${(await getTemporaryDirectory()).path}/sounds')..createSync(recursive: true);
    final f = File('${dir.path}/$id.m4a');
    if (!f.existsSync()) {
      final b = _store.soundBytes(id);
      if (b == null) return null;
      f.writeAsBytesSync(b, flush: true);
    }
    return f.path;
  }

  Future<void> toggleBed(PackSound music) async {
    if (playingBed == music.id) {
      await _bed.stop();
      playingBed = null;
      return;
    }
    final path = await _file(music.id);
    if (path == null) return;
    playingBed = music.id;
    await _bed.setFilePath(path);
    await _bed.setLoopMode(LoopMode.one);
    await _bed.setVolume(0.35);
    await _bed.play();
  }

  Future<void> stopBed() async {
    playingBed = null;
    await _bed.stop();
  }

  Future<void> playEffect(PackSound s) async {
    final path = await _file(s.id);
    if (path == null) return;
    await _fx.setFilePath(path);
    await _fx.seek(Duration.zero);
    await _fx.play();
  }

  Future<void> dispose() async {
    await _bed.dispose();
    await _fx.dispose();
  }
}
