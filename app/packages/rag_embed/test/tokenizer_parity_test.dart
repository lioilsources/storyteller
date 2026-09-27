// Token ids must equal the HF tokenizer's, or the ONNX model sees different
// input than sentence-transformers did and the vector spaces drift apart
// silently (RAG_PLAN §8.1). Fixture: test/fixtures/token_ids.json, generated
// from intfloat/multilingual-e5-small's tokenizer.json.
import 'dart:convert';
import 'dart:io';

import 'package:rag_embed/rag_embed.dart';
import 'package:test/test.dart';

final _tokenizerJson = Platform.environment['E5_TOKENIZER_JSON'] ??
    '/Volumes/YOTTA/Ai/models/storyteller/e5-small/tokenizer.json';

void main() {
  final skip = File(_tokenizerJson).existsSync()
      ? false
      : 'tokenizer.json not found — set E5_TOKENIZER_JSON';

  test('ids match the HF tokenizer on every fixture case', () async {
    final tok = await E5Tokenizer.fromJsonFile(_tokenizerJson);
    final fixture = jsonDecode(
        File('test/fixtures/token_ids.json').readAsStringSync()) as Map;
    final cases = (fixture['cases'] as List).cast<Map>();
    final mismatches = <String>[];
    for (final c in cases) {
      final want = (c['ids'] as List).cast<int>();
      final got = tok.encodeRaw(c['text'] as String);
      if (got.length != want.length ||
          Iterable.generate(want.length).any((i) => got[i] != want[i])) {
        mismatches.add('${jsonEncode(c['text'])}\n  want $want\n  got  $got');
      }
    }
    expect(mismatches, isEmpty,
        reason: '${mismatches.length}/${cases.length} differ:\n'
            '${mismatches.take(8).join('\n')}');
  }, skip: skip);
}
