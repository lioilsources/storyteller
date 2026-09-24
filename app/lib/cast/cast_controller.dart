import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cast_member.dart';

const minCastSize = 1;
const maxCastSize = 6;
const initialCastSize = 3;

/// How many renders beyond what's on screen stay pre-warmed at all times
/// (STORYTELLER_PLAN.md §1.1a: "N+K kandidátů, K≈3"). While the deck can
/// still supply a warm draw, a reroll/add resolves instantly; once it's
/// exhausted, a draw takes the simulated tier-0 online-render delay
/// instead — the same fallback the real resolver takes (MODELS_PLAN §4).
const prewarmBudget = 3;

/// A card slot's stable identity survives reroll (so its position in the
/// grid doesn't jump); its member and loading state don't.
class CastSlot {
  const CastSlot({required this.slotKey, required this.member, this.isLoading = false});

  final String slotKey;
  final CastMember member;
  final bool isLoading;

  CastSlot copyWith({CastMember? member, bool? isLoading}) =>
      CastSlot(slotKey: slotKey, member: member ?? this.member, isLoading: isLoading ?? this.isLoading);
}

class CastComposerController extends Notifier<List<CastSlot>> {
  final _rng = Random();
  late List<CastMember> _deck;
  late int _warmRemaining;
  int _keySeq = 0;

  @override
  List<CastSlot> build() {
    _deck = List.of(mockCastPool)..shuffle(_rng);
    _warmRemaining = prewarmBudget;
    // Can't read `state` here — it doesn't exist until build() returns —
    // so track "already chosen" locally instead of via _draw(state...).
    final chosenIds = <String>[];
    return List.generate(initialCastSize, (_) {
      final member = _draw(chosenIds);
      chosenIds.add(member.id);
      return CastSlot(slotKey: _newKey(), member: member);
    });
  }

  bool get canAdd => state.length < maxCastSize;
  bool get canRemove => state.length > minCastSize;

  String _newKey() => 's${_keySeq++}';

  /// Pull the next candidate not in [excludeIds]. Puts spent members back
  /// at the end of the deck so a long session doesn't run dry — mirrors a
  /// real candidate pool being larger than what's ever shown at once.
  CastMember _draw(Iterable<String> excludeIds) {
    if (_deck.isEmpty) _deck = List.of(mockCastPool)..shuffle(_rng);
    final exclude = excludeIds.toSet();
    final idx = _deck.indexWhere((m) => !exclude.contains(m.id));
    final member = _deck.removeAt(idx >= 0 ? idx : 0);
    _deck.add(member);
    return member;
  }

  Iterable<String> get _inUse => state.map((s) => s.member.id);

  Future<void> rerollOne(String slotKey) async {
    final i = state.indexWhere((s) => s.slotKey == slotKey);
    if (i == -1) return;
    await _resolveInto(i, state[i]);
  }

  Future<void> rerollAll() async {
    final snapshot = state;
    for (var i = 0; i < snapshot.length; i++) {
      unawaited(_resolveInto(i, snapshot[i]));
    }
  }

  Future<void> addSlot() async {
    if (!canAdd) return;
    final slot = CastSlot(slotKey: _newKey(), member: _draw(_inUse));
    final warm = _warmRemaining > 0;
    if (warm) {
      _warmRemaining--;
      state = [...state, slot];
      return;
    }
    state = [...state, slot.copyWith(isLoading: true)];
    await Future<void>.delayed(_coldDelay());
    final i = state.indexWhere((s) => s.slotKey == slot.slotKey);
    if (i != -1) _replaceAt(i, slot.copyWith(isLoading: false));
  }

  void removeSlot(String slotKey) {
    if (!canRemove) return;
    state = state.where((s) => s.slotKey != slotKey).toList();
  }

  Future<void> _resolveInto(int index, CastSlot slot) async {
    final next = _draw(_inUse);
    final warm = _warmRemaining > 0;
    if (warm) {
      _warmRemaining--;
      _replaceAt(index, slot.copyWith(member: next));
      return;
    }
    // Cold: keep the old art visible under a loading veil until the
    // simulated online tier-0 render "finishes" — never blank.
    _replaceAt(index, slot.copyWith(isLoading: true));
    await Future<void>.delayed(_coldDelay());
    _replaceAt(index, CastSlot(slotKey: slot.slotKey, member: next, isLoading: false));
  }

  void _replaceAt(int index, CastSlot slot) {
    final i = state.indexWhere((s) => s.slotKey == slot.slotKey);
    if (i == -1) return;
    final next = [...state];
    next[i] = slot;
    state = next;
  }

  Duration _coldDelay() => Duration(milliseconds: 900 + _rng.nextInt(700)); // MODELS_PLAN tier 0: ~1–2 s on GB10
}

final castComposerProvider = NotifierProvider.autoDispose<CastComposerController, List<CastSlot>>(CastComposerController.new);
