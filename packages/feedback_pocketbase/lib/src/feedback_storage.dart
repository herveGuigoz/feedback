/// A Dart Storage Client Interface
abstract class FeedbackStorageInterface {
  /// Returns value for the provided [key].
  Future<String?> read(String key);

  /// Writes the provided [key], [value] pair asynchronously.
  /// Optionally, you can provide an [expireIn] duration to expire the key.
  Future<void> write({required String key, required String value, Duration? expireIn});

  /// Deletes the provided [key] asynchronously.
  Future<void> delete(String key);
}

final class InMemoryFeedbackStorage implements FeedbackStorageInterface {
  InMemoryFeedbackStorage() : _storage = {};

  final Map<String, String> _storage;

  @override
  Future<String?> read(String key) => Future.value(_storage[key]);

  @override
  Future<void> write({required String key, required String value, Duration? expireIn}) {
    _storage[key] = value;
    return Future.value();
  }

  @override
  Future<void> delete(String key) {
    _storage.remove(key);
    return Future.value();
  }
}
