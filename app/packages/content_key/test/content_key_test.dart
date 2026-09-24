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
        final r = ContentKeyRequest(
          kind: c['kind'] as String,
          modelVer: (c['model_ver'] as String?) ?? '',
          style: (c['style'] as String?) ?? '',
          lang: c['lang'] as String,
          variant: (c['variant'] as int?) ?? 0,
          inputs: ((c['inputs'] as Map?) ?? const {}).cast<String, Object?>(),
        );
        expect(canonicalPreimage(r), c['preimage']);
        final key = contentKey(r);
        expect(key, c['key']);
        expect(contentSeed(key), c['seed']);
      });
    }
  });

  test('map key order does not matter', () {
    final a = ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'a': 1, 'b': 2, 'c': ['p', 'q']});
    final b = ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'c': ['p', 'q'], 'b': 2, 'a': 1});
    expect(contentKey(a), contentKey(b));
  });

  test('array order matters', () {
    final a = ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'tags': ['a', 'b']});
    final b = ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'tags': ['b', 'a']});
    expect(contentKey(a), isNot(contentKey(b)));
  });

  test('variant changes key, seed is non-negative', () {
    final k0 = contentKey(const ContentKeyRequest(kind: 'scene_image', lang: 'cs', inputs: {'m': '1'}));
    final k1 = contentKey(const ContentKeyRequest(kind: 'scene_image', lang: 'cs', variant: 1, inputs: {'m': '1'}));
    expect(k0, isNot(k1));
    expect(contentSeed(k0), greaterThanOrEqualTo(0));
    expect(contentSeed(k1), greaterThanOrEqualTo(0));
  });

  group('rejects', () {
    final bad = <String, ContentKeyRequest>{
      'missing kind': const ContentKeyRequest(kind: '', lang: 'en'),
      'missing lang': const ContentKeyRequest(kind: 'x', lang: '  '),
      'non-integral': const ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'n': 1.5}),
      'NaN': const ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'n': double.nan}),
      'uppercase key': const ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'MotifId': '1'}),
      'dashed key': const ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'motif-id': '1'}),
      'nested bad key': const ContentKeyRequest(kind: 'x', lang: 'en', inputs: {'ok': {'Bad': 1}}),
    };
    bad.forEach((name, r) {
      test(name, () => expect(() => contentKey(r), throwsA(isA<ContentKeyException>())));
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
