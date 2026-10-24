import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:storyteller/packs/store_gateway.dart';

void main() {
  late Directory tmp;
  late File file;
  late _FakeIap iap;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('store-gateway');
    file = File('${tmp.path}/entitlements.json');
    iap = _FakeIap({'pack_czsk_1': '29 Kč', 'pack_czsk_2': '29 Kč'});
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  InAppStoreGateway gateway() {
    final g = InAppStoreGateway(file: Future.value(file), iap: iap, restoreSettle: Duration.zero);
    addTearDown(g.dispose);
    return g;
  }

  test('a bought part is owned, kept on the device and finished with the store', () async {
    final g = gateway();
    expect(await g.products({'pack_czsk_1', 'pack_nope_1'}), {'pack_czsk_1': isA<StoreProduct>().having((p) => p.price, 'price', '29 Kč')});
    final changes = <Set<String>>[];
    g.changes.listen(changes.add);

    iap.answer = PurchaseStatus.purchased;
    expect(await g.buy('pack_czsk_1'), Purchase.bought);
    expect(await g.owns('pack_czsk_1'), isTrue);
    expect(iap.completed, ['pack_czsk_1'], reason: 'Play refunds what is not acknowledged');
    expect(changes, [
      {'pack_czsk_1'},
    ]);
    final saved = (jsonDecode(file.readAsStringSync()) as List).single as Map<String, dynamic>;
    expect(saved['product_id'], 'pack_czsk_1');
    expect(saved['receipt'], 'receipt-pack_czsk_1', reason: 'kept for the server check of phase 2');

    // The next start, offline: the store says nothing, the file remembers.
    final next = InAppStoreGateway(file: Future.value(file), iap: _FakeIap(const {}), restoreSettle: Duration.zero);
    addTearDown(next.dispose);
    expect(await next.entitlements(), {'pack_czsk_1'});
  });

  test('cancelled and failed purchases own nothing', () async {
    final g = gateway();
    iap.answer = PurchaseStatus.canceled;
    expect(await g.buy('pack_czsk_1'), Purchase.cancelled);
    iap.answer = PurchaseStatus.error;
    expect(await g.buy('pack_czsk_1'), Purchase.failed);
    expect(await g.buy('pack_nope_1'), Purchase.failed, reason: 'not sold in this storefront');
    expect(await g.entitlements(), isEmpty);
    expect(file.existsSync(), isFalse);
  });

  test('Ask to Buy: pending now, owned when the store delivers it later', () async {
    final g = gateway();
    iap.answer = PurchaseStatus.pending;
    expect(await g.buy('pack_czsk_1'), Purchase.pending);
    expect(await g.owns('pack_czsk_1'), isFalse);

    final owned = g.changes.first;
    iap.deliver('pack_czsk_1', PurchaseStatus.purchased);
    expect(await owned, {'pack_czsk_1'});
  });

  test('restore gives back what the account bought', () async {
    final g = gateway();
    iap.onAccount = {'pack_czsk_1', 'pack_czsk_2'};
    expect(await g.restore(), {'pack_czsk_1', 'pack_czsk_2'});
    expect(await g.entitlements(), {'pack_czsk_1', 'pack_czsk_2'});
    iap.onAccount = {};
    expect(await g.restore(), isEmpty, reason: 'nothing new; what is owned stays');
    expect(await g.entitlements(), hasLength(2));
  });

  test('without a store nothing is for sale and nothing owned', () async {
    const g = NoStoreGateway();
    expect(await g.isAvailable(), isFalse);
    expect(await g.products({'pack_czsk_1'}), isEmpty);
    expect(await g.buy('pack_czsk_1'), Purchase.failed);
  });
}

/// The store: answers a purchase on the purchase stream as the plugin does
/// (asynchronously, after `buyNonConsumable` returned).
class _FakeIap implements InAppPurchase {
  _FakeIap(this.prices);

  final Map<String, String> prices;
  final _stream = StreamController<List<PurchaseDetails>>.broadcast();
  PurchaseStatus answer = PurchaseStatus.purchased;
  Set<String> onAccount = {};
  final completed = <String>[];

  void deliver(String id, PurchaseStatus status) => _stream.add([_FakePurchase(id, status)]);

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _stream.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) async => ProductDetailsResponse(
        productDetails: [
          for (final id in identifiers)
            if (prices[id] case final price?) ProductDetails(id: id, title: id, description: '', price: price, rawPrice: 29, currencyCode: 'CZK'),
        ],
        notFoundIDs: [for (final id in identifiers) if (!prices.containsKey(id)) id],
      );

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    final id = purchaseParam.productDetails.id;
    scheduleMicrotask(() => deliver(id, answer));
    return true;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async => completed.add(purchase.productID);

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    _stream.add([for (final id in onAccount) _FakePurchase(id, PurchaseStatus.restored)]);
    await Future<void>.delayed(Duration.zero);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePurchase extends PurchaseDetails {
  _FakePurchase(String id, PurchaseStatus status)
      : super(
          productID: id,
          purchaseID: 'tx-$id',
          verificationData: PurchaseVerificationData(localVerificationData: 'local', serverVerificationData: 'receipt-$id', source: 'app_store'),
          transactionDate: '1761300000000',
          status: status,
        ) {
    pendingCompletePurchase = status == PurchaseStatus.purchased || status == PurchaseStatus.restored;
  }
}
