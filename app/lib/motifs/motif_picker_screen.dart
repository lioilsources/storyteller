import 'dart:math';
import 'dart:math' as math;

import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';

import '../theme/kid_text.dart';
import 'motif.dart';

/// "Pick one of three, or shuffle" — the original §1.1 mechanic, kept
/// deliberately simpler than the cast composer's per-card reroll:
/// there's no per-slot swap here because there's only one slot. Reused
/// for task/problem/ending by passing a different [category].
class MotifPickerScreen extends StatefulWidget {
  const MotifPickerScreen({super.key, required this.category, required this.onSelected, this.countryIso, this.packPool});

  final MotifCategory category;
  final ValueChanged<Motif> onSelected;

  /// Set when the globe (§1.1b) picked a country — only that
  /// tradition's motifs are then offered.
  final String? countryIso;

  /// Motifs from the RAG packs (lib/rag/), already narrowed to
  /// [countryIso]. When non-empty they replace the hand-curated pool: the
  /// point of this build is to try the app on what the pipeline wrote.
  final List<Motif>? packPool;

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
    _deck = List.of(_pool)..shuffle(_rng);
    _shown = _drawSome();
  }

  /// This category's motifs, narrowed to the chosen country if there is
  /// one. A country with nothing here falls back to everything rather
  /// than showing an empty screen.
  List<Motif> get _pool {
    final pack = widget.packPool;
    if (pack != null && pack.isNotEmpty) return pack;
    final all = motifPools[widget.category]!;
    final iso = widget.countryIso;
    if (iso == null) return all;
    final filtered = [for (final m in all) if (m.country == iso) m];
    return filtered.isEmpty ? all : filtered;
  }

  /// Three cards when the pool allows it. A narrow country (France
  /// currently has one translated motif per category) simply shows
  /// fewer — better than padding with motifs from elsewhere and
  /// quietly breaking the promise the globe just made.
  List<Motif> _drawSome() {
    final pool = _pool;
    final want = math.min(3, pool.length);
    if (_deck.length < want) _deck = List.of(pool)..shuffle(_rng);
    final picked = _deck.take(want).toList();
    _deck = [..._deck.skip(want), ...picked]; // recycle to the back, mirrors cast/'s deck
    return picked;
  }

  /// The packs load asynchronously and may arrive after this screen is
  /// already showing curated cards — re-deal once they do.
  @override
  void didUpdateWidget(MotifPickerScreen old) {
    super.didUpdateWidget(old);
    if ((old.packPool?.length ?? 0) != (widget.packPool?.length ?? 0)) {
      _deck = List.of(_pool)..shuffle(_rng);
      _shown = _drawSome();
    }
  }

  void _shuffle() => setState(() => _shown = _drawSome());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E2723),
        title: StoryTitle(widget.category.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(widget.category.caption, style: context.kid(KidRole.body, size: 15, color: StoryInk.soft)),
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
                onPressed: _pool.length > _shown.length ? _shuffle : null,
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
              if (motif.imageBytes != null)
                Image.memory(motif.imageBytes!, fit: BoxFit.cover, gaplessPlayback: true)
              else if (motif.imagePath == null)
                Center(child: Text(motif.emoji, style: const TextStyle(fontSize: 44)))
              else
                Image.asset(
                  motif.imagePath!,
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
                  child: StoryCardLabel(motif.label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
