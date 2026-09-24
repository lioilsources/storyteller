/// Dart port of `internal/contentkey` (Go). Read that package's doc comment
/// for the canonical format — this file follows it rule by rule and must
/// stay byte-identical with it. Both are pinned by
/// `internal/contentkey/testdata/golden.json`.
///
///   key_base = sha256(kind, lang, normalized_inputs)           — the content
///   key      = sha256(key_base, model_id, style_id, model_ver)  — one variant
///   seed     = first 8 bytes of key_base (63-bit)               — shared by all variants
///
/// VM-only: `contentSeed` relies on 64-bit ints (Flutter iOS/Android are
/// fine; Flutter web's 53-bit doubles are not).
library content_key;

import 'dart:convert';

import 'package:crypto/crypto.dart';

const _baseVersion = 'storyteller-content-key/v2';
const _variantVersion = 'storyteller-content-variant/v2';

final _keyPattern = RegExp(r'^[a-z0-9_]+$');
final _hexPattern = RegExp(r'^[0-9a-f]{64}$');

/// A piece of content independent of how it's rendered. Mirrors Go's
/// `contentkey.Base`.
class ContentBase {
  const ContentBase({
    required this.kind,
    required this.lang,
    this.inputs = const {},
  });

  final String kind;
  final String lang;
  final Map<String, Object?> inputs;
}

/// One rendering of a [ContentBase]: model × style × model version.
/// Mirrors Go's `contentkey.Variant`.
class ContentVariant {
  const ContentVariant({
    required this.modelId,
    this.styleId = '',
    this.modelVer = '',
  });

  final String modelId;
  final String styleId;
  final String modelVer;
}

class ContentKeyException implements Exception {
  ContentKeyException(this.message);
  final String message;
  @override
  String toString() => 'ContentKeyException: $message';
}

/// Lowercase hex sha256 of [basePreimage].
String contentKeyBase(ContentBase b) => _hashHex(basePreimage(b));

/// Lowercase hex sha256 of [variantPreimage].
String contentVariantKey(String keyBase, ContentVariant v) =>
    _hashHex(variantPreimage(keyBase, v));

/// (key_base, key) in one call.
({String keyBase, String key}) contentKey(ContentBase b, ContentVariant v) {
  final keyBase = contentKeyBase(b);
  return (keyBase: keyBase, key: contentVariantKey(keyBase, v));
}

/// First 8 bytes of key_base, big-endian, top bit cleared → non-negative.
/// Pass key_base, not the variant key — every variant of the same content
/// shares one seed on purpose.
int contentSeed(String keyBase) {
  if (!_hexPattern.hasMatch(keyBase)) {
    throw ContentKeyException('key_base must be 64 lowercase hex chars');
  }
  var v = 0;
  for (var i = 0; i < 16; i += 2) {
    v = (v << 8) | int.parse(keyBase.substring(i, i + 2), radix: 16);
  }
  return v & 0x7fffffffffffffff;
}

/// Immutable CDN path, OFFLINE_PLAN §2.2: assets/{kind}/{key[0:2]}/{key}.{ext}
String assetPath(String kind, String key, String ext) {
  final e = ext.startsWith('.') ? ext.substring(1) : ext;
  return 'assets/${normalize(kind)}/${key.substring(0, 2)}/$key.$e';
}

/// The exact string hashed by [contentKeyBase].
String basePreimage(ContentBase b) {
  final kind = normalize(b.kind);
  if (kind.isEmpty) throw ContentKeyException('kind is required');
  final lang = normalize(b.lang);
  if (lang.isEmpty) throw ContentKeyException('lang is required');

  final out = StringBuffer()
    ..write(_baseVersion)
    ..write('\nkind:')
    ..write(kind)
    ..write('\nlang:')
    ..write(lang)
    ..write('\ninputs:');
  _writeObject(out, b.inputs);
  return out.toString();
}

/// The exact string hashed by [contentVariantKey].
String variantPreimage(String keyBase, ContentVariant v) {
  if (!_hexPattern.hasMatch(keyBase)) {
    throw ContentKeyException('key_base must be 64 lowercase hex chars');
  }
  final model = normalize(v.modelId);
  if (model.isEmpty) throw ContentKeyException('model_id is required');
  return '$_variantVersion'
      '\nbase:$keyBase'
      '\nmodel:$model'
      '\nstyle:${normalize(v.styleId)}'
      '\nmodel_ver:${normalize(v.modelVer)}';
}

String _hashHex(String s) => sha256.convert(utf8.encode(s)).toString();

/// Trim, collapse whitespace runs to one space, lowercase. Same explicit
/// whitespace set as Go's `isSpace` — not Dart's `\s`, not Go's
/// `unicode.IsSpace`, but their union, so neither built-in can drift.
String normalize(String s) {
  final out = StringBuffer();
  var inToken = false;
  var needSpace = false;
  for (final r in s.runes) {
    if (_isSpace(r)) {
      if (inToken) {
        needSpace = true;
        inToken = false;
      }
      continue;
    }
    if (needSpace) {
      out.write(' ');
      needSpace = false;
    }
    out.writeCharCode(r);
    inToken = true;
  }
  return out.toString().toLowerCase();
}

bool _isSpace(int r) {
  switch (r) {
    case 0x09: // \t
    case 0x0A: // \n
    case 0x0B: // \v
    case 0x0C: // \f
    case 0x0D: // \r
    case 0x20:
    case 0x0085:
    case 0x00A0:
    case 0x1680:
    case 0x2028:
    case 0x2029:
    case 0x202F:
    case 0x205F:
    case 0x3000:
    case 0xFEFF:
      return true;
  }
  return r >= 0x2000 && r <= 0x200A;
}

void _writeObject(StringBuffer b, Map<String, Object?> m) {
  final keys = m.keys.toList();
  for (final k in keys) {
    if (!_keyPattern.hasMatch(k)) {
      throw ContentKeyException('input key "$k" must match ^[a-z0-9_]+\$');
    }
  }
  keys.sort(); // [a-z0-9_] only, so code-unit order == Go's byte order

  b.write('{');
  var first = true;
  for (final k in keys) {
    final v = m[k];
    if (v == null) continue;
    if (v is String && normalize(v).isEmpty) continue;
    if (!first) b.write(',');
    first = false;
    _writeString(b, k);
    b.write(':');
    _writeValue(b, v);
  }
  b.write('}');
}

void _writeValue(StringBuffer b, Object? v) {
  if (v == null) {
    b.write('null');
  } else if (v is bool) {
    b.write(v ? 'true' : 'false');
  } else if (v is String) {
    _writeString(b, normalize(v));
  } else if (v is int) {
    b.write(v.toString());
  } else if (v is double) {
    if (v.isNaN || v.isInfinite || v != v.truncateToDouble()) {
      throw ContentKeyException('non-integral number $v not allowed in inputs');
    }
    if (v.abs() > 9007199254740992.0) {
      throw ContentKeyException('number $v exceeds 2^53 and would lose precision');
    }
    b.write(v.toInt().toString());
  } else if (v is List) {
    b.write('[');
    for (var i = 0; i < v.length; i++) {
      if (i > 0) b.write(',');
      _writeValue(b, v[i]);
    }
    b.write(']');
  } else if (v is Map) {
    _writeObject(b, v.cast<String, Object?>());
  } else {
    throw ContentKeyException('unsupported input value type ${v.runtimeType}');
  }
}

void _writeString(StringBuffer b, String s) {
  b.write('"');
  for (final r in s.runes) {
    switch (r) {
      case 0x22: // "
        b.write(r'\"');
      case 0x5C: // \
        b.write(r'\\');
      case 0x0A:
        b.write(r'\n');
      case 0x0D:
        b.write(r'\r');
      case 0x09:
        b.write(r'\t');
      default:
        if (r < 0x20) {
          b.write(r'\u');
          b.write(r.toRadixString(16).padLeft(4, '0'));
        } else {
          b.writeCharCode(r);
        }
    }
  }
  b.write('"');
}
