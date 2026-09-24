import 'package:flutter/material.dart';

/// Task/problem/ending motif candidate. Unlike [CastMember] (cast/) these
/// stay singular regardless of cast size (STORYTELLER_PLAN.md §1.1a) —
/// pick exactly one of three, or shuffle for three new ones. No real
/// art yet: these are still hand-written flavor (same content as
/// gateway/internal/offer/seed.go, translated), waiting on the RAG
/// pass over the fetched corpus to have real motifs to illustrate.
@immutable
class Motif {
  const Motif({required this.id, required this.label, required this.emoji, required this.gradient});

  final String id;
  final String label;
  final String emoji;
  final List<Color> gradient;
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
  Motif(id: 'task-forest', label: 'Přejít šeptající les', emoji: '🌲', gradient: [Color(0xFF66BB6A), Color(0xFF9CCC65)]),
  Motif(id: 'task-apple', label: 'Najít zlaté jablko', emoji: '🍎', gradient: [Color(0xFFEF5350), Color(0xFFE57373)]),
  Motif(id: 'task-market', label: 'Vyměnit tři nemožné věci', emoji: '🎪', gradient: [Color(0xFFFFA726), Color(0xFFFFB74D)]),
  Motif(id: 'task-wind', label: 'Poznat jméno větru', emoji: '🌬️', gradient: [Color(0xFF29B6F6), Color(0xFF4FC3F7)]),
  Motif(id: 'task-water', label: 'Nerozlít ani kapku', emoji: '💧', gradient: [Color(0xFF26C6DA), Color(0xFF4DD0E1)]),
  Motif(id: 'task-bridge', label: 'Postavit most z lesa', emoji: '🌉', gradient: [Color(0xFF8D6E63), Color(0xFFA1887F)]),
];

const problemPool = <Motif>[
  Motif(id: 'problem-giant', label: 'Mrzutý obr v cestě', emoji: '🗿', gradient: [Color(0xFF78909C), Color(0xFF90A4AE)]),
  Motif(id: 'problem-river', label: 'Zamrzlá řeka', emoji: '❄️', gradient: [Color(0xFF5C6BC0), Color(0xFF7986CB)]),
  Motif(id: 'problem-map', label: 'Ukradená mapa', emoji: '🗺️', gradient: [Color(0xFFAB47BC), Color(0xFFBA68C8)]),
  Motif(id: 'problem-gift', label: 'Prokletý dar', emoji: '🎁', gradient: [Color(0xFF7E57C2), Color(0xFF9575CD)]),
  Motif(id: 'problem-lantern', label: 'Lucerny nechtějí svítit', emoji: '🏮', gradient: [Color(0xFF3949AB), Color(0xFF5C6BC0)]),
  Motif(id: 'problem-riddle', label: 'Královská hádanka', emoji: '👑', gradient: [Color(0xFF6D4C41), Color(0xFF8D6E63)]),
];

const endingPool = <Motif>[
  Motif(id: 'ending-feast', label: 'Společná hostina', emoji: '🍞', gradient: [Color(0xFFFFA726), Color(0xFFFFCC80)]),
  Motif(id: 'ending-friendship', label: 'Nečekané přátelství', emoji: '🤝', gradient: [Color(0xFF66BB6A), Color(0xFFA5D6A7)]),
  Motif(id: 'ending-seen', label: 'Konečně viděn/a', emoji: '✨', gradient: [Color(0xFFFFCA28), Color(0xFFFFE082)]),
  Motif(id: 'ending-curse', label: 'Kletba se zlomí', emoji: '🕊️', gradient: [Color(0xFF42A5F5), Color(0xFF90CAF9)]),
  Motif(id: 'ending-pocket', label: 'V kapse celou dobu', emoji: '🧺', gradient: [Color(0xFFD4B483), Color(0xFFE8D3A2)]),
  Motif(id: 'ending-needed', label: 'Co kdo doopravdy potřeboval', emoji: '💝', gradient: [Color(0xFFEC407A), Color(0xFFF48FB1)]),
];

const motifPools = <MotifCategory, List<Motif>>{
  MotifCategory.task: taskPool,
  MotifCategory.problem: problemPool,
  MotifCategory.ending: endingPool,
};
