import 'dart:math';

import 'package:flutter/material.dart';

import 'motif.dart';

/// "Pick one of three, or shuffle" — the original §1.1 mechanic, kept
/// deliberately simpler than the cast composer's per-card reroll:
/// there's no per-slot swap here because there's only one slot. Reused
/// for task/problem/ending by passing a different [category].
class MotifPickerScreen extends StatefulWidget {
  const MotifPickerScreen({super.key, required this.category, required this.onSelected});

  final MotifCategory category;
  final ValueChanged<Motif> onSelected;

  @override
  State<MotifPickerScreen> createState() => _MotifPickerScreenState();
}

class _MotifPickerScreenState extends State<MotifPickerScreen> {
  final _rng = Random();
  late List<Motif> _deck;
  late List<Motif> _shown;

  @override
  void initState() {
    super.initState();
    _deck = List.of(motifPools[widget.category]!)..shuffle(_rng);
    _shown = _draw3();
  }

  List<Motif> _draw3() {
    if (_deck.length < 3) _deck = List.of(motifPools[widget.category]!)..shuffle(_rng);
    final picked = _deck.take(3).toList();
    _deck = [..._deck.skip(3), ...picked]; // recycle to the back, mirrors cast/'s deck
    return picked;
  }

  void _shuffle() => setState(() => _shown = _draw3());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E2723),
        title: Text(widget.category.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(widget.category.caption, style: const TextStyle(color: Color(0x993E2723), fontSize: 13, height: 1.3)),
            ),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: [for (final m in _shown) _MotifTile(key: ValueKey(m.id), motif: m, onTap: () => widget.onSelected(m))],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: OutlinedButton.icon(
                onPressed: _shuffle,
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text('Zamíchat'),
                style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF3E2723), side: const BorderSide(color: Color(0x333E2723))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MotifTile extends StatelessWidget {
  const _MotifTile({super.key, required this.motif, required this.onTap});

  final Motif motif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 170,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: motif.gradient))),
              Image.asset(
                motif.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(child: Text(motif.emoji, style: const TextStyle(fontSize: 44))),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54])),
                  child: Text(
                    motif.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13, shadows: [Shadow(blurRadius: 4, color: Colors.black26)]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
