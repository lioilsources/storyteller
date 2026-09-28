import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

/// The network half of [PackRepository], behind an interface so tests
/// serve bytes from memory.
abstract interface class PackFetcher {
  Future<Uint8List> get(Uri url);

  /// Appends [url]'s bytes to [part], starting at `part.lengthSync()`
  /// (an HTTP Range request) so an interrupted download resumes.
  /// [onBytes] gets the total bytes on disk so far.
  Future<void> download(Uri url, File part, {void Function(int received)? onBytes});
}

class HttpPackFetcher implements PackFetcher {
  HttpPackFetcher({HttpClient? client}) : _client = client ?? (HttpClient()..connectionTimeout = const Duration(seconds: 15));

  final HttpClient _client;

  @override
  Future<Uint8List> get(Uri url) async {
    final req = await _client.getUrl(url);
    final res = await req.close().timeout(const Duration(seconds: 20));
    if (res.statusCode != HttpStatus.ok) {
      await res.drain<void>();
      throw HttpException('GET $url → ${res.statusCode}', uri: url);
    }
    final b = BytesBuilder(copy: false);
    await res.forEach(b.add);
    return b.takeBytes();
  }

  @override
  Future<void> download(Uri url, File part, {void Function(int received)? onBytes}) async {
    var have = part.existsSync() ? part.lengthSync() : 0;
    // GitHub release assets redirect to objects.githubusercontent.com;
    // HttpClient follows GET redirects and keeps the Range header.
    final req = await _client.getUrl(url);
    if (have > 0) req.headers.set(HttpHeaders.rangeHeader, 'bytes=$have-');
    final res = await req.close();
    if (res.statusCode == HttpStatus.requestedRangeNotSatisfiable) {
      await res.drain<void>();
      return; // already complete; the sha256 check decides
    }
    if (res.statusCode != HttpStatus.ok && res.statusCode != HttpStatus.partialContent) {
      await res.drain<void>();
      throw HttpException('GET $url → ${res.statusCode}', uri: url);
    }
    if (res.statusCode == HttpStatus.ok && have > 0) have = 0; // server ignored Range: start over
    final sink = part.openWrite(mode: have > 0 ? FileMode.append : FileMode.write);
    try {
      await for (final chunk in res) {
        sink.add(chunk);
        have += chunk.length;
        onBytes?.call(have);
      }
    } finally {
      await sink.close();
    }
  }
}
