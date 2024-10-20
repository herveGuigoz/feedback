/// A Dart Storage Client Interface
abstract class FeedbackStorageInterface {
  /// Returns value for the provided [key].
  String? read(String key);

  /// Writes the provided [key], [value] pair asynchronously.
  /// Optionally, you can provide an [expireIn] duration to expire the key.
  Future<void> write({required String key, required String value, Duration? expireIn});

  /// Deletes the provided [key] asynchronously.
  Future<void> delete(String key);
}
