import 'package:flutter/material.dart';

/// One candidate for a cast slot. In the real app this wraps a
/// corpus_motifs row (type == character) plus its resolved tier-0 asset
/// (MODELS_PLAN §1) — `imagePath` is exactly that: a real flux-schnell
/// render (`internal/nimqueue`, watercolor style), not a placeholder.
/// See STORYTELLER_PLAN.md §1.1a.
@immutable
class CastMember {
  const CastMember({required this.id, required this.label, required this.emoji, required this.gradient, required this.imagePath});

  final String id;
  final String label;
  final String emoji;
  final List<Color> gradient; // fallback while imagePath loads / if it's ever missing
  final String imagePath;
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
];
