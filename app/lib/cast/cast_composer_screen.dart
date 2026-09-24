import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cast_controller.dart';

/// Prototype of STORYTELLER_PLAN.md §1.1a: reroll one card, reroll all,
/// add/remove cast members (1–6). All "art" is a placeholder gradient +
/// emoji standing in for a resolved tier-0 render — the point of this
/// screen is the interaction feel, not real content.
class CastComposerScreen extends ConsumerWidget {
  const CastComposerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = ref.watch(castComposerProvider);
    final controller = ref.read(castComposerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E2723),
        title: const Text('Kdo bude v pohádce?'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                'Ťukni na kartu = jiná postava. Kartu smaž křížkem. '
                'Hudba a zvuky jsou vždy hotové z packu země — jen obrázek '
                'postavy se občas chvilku dokresluje.',
                style: TextStyle(color: Color(0x993E2723), fontSize: 13, height: 1.3),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final slot in slots)
                      _CastCard(
                        key: ValueKey(slot.slotKey),
                        slot: slot,
                        canRemove: controller.canRemove,
                        onTap: () => controller.rerollOne(slot.slotKey),
                        onRemove: () => controller.removeSlot(slot.slotKey),
                      ),
                    if (controller.canAdd) _AddCard(onTap: controller.addSlot),
                  ],
                ),
              ),
            ),
            _BottomBar(count: slots.length, onShuffleAll: controller.rerollAll),
          ],
        ),
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({super.key, required this.slot, required this.canRemove, required this.onTap, required this.onRemove});

  final CastSlot slot;
  final bool canRemove;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutBack,
      builder: (context, t, child) => Transform.scale(scale: t.clamp(0, 1), child: Opacity(opacity: t.clamp(0, 1), child: child)),
      child: SizedBox(
        width: 132,
        height: 168,
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
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: Tween(begin: 0.92, end: 1.0).animate(anim), child: child),
                  ),
                  child: Container(
                    key: ValueKey(slot.member.id),
                    decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: slot.member.gradient)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(slot.member.emoji, style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            slot.member.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13, shadows: [Shadow(blurRadius: 4, color: Colors.black26)]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // AnimatedSwitcher (not just an opacity fade) so the
                // CircularProgressIndicator is fully unmounted once
                // isLoading flips back to false — an indeterminate
                // spinner left in the tree merely hidden by opacity
                // keeps scheduling frames forever, which would make
                // this screen (and pumpAndSettle in tests) never settle.
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: slot.isLoading
                      ? IgnorePointer(
                          key: const ValueKey('loading'),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.38),
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(strokeWidth: 2.6, color: Colors.white),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey('idle')),
                ),
                if (canRemove)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: _RemoveButton(onTap: onRemove),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.28),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(5),
          child: Icon(Icons.close, size: 15, color: Colors.white),
        ),
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  const _AddCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 132,
      height: 168,
      child: Material(
        color: const Color(0x14795548),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x4D795548), width: 1.5, strokeAlign: BorderSide.strokeAlignInside),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle_outline, size: 34, color: Color(0x99795548)),
                  SizedBox(height: 8),
                  Text('Přidat postavu', style: TextStyle(color: Color(0x99795548), fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.count, required this.onShuffleAll});
  final int count;
  final VoidCallback onShuffleAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: Row(
        children: [
          Text('Obsazení: $count/$maxCastSize', style: const TextStyle(color: Color(0xFF3E2723), fontWeight: FontWeight.w600)),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: onShuffleAll,
            icon: const Icon(Icons.shuffle, size: 18),
            label: const Text('Zamíchat vše'),
            style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF3E2723), side: const BorderSide(color: Color(0x333E2723))),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3E2723)),
            child: const Text('Pokračovat →'),
          ),
        ],
      ),
    );
  }
}
