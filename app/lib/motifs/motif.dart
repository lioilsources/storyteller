import 'package:flutter/material.dart';

/// Task/problem/ending motif candidate. Unlike [CastMember] (cast/) these
/// stay singular regardless of cast size (STORYTELLER_PLAN.md §1.1a) —
/// pick exactly one of three, or shuffle for three new ones.
///
/// Real content, generated 2026-09-25: label/text pulled from motifs
/// rag.extract found in 93 real public-domain tales (Grimm/Andersen/
/// Perrault), Czech labels hand-translated (no LLM was up at the time —
/// swarm-director down until 1AM, translate stopped for memory), art via
/// internal/nimqueue (flux-schnell, watercolor). Source English motif text
/// is what was actually sent as the render prompt.
@immutable
class Motif {
  const Motif({required this.id, required this.label, required this.emoji, required this.gradient, required this.imagePath});

  final String id;
  final String label;
  final String emoji;
  final List<Color> gradient; // fallback while imagePath loads / if it's ever missing
  final String imagePath;
}

enum MotifCategory { task, problem, ending }

extension MotifCategoryLabels on MotifCategory {
  String get title => switch (this) {
        MotifCategory.task => 'Jaký úkol?',
        MotifCategory.problem => 'Jaký problém?',
        MotifCategory.ending => 'Jaký konec?',
      };

  String get caption => switch (this) {
        MotifCategory.task => 'Ťukni na kartu = vyber úkol pro hrdinu.',
        MotifCategory.problem => 'Ťukni na kartu = vyber překážku nebo záporáka.',
        MotifCategory.ending => 'Ťukni na kartu = vyber šťastný konec.',
      };
}

const taskPool = <Motif>[
  Motif(id: 'task-wine', label: 'Kdo vypije sklep vína', emoji: '🍷', gradient: [Color(0xFFEF5350), Color(0xFFE57373)], imagePath: 'assets/motifs/task-wine.jpg'),
  Motif(id: 'task-diamonds', label: 'Let za diamanty', emoji: '💎', gradient: [Color(0xFFFFA726), Color(0xFFFFB74D)], imagePath: 'assets/motifs/task-diamonds.jpg'),
  Motif(id: 'task-ring-duck', label: 'Prsten v kachně', emoji: '🦆', gradient: [Color(0xFF29B6F6), Color(0xFF4FC3F7)], imagePath: 'assets/motifs/task-ring-duck.jpg'),
  Motif(id: 'task-giants', label: 'Přelstít obry', emoji: '🪡', gradient: [Color(0xFF26A69A), Color(0xFF4DB6AC)], imagePath: 'assets/motifs/task-giants.jpg'),
  Motif(id: 'task-tom-thumb', label: 'Útěk malého Palečka', emoji: '🏃', gradient: [Color(0xFFAB47BC), Color(0xFFBA68C8)], imagePath: 'assets/motifs/task-tom-thumb.jpg'),
  Motif(id: 'task-swineherd', label: 'Získat princeznino srdce', emoji: '🐷', gradient: [Color(0xFF8D6E63), Color(0xFFA1887F)], imagePath: 'assets/motifs/task-swineherd.jpg'),
  Motif(id: 'task-bell', label: 'Záhadný zvon v lese', emoji: '🔔', gradient: [Color(0xFF7E57C2), Color(0xFF9575CD)], imagePath: 'assets/motifs/task-bell.jpg'),
  Motif(id: 'task-golden-object', label: 'Dar, který nesmí zneužít', emoji: '✨', gradient: [Color(0xFF66BB6A), Color(0xFF9CCC65)], imagePath: 'assets/motifs/task-golden-object.jpg'),
];

const problemPool = <Motif>[
  Motif(id: 'problem-fox-pride', label: 'Liščina pýcha', emoji: '🦊', gradient: [Color(0xFF5C6BC0), Color(0xFF7986CB)], imagePath: 'assets/motifs/problem-fox-pride.jpg'),
  Motif(id: 'problem-lazy-sister', label: 'Líná sestra', emoji: '🛌', gradient: [Color(0xFFEC407A), Color(0xFFF48FB1)], imagePath: 'assets/motifs/problem-lazy-sister.jpg'),
  Motif(id: 'problem-witch-boots', label: 'Čarodějnice v sedmimílových botách', emoji: '👢', gradient: [Color(0xFF78909C), Color(0xFF90A4AE)], imagePath: 'assets/motifs/problem-witch-boots.jpg'),
  Motif(id: 'problem-tailor-doubt', label: 'Nikdo mu nevěří', emoji: '🤨', gradient: [Color(0xFFFFCA28), Color(0xFFFFE082)], imagePath: 'assets/motifs/problem-tailor-doubt.jpg'),
  Motif(id: 'problem-lions', label: 'Hladoví lvi u brány', emoji: '🦁', gradient: [Color(0xFF42A5F5), Color(0xFF90CAF9)], imagePath: 'assets/motifs/problem-lions.jpg'),
  Motif(id: 'problem-eagle', label: 'Orel a trpaslík', emoji: '🦅', gradient: [Color(0xFFD4B483), Color(0xFFE8D3A2)], imagePath: 'assets/motifs/problem-eagle.jpg'),
  Motif(id: 'problem-truth', label: 'Kouzelné zvíře prozradí pravdu', emoji: '🐦', gradient: [Color(0xFF26C6DA), Color(0xFF4DD0E1)], imagePath: 'assets/motifs/problem-truth.jpg'),
  Motif(id: 'problem-old-house', label: 'Nikdo nechce starý dům', emoji: '🏚️', gradient: [Color(0xFFEF6C00), Color(0xFFFFB74D)], imagePath: 'assets/motifs/problem-old-house.jpg'),
];

const endingPool = <Motif>[
  Motif(id: 'ending-trick-wins', label: 'Chytrost zvítězí', emoji: '🐴', gradient: [Color(0xFF43A047), Color(0xFFA5D6A7)], imagePath: 'assets/motifs/ending-trick-wins.jpg'),
  Motif(id: 'ending-truth-child', label: 'Dítě řekne pravdu', emoji: '👑', gradient: [Color(0xFF3949AB), Color(0xFF5C6BC0)], imagePath: 'assets/motifs/ending-truth-child.jpg'),
  Motif(id: 'ending-new-home', label: 'Nový domov, staří přátelé', emoji: '🎵', gradient: [Color(0xFFD81B60), Color(0xFFF06292)], imagePath: 'assets/motifs/ending-new-home.jpg'),
  Motif(id: 'ending-happy-together', label: 'Šťastně spolu navždy', emoji: '👫', gradient: [Color(0xFF6D4C41), Color(0xFF8D6E63)], imagePath: 'assets/motifs/ending-happy-together.jpg'),
  Motif(id: 'ending-kiss-wakes', label: 'Polibek probudí království', emoji: '👸', gradient: [Color(0xFF00897B), Color(0xFF4DB6AC)], imagePath: 'assets/motifs/ending-kiss-wakes.jpg'),
  Motif(id: 'ending-leapfrog', label: 'Chytrost skáče nejvýš', emoji: '🐸', gradient: [Color(0xFFC0CA33), Color(0xFFDCE775)], imagePath: 'assets/motifs/ending-leapfrog.jpg'),
  Motif(id: 'ending-curse-broken', label: 'Kletba zlomena', emoji: '🐝', gradient: [Color(0xFF5E35B1), Color(0xFF7E57C2)], imagePath: 'assets/motifs/ending-curse-broken.jpg'),
  Motif(id: 'ending-welcomed-home', label: 'Vítán doma', emoji: '🏡', gradient: [Color(0xFFFB8C00), Color(0xFFFFB74D)], imagePath: 'assets/motifs/ending-welcomed-home.jpg'),
];

const motifPools = <MotifCategory, List<Motif>>{
  MotifCategory.task: taskPool,
  MotifCategory.problem: problemPool,
  MotifCategory.ending: endingPool,
};
