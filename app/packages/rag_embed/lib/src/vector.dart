import 'dart:math' as math;
import 'dart:typed_data';

/// e5 pooling: mean over the token axis of `last_hidden_state`, then L2
/// normalisation — what sentence-transformers does for this model. [hidden]
/// is row-major `[seqLen, dim]` for a single, unpadded sequence.
Float32List meanPoolNormalize(Float32List hidden, int seqLen, int dim) {
  final out = Float64List(dim);
  for (var t = 0; t < seqLen; t++) {
    final row = t * dim;
    for (var i = 0; i < dim; i++) {
      out[i] += hidden[row + i];
    }
  }
  var norm = 0.0;
  for (var i = 0; i < dim; i++) {
    out[i] /= seqLen;
    norm += out[i] * out[i];
  }
  norm = math.sqrt(norm);
  return Float32List.fromList([for (final x in out) norm == 0 ? 0.0 : x / norm]);
}

/// int8 contract shared with rag/rag/embed.py `quantize_int8`:
/// `round(x * 127)` clamped to ±127, stored as signed bytes. Python's
/// `round` is round-half-to-even (`round(2.5) == 2`), Dart's `round()` is
/// half-away-from-zero — using the latter would flip a byte whenever
/// `x * 127` lands exactly on .5.
Int8List quantizeInt8(List<double> v) {
  final out = Int8List(v.length);
  for (var i = 0; i < v.length; i++) {
    final q = _roundHalfEven(v[i] * 127.0);
    out[i] = q > 127 ? 127 : (q < -127 ? -127 : q);
  }
  return out;
}

int _roundHalfEven(double x) {
  final f = x.floorToDouble();
  final diff = x - f;
  if (diff > 0.5) return f.toInt() + 1;
  if (diff < 0.5) return f.toInt();
  final i = f.toInt();
  return i.isEven ? i : i + 1;
}

double cosine(List<double> a, List<double> b) {
  var dot = 0.0, na = 0.0, nb = 0.0;
  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    na += a[i] * a[i];
    nb += b[i] * b[i];
  }
  return (na == 0 || nb == 0) ? 0 : dot / math.sqrt(na * nb);
}
