import 'dart:convert';
import 'dart:io';

import 'package:content_key/content_key.dart';
import 'package:test/test.dart';

// Shared with the Go package — see internal/contentkey/contentkey_test.go
// for how it's (re)generated. If this path breaks, the package moved.
const _goldenPath = '../../../internal/contentkey/testdata/golden.json';

void main() {
  final golden = jsonDecode(File(_goldenPath).readAsStringSync()) as List;

  group('golden (must match Go byte-for-byte)', () {
    for (final raw in golden) {
      final c = raw as Map<String, dynamic>;
      test(c['name'] as String, () {
        final b = ContentBase(
          kind: c['kind'] as String,
          lang: c['lang'] as String,
          inputs: ((c['inputs'] as Map?) ?? const {}).cast<String, Object?>(),
        );
        final v = ContentVariant(
          modelId: c['model_id'] as String,
          styleId: (c['style_id'] as String?) ?? '',
          modelVer: (c['model_ver'] as String?) ?? '',
        );
        expect(basePreimage(b), c['base_preimage']);
        final r = contentKey(b, v);
        expect(r.keyBase, c['key_base']);
        expect(variantPreimage(r.keyBase, v), c['variant_preimage']);
        expect(r.key, c['key']);
        expect(contentSeed(r.keyBase), c['seed']);
      });
    }
  });

  test('variants of the same content share key_base and seed', () {
    const base = ContentBase(kind: 'scene_image', lang: 'cs', inputs: {'motif_id': 'm1'});
    final t0 = contentKey(base, const ContentVariant(modelId: 'flux-schnell', styleId: 'watercolor', modelVer: 'a'));
    final t1 = contentKey(base, const ContentVariant(modelId: 'flux-dev', styleId: 'watercolor', modelVer: 'b'));
    expect(t0.keyBase, t1.keyBase);
    expect(t0.key, isNot(t1.key));
    expect(contentSeed(t0.keyBase), contentSeed(t1.keyBase));
    expect(contentSeed(t0.keyBase), greaterThanOrEqualTo(0));
  });

  test('each variant field changes the key', () {
    final kb = 'ab' * 32;
    final ref = contentVariantKey(kb, const ContentVariant(modelId: 'flux-dev', styleId: 'watercolor', modelVer: 'v1'));
    expect(contentVariantKey(kb, const ContentVariant(modelId: 'flux-schnell', styleId: 'watercolor', modelVer: 'v1')), isNot(ref));
    expect(contentVariantKey(kb, const ContentVariant(modelId: 'flux-dev', styleId: 'papercut', modelVer: 'v1')), isNot(ref));
    expect(contentVariantKey(kb, const ContentVariant(modelId: 'flux-dev', styleId: 'watercolor', modelVer: 'v2')), isNot(ref));
  });

  test('map key order does not matter', () {
    final a = ContentBase(kind: 'x', lang: 'en', inputs: {'a': 1, 'b': 2, 'c': ['p', 'q']});
    final b = ContentBase(kind: 'x', lang: 'en', inputs: {'c': ['p', 'q'], 'b': 2, 'a': 1});
    expect(contentKeyBase(a), contentKeyBase(b));
  });

  test('array order matters', () {
    final a = ContentBase(kind: 'x', lang: 'en', inputs: {'tags': ['a', 'b']});
    final b = ContentBase(kind: 'x', lang: 'en', inputs: {'tags': ['b', 'a']});
    expect(contentKeyBase(a), isNot(contentKeyBase(b)));
  });

  group('rejects', () {
    final bad = <String, ContentBase>{
      'missing kind': const ContentBase(kind: '', lang: 'en'),
      'missing lang': const ContentBase(kind: 'x', lang: '  '),
      'non-integral': const ContentBase(kind: 'x', lang: 'en', inputs: {'n': 1.5}),
      'NaN': const ContentBase(kind: 'x', lang: 'en', inputs: {'n': double.nan}),
      'uppercase key': const ContentBase(kind: 'x', lang: 'en', inputs: {'MotifId': '1'}),
      'dashed key': const ContentBase(kind: 'x', lang: 'en', inputs: {'motif-id': '1'}),
      'nested bad key': const ContentBase(kind: 'x', lang: 'en', inputs: {'ok': {'Bad': 1}}),
    };
    bad.forEach((name, b) {
      test(name, () => expect(() => contentKeyBase(b), throwsA(isA<ContentKeyException>())));
    });

    test('missing model_id', () {
      expect(() => contentVariantKey('ab' * 32, const ContentVariant(modelId: ' ')), throwsA(isA<ContentKeyException>()));
    });
    test('bad key_base', () {
      expect(() => contentVariantKey('not-hex', const ContentVariant(modelId: 'm')), throwsA(isA<ContentKeyException>()));
      expect(() => contentVariantKey('AB' * 32, const ContentVariant(modelId: 'm')), throwsA(isA<ContentKeyException>()));
    });
  });

  test('seed validation', () {
    expect(() => contentSeed('abc'), throwsA(isA<ContentKeyException>()));
    expect(() => contentSeed('zz' * 32), throwsA(isA<ContentKeyException>()));
  });

  test('assetPath', () {
    final key = 'ab' * 32;
    expect(assetPath('Scene_Image', key, '.webp'), 'assets/scene_image/ab/$key.webp');
  });

  test('normalize whitespace set', () {
    final input = String.fromCharCodes([0x00a0, 0x61, 0x0085, 0x62, 0x3000, 0x63, 0xfeff, 0x64, 0x2003, 0x65]);
    expect(normalize(input), 'a b c d e');
  });
}
