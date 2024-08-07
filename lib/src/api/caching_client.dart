import 'dart:convert';

import 'package:http/http.dart';

/// This client has an internal in memory cache for http responses.
class CachingClient extends BaseClient {
  /// Creates an instance of the [CachingClient].
  ///
  /// By setting [maxAge], you can configure how long cached entries are saved,
  /// before an actual new HTTP request is being made.
  CachingClient({Client? inner, required this.maxAge})
      : inner = inner ?? Client();

  /// The wrapped client
  final Client inner;

  /// How old a cache entry is allowed to be, before it gets purged and replaced
  final Duration maxAge;

  final Map<Uri, _CacheEntry> _cache = {};

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final cacheEntry = _cache[request.url];
    if (cacheEntry == null) {
      return _sendAndSaveToCache(request);
    } else {
      // Cached Weather data isn't to horribly out of date
      if (DateTime.now().difference(cacheEntry.timeOfCreation) < maxAge) {
        return StreamedResponse(
          Stream.value(utf8.encode(cacheEntry.content)),
          200,
        );
      }
      return _sendAndSaveToCache(request);
    }
  }

  Future<StreamedResponse> _sendAndSaveToCache(BaseRequest request) async {
    final response = await inner.send(request);

    final newEntry =
        _CacheEntry(await response.stream.bytesToString(), DateTime.now());
    _cache[request.url] = newEntry;

    // Since the stream has been read, it can't be read another time.
    // Return a brand new object instead
    return StreamedResponse(
      Stream.value(utf8.encode(newEntry.content)),
      200,
    );
  }
}

class _CacheEntry {
  _CacheEntry(this.content, this.timeOfCreation);

  final String content;
  final DateTime timeOfCreation;
}
