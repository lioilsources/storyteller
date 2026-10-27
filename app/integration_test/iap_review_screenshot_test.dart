// The App Review screenshot for the paid parts (store/iap.md): the globe's
// card for Czechia with its offer to buy a part. A simulator has no store
// account, so a fake store sells every part of the live manifest.
//
//   tool/store_screenshots.sh Pohadkomat-iPhone build/iap_review integration_test/iap_review_screenshot_test.dart
import 'package:cute_kid_fonts/cute_kid_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:storyteller/globe/globe_screen.dart';
import 'package:storyteller/packs/pack_providers.dart';
import 'package:storyteller/packs/store_gateway.dart';
import 'package:storyteller/theme/kid_text.dart';

class _SellingStore extends NoStoreGateway {
  const _SellingStore();

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<Map<String, StoreProduct>> products(Set<String> ids) async => {for (final id in ids) id: StoreProduct(id: id, price: '25 Kč')};
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('iap review screenshot', (tester) async {
    final container = ProviderContainer(overrides: [storeGatewayProvider.overrideWithValue(const _SellingStore())]);
    addTearDown(container.dispose);

    Future<void> settle([int ms = 1500]) async {
      for (var i = 0; i < ms ~/ 100; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 100)));
        await tester.pump();
      }
    }

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: storyThemeData(),
        builder: (context, child) => KidTheme(data: storyKidTheme, child: child!),
        home: const GlobeScreen(),
      ),
    ));
    await settle(4000); // the live manifest (with the parts) comes over the network
    await tester.tap(find.textContaining('Přiblížit'));
    await settle(3000);
    // Czechia has free tales too, so the offer is the small "+50 · <price>" beside "Vyprávět".
    expect(find.textContaining('25 Kč'), findsWidgets, reason: 'no purchase offer on the Czechia card');
    // ignore: avoid_print
    print('SHOT iap_review');
    await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 6)));
  });
}
