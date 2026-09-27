// RAG_PLAN §8.1 on the device: the vector the phone computes must match the
// one the pack was built with. Reference: assets/rag/embed_parity.json,
// generated on the Python side (sentence-transformers fp32 + ONNX Runtime
// with the same model file). Run on a simulator or a device:
//
//   flutter test integration_test/embed_parity_test.dart -d <device>
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rag_embed/rag_embed.dart';
import 'package:storyteller/rag/embedder.dart';

Float32List _f32(String b64) => base64Decode(b64).buffer.asFloat32List();

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('device embeddings match Python', (tester) async {
    final report = await tester.runAsync(() async {
      final fixture = jsonDecode(await rootBundle.loadString('assets/rag/embed_parity.json')) as Map;
      final cases = (fixture['cases'] as List).cast<Map>();
      final sw = Stopwatch()..start();
      final embedder = await Embedder.load();
      final loadMs = sw.elapsedMilliseconds;
      var minSt = 1.0, minOnnx = 1.0, bytesEqual = 0, maxByteDiff = 0;
      var worst = '';
      final perCall = <int>[];
      for (final c in cases) {
        final t0 = sw.elapsedMicroseconds;
        final v = await embedder.embedRaw(c['text'] as String);
        perCall.add(sw.elapsedMicroseconds - t0);
        final cst = cosine(v, _f32(c['st_fp32'] as String));
        final cox = cosine(v, _f32(c['onnx'] as String));
        if (cst < minSt) {
          minSt = cst;
          worst = c['text'] as String;
        }
        if (cox < minOnnx) minOnnx = cox;
        final q = quantizeInt8(v);
        final want = Int8List.fromList(base64Decode(c['int8'] as String));
        var same = true;
        for (var i = 0; i < q.length; i++) {
          final d = (q[i] - want[i]).abs();
          if (d != 0) same = false;
          if (d > maxByteDiff) maxByteDiff = d;
        }
        if (same) bytesEqual++;
      }
      await embedder.close();
      perCall.sort();
      return {
        'cases': cases.length,
        'model_load_ms': loadMs,
        'embed_ms_p50': perCall[perCall.length ~/ 2] / 1000,
        'embed_ms_p90': perCall[(perCall.length * 9) ~/ 10] / 1000,
        'min_cos_vs_sentence_transformers': minSt,
        'min_cos_vs_python_onnx': minOnnx,
        'int8_identical': '$bytesEqual/${cases.length}',
        'int8_max_byte_diff': maxByteDiff,
        'worst_text': worst.length > 60 ? worst.substring(0, 60) : worst,
      };
    });
    // ignore: avoid_print
    print('EMBED_PARITY ${jsonEncode(report)}');
    expect(report!['min_cos_vs_sentence_transformers'] as double, greaterThanOrEqualTo(0.99));
    expect(report['min_cos_vs_python_onnx'] as double, greaterThanOrEqualTo(0.9999));
  });
}
