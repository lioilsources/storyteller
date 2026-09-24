import 'package:flutter/material.dart';

/// One candidate for a cast slot. In the real app this wraps a
/// corpus_motifs row (type == character) plus its resolved tier-0 asset
/// (MODELS_PLAN §1). Here it's a hand-written mock so the interaction
/// can be prototyped before any backend call exists — see
/// STORYTELLER_PLAN.md §1.1a.
@immutable
class CastMember {
  const CastMember({required this.id, required this.label, required this.emoji, required this.gradient});

  final String id;
  final String label;
  final String emoji;
  final List<Color> gradient;
}

/// Flavor mirrors gateway/internal/offer/seed.go's seedCharacters, so the
/// prototype isn't inventing unrelated content — just translated and
/// given a placeholder "art" tint standing in for a real tier-0 render.
const mockCastPool = <CastMember>[
  CastMember(id: 'fox', label: 'Chytrá liška', emoji: '🦊', gradient: [Color(0xFFFF8A65), Color(0xFFFFAB91)]),
  CastMember(id: 'smith-son', label: 'Kovářův syn', emoji: '🔨', gradient: [Color(0xFF8D6E63), Color(0xFFBCAAA4)]),
  CastMember(id: 'mill', label: 'Mluvící mlýn', emoji: '🌾', gradient: [Color(0xFFD4B483), Color(0xFFE8D3A2)]),
  CastMember(id: 'goose-girl', label: 'Husopaska', emoji: '🪿', gradient: [Color(0xFF81C784), Color(0xFFAED581)]),
  CastMember(id: 'brothers', label: 'Tři bratři', emoji: '👦', gradient: [Color(0xFF64B5F6), Color(0xFF90CAF9)]),
  CastMember(id: 'clockwork-princess', label: 'Princezna hodinářka', emoji: '⏰', gradient: [Color(0xFFBA68C8), Color(0xFFCE93D8)]),
  CastMember(id: 'owl', label: 'Moudrá sova', emoji: '🦉', gradient: [Color(0xFF5C6BC0), Color(0xFF7986CB)]),
  CastMember(id: 'blacksmith', label: 'Stará kovářka', emoji: '⚒️', gradient: [Color(0xFF78909C), Color(0xFF90A4AE)]),
  CastMember(id: 'dragon', label: 'Malý drak', emoji: '🐉', gradient: [Color(0xFF4DB6AC), Color(0xFF80CBC4)]),
  CastMember(id: 'water-sprite', label: 'Vodník', emoji: '💧', gradient: [Color(0xFF4FC3F7), Color(0xFF81D4FA)]),
  CastMember(id: 'four-princesses', label: 'Čtyři princezny', emoji: '👑', gradient: [Color(0xFFF06292), Color(0xFFF48FB1)]),
  CastMember(id: 'traveling-tailor', label: 'Potulný krejčí', emoji: '🧵', gradient: [Color(0xFFFFB74D), Color(0xFFFFCC80)]),
  CastMember(id: 'talking-cat', label: 'Mluvící kocour', emoji: '🐱', gradient: [Color(0xFF9575CD), Color(0xFFB39DDB)]),
  CastMember(id: 'forest-hermit', label: 'Lesní poustevník', emoji: '🌲', gradient: [Color(0xFF66BB6A), Color(0xFF9CCC65)]),
];
