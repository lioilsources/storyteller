import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cast/cast_composer_screen.dart';

void main() {
  runApp(const ProviderScope(child: StorytellerApp()));
}

class StorytellerApp extends StatelessWidget {
  const StorytellerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vyprávěj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF8D6E63), useMaterial3: true, fontFamily: 'Roboto'),
      // Prototype entry point (STORYTELLER_PLAN.md §1.1a) — the real app
      // opens on the globe (§1.1b) or the daily offer (§1.1), not here.
      home: const CastComposerScreen(),
    );
  }
}
