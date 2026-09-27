import 'dart:typed_data';

import 'package:dart_sentencepiece_tokenizer/dart_sentencepiece_tokenizer.dart';

/// e5 task prefixes — stored texts are `passage`, the transcript window is
/// `query`. Mixing them up costs ~10 points of retrieval quality (embed.py).
enum E5Prefix { query, passage }

/// multilingual-e5-small tokenization, byte-for-byte what the HF tokenizer
/// produces on the Python side: `<s> … </s>`, truncated to [maxLength]
/// with `</s>` kept as the last token.
class E5Tokenizer {
  E5Tokenizer(this._inner, {this.maxLength = 512});

  static Future<E5Tokenizer> fromJsonFile(String path) async =>
      E5Tokenizer(await TokenizerJsonLoader.fromJsonFile(path));

  static E5Tokenizer fromJsonString(String json) =>
      E5Tokenizer(TokenizerJsonLoader.fromJsonString(json));

  final dynamic _inner;
  final int maxLength;

  static const int bosId = 0; // <s>
  static const int eosId = 2; // </s>

  Int32List encode(String text, E5Prefix prefix) =>
      encodeRaw('${prefix.name}: $text');

  /// [text] already carries its prefix.
  Int32List encodeRaw(String text) {
    final Int32List ids = _inner.encode(text, addSpecialTokens: true).ids;
    if (ids.length <= maxLength) return ids;
    return Int32List(maxLength)
      ..setRange(0, maxLength - 1, ids)
      ..[maxLength - 1] = eosId;
  }
}
