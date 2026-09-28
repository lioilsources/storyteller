import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../rag/rag_store.dart';

/// One candidate for a cast slot. In the real app this wraps a
/// corpus_motifs row (type == character) plus its resolved tier-0 asset
/// (MODELS_PLAN §1) — `imagePath` is exactly that: a real flux-schnell
/// render (`internal/nimqueue`, watercolor style), not a placeholder.
/// See STORYTELLER_PLAN.md §1.1a.
@immutable
class CastMember {
  const CastMember({required this.id, required this.label, required this.emoji, required this.gradient, required this.imagePath, this.country, this.packMotifId, this.imageBytes});

  /// A character from a RAG pack (lib/rag/): the Czech title
  /// `rag.verbalize` wrote, the flux-schnell card from `motif_images`.
  factory CastMember.fromPack(PackMotif m) {
    const palettes = <List<Color>>[
      [Color(0xFF8D6E63), Color(0xFFBCAAA4)], [Color(0xFF5C6BC0), Color(0xFF9FA8DA)], [Color(0xFF26A69A), Color(0xFF80CBC4)],
      [Color(0xFFEF6C00), Color(0xFFFFB74D)], [Color(0xFF8E24AA), Color(0xFFCE93D8)], [Color(0xFF43A047), Color(0xFFA5D6A7)],
    ];
    final h = m.id.codeUnits.fold<int>(0, (a, c) => (a * 31 + c) & 0x7fffffff);
    return CastMember(id: 'pack:${m.id}', label: m.title, emoji: '🧚', gradient: palettes[h % palettes.length], imagePath: null, country: m.country, packMotifId: m.id, imageBytes: m.jpeg);
  }

  final String id;
  final String label;
  final String emoji;
  final List<Color> gradient; // fallback while imagePath loads / if it's ever missing
  final String? imagePath; // null for pack characters, which carry imageBytes instead

  /// Set for pack characters — the `motifs` id the Suflér's retrieval uses.
  final String? packMotifId;

  /// Card art carried by the pack (`motif_images`); wins over [imagePath].
  final Uint8List? imageBytes;

  /// ISO 3166-1 alpha-2 of the tradition this character came from, or
  /// null for the hand-invented scaffolding entries that predate the
  /// corpus. The globe (§1.1b) filters on this; a null-country member
  /// only appears in free play, when no country is picked.
  final String? country;
}

/// Flavor mirrors gateway/internal/offer/seed.go's seedCharacters.
/// `imagePath` files are real renders — generated 2026-09-24 via
/// internal/nimqueue against the live flux-schnell NIM container on
/// Spark (watercolor style, ~2-6s each), not drawn or stock art. See
/// the session's own notes for the exact prompts; one honest finding
/// from generating these: "four princesses" rendered only 3 —
/// diffusion models are unreliable at exact character counts, worth
/// remembering once the real cast-count feature (§1.1a) drives prompts.
const mockCastPool = <CastMember>[
  CastMember(id: 'fox', label: 'Chytrá liška', emoji: '🦊', gradient: [Color(0xFFFF8A65), Color(0xFFFFAB91)], imagePath: 'assets/cast/fox.jpg'),
  CastMember(id: 'smith-son', label: 'Kovářův syn', emoji: '🔨', gradient: [Color(0xFF8D6E63), Color(0xFFBCAAA4)], imagePath: 'assets/cast/smith-son.jpg'),
  CastMember(id: 'mill', label: 'Mluvící mlýn', emoji: '🌾', gradient: [Color(0xFFD4B483), Color(0xFFE8D3A2)], imagePath: 'assets/cast/mill.jpg'),
  CastMember(id: 'goose-girl', label: 'Husopaska', emoji: '🪿', gradient: [Color(0xFF81C784), Color(0xFFAED581)], imagePath: 'assets/cast/goose-girl.jpg'),
  CastMember(id: 'brothers', label: 'Tři bratři', emoji: '👦', gradient: [Color(0xFF64B5F6), Color(0xFF90CAF9)], imagePath: 'assets/cast/brothers.jpg'),
  CastMember(id: 'clockwork-princess', label: 'Princezna hodinářka', emoji: '⏰', gradient: [Color(0xFFBA68C8), Color(0xFFCE93D8)], imagePath: 'assets/cast/clockwork-princess.jpg'),
  CastMember(id: 'owl', label: 'Moudrá sova', emoji: '🦉', gradient: [Color(0xFF5C6BC0), Color(0xFF7986CB)], imagePath: 'assets/cast/owl.jpg'),
  CastMember(id: 'blacksmith', label: 'Stará kovářka', emoji: '⚒️', gradient: [Color(0xFF78909C), Color(0xFF90A4AE)], imagePath: 'assets/cast/blacksmith.jpg'),
  CastMember(id: 'dragon', label: 'Malý drak', emoji: '🐉', gradient: [Color(0xFF4DB6AC), Color(0xFF80CBC4)], imagePath: 'assets/cast/dragon.jpg'),
  CastMember(id: 'water-sprite', label: 'Vodník', emoji: '💧', gradient: [Color(0xFF4FC3F7), Color(0xFF81D4FA)], imagePath: 'assets/cast/water-sprite.jpg'),
  CastMember(id: 'four-princesses', label: 'Čtyři princezny', emoji: '👑', gradient: [Color(0xFFF06292), Color(0xFFF48FB1)], imagePath: 'assets/cast/four-princesses.jpg'),
  CastMember(id: 'traveling-tailor', label: 'Potulný krejčí', emoji: '🧵', gradient: [Color(0xFFFFB74D), Color(0xFFFFCC80)], imagePath: 'assets/cast/traveling-tailor.jpg'),
  CastMember(id: 'talking-cat', label: 'Mluvící kocour', emoji: '🐱', gradient: [Color(0xFF9575CD), Color(0xFFB39DDB)], imagePath: 'assets/cast/talking-cat.jpg'),
  CastMember(id: 'forest-hermit', label: 'Lesní poustevník', emoji: '🌲', gradient: [Color(0xFF66BB6A), Color(0xFF9CCC65)], imagePath: 'assets/cast/forest-hermit.jpg'),

  // --- Real motifs rag.extract found in the corpus (2026-09-25),
  // country-tagged so the globe (§1.1b) can filter on them. Art is
  // flux-schnell, prompt = the extracted English motif text; Czech
  // labels hand-translated (no LLM was reachable at the time).
  CastMember(id: 'c0-andersen-the-shadow', label: 'Pán, co býval stínem', emoji: '🎩', gradient: [Color(0xFF546E7A), Color(0xFF78909C)], imagePath: 'assets/cast/0-andersen-the-shadow.jpg', country: 'DK'),
  CastMember(id: 'c1-grimm-the-goose-girl', label: 'Zrádná komorná', emoji: '😠', gradient: [Color(0xFF8E24AA), Color(0xFFAB47BC)], imagePath: 'assets/cast/1-grimm-the-goose-girl.jpg', country: 'DE'),
  CastMember(id: 'c2-grimm-the-story-of-the-youth-who-wen', label: 'Král se strašidelným hradem', emoji: '🏰', gradient: [Color(0xFF5D4037), Color(0xFF8D6E63)], imagePath: 'assets/cast/2-grimm-the-story-of-the-youth-who-wen.jpg', country: 'DE'),
  CastMember(id: 'c3-andersen-the-shadow', label: 'Chytrý stín', emoji: '🌑', gradient: [Color(0xFF37474F), Color(0xFF607D8B)], imagePath: 'assets/cast/3-andersen-the-shadow.jpg', country: 'DK'),
  CastMember(id: 'c4-perrault-riquet-with-the-tuft', label: 'Krásná, ale nechytrá princezna', emoji: '👸', gradient: [Color(0xFFEC407A), Color(0xFFF48FB1)], imagePath: 'assets/cast/4-perrault-riquet-with-the-tuft.jpg', country: 'FR'),
  CastMember(id: 'c5-andersen-the-red-shoes', label: 'Anděl, co nakonec odpustí', emoji: '😇', gradient: [Color(0xFFFFD54F), Color(0xFFFFECB3)], imagePath: 'assets/cast/5-andersen-the-red-shoes.jpg', country: 'DK'),
  CastMember(id: 'c6-grimm-rumpelstiltskin', label: 'Mlynářova chytrá dcera', emoji: '🧵', gradient: [Color(0xFFFFA726), Color(0xFFFFCC80)], imagePath: 'assets/cast/6-grimm-rumpelstiltskin.jpg', country: 'DE'),
  CastMember(id: 'c7-perrault-little-red-riding-hood', label: 'Babička, co otevře dveře', emoji: '🚪', gradient: [Color(0xFF8D6E63), Color(0xFFBCAAA4)], imagePath: 'assets/cast/7-perrault-little-red-riding-hood.jpg', country: 'FR'),
  CastMember(id: 'c8-perrault-little-thumb', label: 'Máma mezi bídou a láskou', emoji: '🤱', gradient: [Color(0xFF7E57C2), Color(0xFFB39DDB)], imagePath: 'assets/cast/8-perrault-little-thumb.jpg', country: 'FR'),
  CastMember(id: 'c9-perrault-introduction', label: 'Trpělivá žena', emoji: '🕯️', gradient: [Color(0xFF26A69A), Color(0xFF80CBC4)], imagePath: 'assets/cast/9-perrault-introduction.jpg', country: 'FR'),
  CastMember(id: 'c10-andersen-the-real-princess', label: 'Král, co podpoří syna', emoji: '👑', gradient: [Color(0xFF42A5F5), Color(0xFF90CAF9)], imagePath: 'assets/cast/10-andersen-the-real-princess.jpg', country: 'DK'),
  CastMember(id: 'c11-grimm-lily-and-the-lion', label: 'Dcera, co drží slovo', emoji: '🌸', gradient: [Color(0xFFD81B60), Color(0xFFF06292)], imagePath: 'assets/cast/11-grimm-lily-and-the-lion.jpg', country: 'DE'),
  CastMember(id: 'c12-andersen-the-real-princess', label: 'Princ hledá tu pravou', emoji: '🤴', gradient: [Color(0xFF3949AB), Color(0xFF7986CB)], imagePath: 'assets/cast/12-andersen-the-real-princess.jpg', country: 'DK'),
  CastMember(id: 'c13-andersen-the-little-match-girl', label: 'Holčička se sirkami', emoji: '🔥', gradient: [Color(0xFFE53935), Color(0xFFEF9A9A)], imagePath: 'assets/cast/13-andersen-the-little-match-girl.jpg', country: 'DK'),
  CastMember(id: 'c14-andersen-the-emperor-s-new-clothes', label: 'Dvořan, co mlčí', emoji: '🎭', gradient: [Color(0xFF00897B), Color(0xFF4DB6AC)], imagePath: 'assets/cast/14-andersen-the-emperor-s-new-clothes.jpg', country: 'DK'),
  CastMember(id: 'c15-perrault-riquet-with-the-tuft', label: 'Věrný sluha chystá hostinu', emoji: '🍲', gradient: [Color(0xFFEF6C00), Color(0xFFFFB74D)], imagePath: 'assets/cast/15-perrault-riquet-with-the-tuft.jpg', country: 'FR'),
  CastMember(id: 'c16-perrault-the-fairy', label: 'Nafoukaná dcera', emoji: '💢', gradient: [Color(0xFFC62828), Color(0xFFE57373)], imagePath: 'assets/cast/16-perrault-the-fairy.jpg', country: 'FR'),
  CastMember(id: 'c17-grimm-first-story', label: 'Vdova, co chce devět ocasů', emoji: '🦊', gradient: [Color(0xFFF4511E), Color(0xFFFFAB91)], imagePath: 'assets/cast/17-grimm-first-story.jpg', country: 'DE'),
];
