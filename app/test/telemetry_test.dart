// The checks every app copies from ol1n_telemetry (README "Testovací
// sada"), plus what is specific to Pohádkomat: the go_router screen names
// and the compose flow that spans five screens.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:ol1n_telemetry/testing.dart';
import 'package:storyteller/narrate/narration_screen.dart';
import 'package:storyteller/telemetry/compose_telemetry.dart';
import 'package:storyteller/telemetry/telemetry_dictionary.dart';

import 'globe_entry.dart';

class _Names extends NavigatorObserver {
  final names = <String?>[];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => names.add(route.settings.name);
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => names.add(newRoute?.settings.name);
}

Future<void> _init() => Telemetry.init(
      app: kTelemetryApp,
      appVersion: kAppVersion,
      dictionary: appDictionary,
      store: MemoryTelemetryStore(),
      lang: () => 'cs',
      sink: FakeSink(),
      startTimer: false,
      observeLifecycle: false,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('docs/telemetry.md lists exactly the dictionary', () {
    expect(telemetryDocProblems(appDictionary, File('docs/telemetry.md').readAsStringSync()), isEmpty);
  });

  test('no property is free text', () {
    expect(telemetryDictionaryProblems(appDictionary), isEmpty);
  });

  test('app version matches pubspec.yaml', () {
    expect(telemetryVersionProblems(kAppVersion, File('pubspec.yaml').readAsStringSync()), isEmpty);
  });

  test('the code sends only dictionary events, and every one of them', () {
    expect(telemetryTrackCallProblems(appDictionary), isEmpty);
  });

  test('no key, no network', () async {
    expect(await telemetryNoKeyProblems(appDictionary), isEmpty);
  }, skip: const bool.fromEnvironment('TELEMETRY_DEBUG'));

  test('off means nothing', () async {
    expect(await telemetryOffProblems(appDictionary), isEmpty);
  });

  test('every route in main.dart has a screen, and nothing else does', () {
    final src = File('lib/main.dart').readAsStringSync();
    final paths = {for (final m in RegExp(r"path: '(/[a-z]+)'").allMatches(src)) m.group(1)!};
    expect(paths, kScreenRoutes.keys.toSet());
  });

  testWidgets('go_router hands the observer the route path as RouteSettings.name', (tester) async {
    final names = _Names();
    final router = GoRouter(
      initialLocation: '/globe',
      observers: [names],
      routes: [
        GoRoute(path: '/globe', builder: (context, state) => const Text('globe')),
        GoRoute(path: '/cast', builder: (context, state) => const Text('cast')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.go('/cast?x=1');
    await tester.pumpAndSettle();
    expect(names.names, ['/globe', '/cast']);
    final observer = TelemetryNavigatorObserver(kScreenRoutes);
    expect(names.names.map(observer.screenOfName), ['globe', 'cast']);
    expect(observer.screenOfName('/vypravim'), 'narrate');
    expect(observer.screenOfName('/unknown'), 'other');
  });

  group('compose flow', () {
    setUp(Telemetry.resetForTest);
    tearDown(() {
      ComposeTelemetry.end('cancel');
      Telemetry.resetForTest();
    });

    Map<String, Object?> last(String name) => Telemetry.debugQueue.lastWhere((e) => e.name == name).props;

    test('ok at the osnova reports the step and the cast size', () async {
      await _init();
      ComposeTelemetry.start('CZSK');
      ComposeTelemetry.reached('task', cast: 3);
      ComposeTelemetry.reached('problem');
      ComposeTelemetry.reached('ending');
      ComposeTelemetry.reached('osnova');
      ComposeTelemetry.end('ok');
      expect(last('compose_start')['region'], 'czsk');
      expect(last('compose_end'), containsPair('result', 'ok'));
      expect(last('compose_end'), containsPair('step', 'osnova'));
      expect(last('compose_end'), containsPair('cast', 3));
    });

    test('a new country cancels the open story; unknown regions are other', () async {
      await _init();
      ComposeTelemetry.start('NOPE');
      ComposeTelemetry.start(null);
      final ends = Telemetry.debugQueue.where((e) => e.name == 'compose_end').toList();
      expect(ends, hasLength(1));
      expect(ends.single.props, containsPair('result', 'cancel'));
      expect(ends.single.props, containsPair('step', 'cast'));
      expect(Telemetry.debugQueue.where((e) => e.name == 'compose_start').map((e) => e.props['region']), ['other', 'other']);
    });
  });

  testWidgets('a whole tale, globe to "Konec", sends only dictionary events', (tester) async {
    Telemetry.resetForTest();
    addTearDown(Telemetry.resetForTest);
    await _init(); // debug asserts fire on anything outside the dictionary
    await enterFlowFrom(tester, iso: 'DE');
    await tester.tap(find.text('Pokračovat →'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Vyprávím →'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(narrationHintKey));
    await tester.pumpAndSettle();
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.byKey(narrationNextKey));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Zavřít'));
    await tester.pumpAndSettle();

    final q = Telemetry.debugQueue;
    expect([for (final e in q) if (e.name == 'screen_view') e.props['screen']],
        ['globe', 'cast', 'task', 'problem', 'ending', 'osnova', 'narrate', 'globe']);
    Map<String, Object> one(String name) => q.singleWhere((e) => e.name == name).props;
    expect(one('compose_end'), allOf(containsPair('result', 'ok'), containsPair('step', 'osnova')));
    expect(one('narrate_start'), containsPair('source', 'curated'));
    expect(one('hint_show'), allOf(containsPair('beat', 'cast'), containsPair('source', 'template')));
    expect(one('narrate_end'), allOf(containsPair('result', 'ok'), containsPair('beat', 4), containsPair('hints', 1)));
    expect(q.where((e) => e.name == 'activation'), hasLength(1));
  });
}
