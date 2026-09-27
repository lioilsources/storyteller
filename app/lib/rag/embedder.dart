import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:rag_embed/rag_embed.dart';

/// On-device e5-small (STORYTELLER_RAG_PLAN.md §2.6): the same model the
/// packs were embedded with on the Python side, or query and stored vectors
/// live in different spaces. Tokenization and pooling come from
/// `packages/rag_embed`, which is tested byte-for-byte against Python; this
/// class only adds the ONNX session.
///
/// The model is `model_int8_emb.onnx`: int8 embedding table, fp32 matmuls.
/// Fully int8 weights failed the §8.1 gate (min cos 0.968 vs
/// sentence-transformers), per-channel int8 scraped past it on 10 samples
/// but not on 206 (0.989); this one holds at 0.9997.
class Embedder {
  Embedder._(this._tokenizer, this._session);

  static const modelAsset = 'assets/rag/e5_small_int8emb.onnx';
  static const tokenizerAsset = 'assets/rag/e5_tokenizer.json';
  static const dim = 384;

  final E5Tokenizer _tokenizer;
  final OrtSession _session;

  static Future<Embedder> load() async {
    final tokenizer = E5Tokenizer.fromJsonString(await rootBundle.loadString(tokenizerAsset));
    final session = await OnnxRuntime().createSessionFromAsset(modelAsset);
    return Embedder._(tokenizer, session);
  }

  /// L2-normalised 384-d vector for [text] with the e5 task [prefix].
  Future<Float32List> embed(String text, E5Prefix prefix) => embedRaw('${prefix.name}: $text');

  /// [text] already carries its `query: ` / `passage: ` prefix.
  Future<Float32List> embedRaw(String text) async {
    final ids = _tokenizer.encodeRaw(text);
    final n = ids.length;
    final inputIds = await OrtValue.fromList(Int64List.fromList(ids), [1, n]);
    final mask = await OrtValue.fromList(Int64List(n)..fillRange(0, n, 1), [1, n]);
    final outputs = await _session.run({'input_ids': inputIds, 'attention_mask': mask});
    try {
      final hidden = outputs['last_hidden_state']!;
      final flat = await hidden.asFlattenedList();
      return meanPoolNormalize(Float32List.fromList(flat.cast<num>().map((x) => x.toDouble()).toList()), n, dim);
    } finally {
      await inputIds.dispose();
      await mask.dispose();
      for (final v in outputs.values) {
        await v.dispose();
      }
    }
  }

  Future<void> close() => _session.close();
}
