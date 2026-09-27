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

  test('cosineInt8 agrees with float cosine on quantized unit vectors', () {
    final a = meanPoolNormalize(Float32List.fromList([0.3, -0.2, 0.9, 0.1]), 1, 4);
    final b = meanPoolNormalize(Float32List.fromList([0.25, -0.1, 0.8, 0.3]), 1, 4);
    expect(cosineInt8(quantizeInt8(a), quantizeInt8(b)), closeTo(cosine(a, b), 1e-2));
    expect(cosineInt8(quantizeInt8(a), quantizeInt8(a)), closeTo(1, 1e-9));
  });
}
