import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:rag_embed/rag_embed.dart';
import 'package:test/test.dart';

Float32List _f32(String b64) => base64Decode(b64).buffer.asFloat32List();

void main() {
  test('quantizeInt8 matches Python bytes, including .5 rounding edges', () {
    final cases = (jsonDecode(
            File('test/fixtures/quantize.json').readAsStringSync()) as List)
        .cast<Map>();
    for (final c in cases) {
      final want = Int8List.fromList(base64Decode(c['int8'] as String));
      expect(quantizeInt8(_f32(c['v'] as String)), want);
    }
  });

  test('meanPoolNormalize averages rows and returns a unit vector', () {
    final h = Float32List.fromList([1, 2, 3, 3, 2, 1]); // seq 2 × dim 3
    final v = meanPoolNormalize(h, 2, 3);
    expect(v[0], closeTo(0.57735, 1e-5));
    expect(cosine(v, [1, 1, 1]), closeTo(1, 1e-6));
  });
}
