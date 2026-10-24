import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:in_app_purchase/in_app_purchase.dart';

/// The one door to StoreKit 2 / Play Billing (STORYTELLER_MONETIZATION_PLAN.md
/// §7, PACKS_V2 §1): every product is a non-consumable `pack_<kod>_<N>`
/// that unlocks part N of a region. The store only unlocks; the part itself
/// downloads from GitHub like the free packs (pack_repository.dart).
///
/// Free packs never go through here — free content must not meet the
/// store (App Review: nothing free behind a payment wall).
abstract interface class StoreGateway {
  /// False where nothing can be bought: no store on the platform, a
  /// simulator without an account, tests. The app then shows no prices.
  Future<bool> isAvailable();

  /// The products the store sells, by id, with the price in the user's
  /// storefront currency; ids the store doesn't know are missing.
  Future<Map<String, StoreProduct>> products(Set<String> ids);

  /// Product ids the user owns (`*` = everything, development builds).
  /// Kept on the device, so an offline start still knows them.
  Future<Set<String>> entitlements();

  Future<bool> owns(String productId);

  /// Buys [productId]; resolves once the store has answered.
  Future<Purchase> buy(String productId);

  /// "Obnovit nákupy" — required by App Review. Resolves with the product
  /// ids the store gave back.
  Future<Set<String>> restore();

  /// The owned set after every change — a purchase, a restore, or one the
  /// store delivers late (Ask to Buy approved, a purchase interrupted by a
  /// crash finished at the next start).
  Stream<Set<String>> get changes;

  void dispose();
}

/// A product as the store describes it.
class StoreProduct {
  const StoreProduct({required this.id, required this.price, this.title = ''});

  final String id;

  /// Formatted for the user's storefront, e.g. "29 Kč" — shown as is.
  final String price;
  final String title;
}

/// How a [StoreGateway.buy] ended.
enum Purchase {
  /// Owned now.
  bought,

  /// Waiting for someone else — Ask to Buy, a cash payment on Play. It
  /// arrives later on [StoreGateway.changes].
  pending,
  cancelled,
  failed,
}

/// No store: nothing is owned and nothing can be bought.
class NoStoreGateway implements StoreGateway {
  const NoStoreGateway();

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<Map<String, StoreProduct>> products(Set<String> ids) async => const {};

  @override
  Future<Set<String>> entitlements() async => const {};

  @override
  Future<bool> owns(String productId) async => false;

  @override
  Future<Purchase> buy(String productId) async => Purchase.failed;

  @override
  Future<Set<String>> restore() async => const {};

  @override
  Stream<Set<String>> get changes => const Stream.empty();

  @override
  void dispose() {}
}

/// Development builds (`--dart-define=STORYTELLER_UNLOCK_ALL=true`): every
/// product owned, so paid packs can be tested without a store account.
class UnlockedStoreGateway extends NoStoreGateway {
  const UnlockedStoreGateway();

  @override
  Future<Set<String>> entitlements() async => const {'*'};

  @override
  Future<bool> owns(String productId) async => true;

  @override
  Future<Purchase> buy(String productId) async => Purchase.bought;
}

const unlockAllForDev = bool.fromEnvironment('STORYTELLER_UNLOCK_ALL');

/// The real stores through `package:in_app_purchase`.
///
/// What the user owns lives in [file] (`entitlements.json` in the support
/// dir), one record per product with the store's receipt, so a server can
/// verify it later (plan §7, phase 2: `store.ol1n.com`). Today a receipt
/// is kept, not verified.
class InAppStoreGateway implements StoreGateway {
  InAppStoreGateway({required this.file, InAppPurchase? iap, this.restoreSettle = const Duration(seconds: 1)}) : _iap = iap ?? InAppPurchase.instance {
    _sub = _iap.purchaseStream.listen(_onPurchases, onError: (Object e) => debugPrint('store: $e'));
  }

  /// Resolved lazily: the support dir is only known asynchronously.
  final Future<File> file;
  final InAppPurchase _iap;

  /// How long [restore] waits after the store's call returns: the restored
  /// purchases come on the purchase stream, a moment later.
  final Duration restoreSettle;

  StreamSubscription<List<PurchaseDetails>>? _sub;
  final _changes = StreamController<Set<String>>.broadcast();
  final _buying = <String, Completer<Purchase>>{};
  final _details = <String, ProductDetails>{};
  Set<String>? _restored;
  Future<Map<String, Map<String, dynamic>>>? _owned;

  /// Product id → its record; read once, then changed in memory and saved.
  Future<Map<String, Map<String, dynamic>>> _load() => _owned ??= () async {
        try {
          final list = (jsonDecode(await (await file).readAsString()) as List).cast<Map<String, dynamic>>();
          return {for (final r in list) r['product_id'] as String: r};
        } catch (_) {
          return <String, Map<String, dynamic>>{}; // none yet, or unreadable: a restore brings them back
        }
      }();

  Future<void> _save() async {
    final f = await file;
    f.parent.createSync(recursive: true);
    File('${f.path}.tmp')
      ..writeAsStringSync(jsonEncode((await _load()).values.toList()))
      ..renameSync(f.path);
  }

  @override
  Future<bool> isAvailable() async {
    try {
      return await _iap.isAvailable();
    } catch (e) {
      debugPrint('store unavailable: $e');
      return false;
    }
  }

  @override
  Future<Map<String, StoreProduct>> products(Set<String> ids) async {
    if (ids.isEmpty) return const {};
    final res = await _iap.queryProductDetails(ids);
    if (res.error != null) debugPrint('store products: ${res.error!.message}');
    for (final d in res.productDetails) {
      _details[d.id] = d;
    }
    return {for (final d in res.productDetails) d.id: StoreProduct(id: d.id, price: d.price, title: d.title)};
  }

  @override
  Future<Set<String>> entitlements() async => (await _load()).keys.toSet();

  @override
  Future<bool> owns(String productId) async => (await _load()).containsKey(productId);

  @override
  Future<Purchase> buy(String productId) async {
    if (_buying[productId] case final c?) return c.future; // a second tap
    var d = _details[productId];
    if (d == null) {
      await products({productId});
      d = _details[productId];
    }
    if (d == null) return Purchase.failed; // not sold in this storefront (yet)
    final done = _buying[productId] = Completer<Purchase>();
    try {
      // Play throws for an item already owned; StoreKit delivers it again.
      await _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: d));
    } catch (e) {
      debugPrint('store buy $productId: $e');
      _buying.remove(productId);
      return Purchase.failed;
    }
    return done.future;
  }

  @override
  Future<Set<String>> restore() async {
    final got = _restored = {};
    try {
      await _iap.restorePurchases();
      await Future<void>.delayed(restoreSettle);
    } finally {
      _restored = null;
    }
    return got;
  }

  @override
  Stream<Set<String>> get changes => _changes.stream;

  Future<void> _onPurchases(List<PurchaseDetails> list) async {
    for (final p in list) {
      final outcome = switch (p.status) {
        PurchaseStatus.purchased || PurchaseStatus.restored => Purchase.bought,
        PurchaseStatus.pending => Purchase.pending,
        PurchaseStatus.canceled => Purchase.cancelled,
        PurchaseStatus.error => Purchase.failed,
      };
      if (outcome == Purchase.bought) {
        (await _load())[p.productID] = {
          'product_id': p.productID,
          'purchase_id': ?p.purchaseID,
          'source': p.verificationData.source,
          'receipt': p.verificationData.serverVerificationData,
          'transaction_date': ?p.transactionDate,
          'granted_at': DateTime.now().toUtc().toIso8601String(),
        };
        // Saved before the store hears it's done: a finished purchase the
        // app forgot would be gone until a restore.
        await _save();
        _restored?.add(p.productID);
        if (!_changes.isClosed) _changes.add((await _load()).keys.toSet());
      }
      if (p.status == PurchaseStatus.error) debugPrint('store ${p.productID}: ${p.error?.message}');
      // Play refunds a purchase that isn't acknowledged within 3 days.
      if (p.pendingCompletePurchase) {
        try {
          await _iap.completePurchase(p);
        } catch (e) {
          debugPrint('store complete ${p.productID}: $e');
        }
      }
      _buying.remove(p.productID)?.complete(outcome);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _changes.close();
  }
}
