/// The one door to StoreKit 2 / Play Billing (STORYTELLER_MONETIZATION_PLAN.md
/// §7). Phase 1-2 ship only the stubs below; phase 3 adds an
/// `in_app_purchase` implementation behind the same interface.
///
/// Free packs never go through here — free content must not meet the
/// store (App Review: nothing free behind a payment wall).
abstract interface class StoreGateway {
  /// Product ids the user owns, bundles already expanded to the
  /// `pack_<cc>` ids they unlock.
  Future<Set<String>> entitlements();

  Future<bool> owns(String productId);

  /// Starts a purchase; resolves true once the product is owned.
  Future<bool> buy(String productId);

  /// "Obnovit nákupy" — required by App Review.
  Future<void> restore();
}

/// No store yet: nothing is owned and nothing can be bought.
class NoStoreGateway implements StoreGateway {
  const NoStoreGateway();

  @override
  Future<Set<String>> entitlements() async => const {};

  @override
  Future<bool> owns(String productId) async => false;

  @override
  Future<bool> buy(String productId) async => false;

  @override
  Future<void> restore() async {}
}

/// Development builds (`--dart-define=STORYTELLER_UNLOCK_ALL=true`): every
/// product owned, so paid packs can be tested before phase 3 exists.
class UnlockedStoreGateway implements StoreGateway {
  const UnlockedStoreGateway();

  @override
  Future<Set<String>> entitlements() async => const {'*'};

  @override
  Future<bool> owns(String productId) async => true;

  @override
  Future<bool> buy(String productId) async => true;

  @override
  Future<void> restore() async {}
}

const unlockAllForDev = bool.fromEnvironment('STORYTELLER_UNLOCK_ALL');
