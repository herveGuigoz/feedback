import 'package:shared_preferences/shared_preferences.dart';

/// A Dart Storage Client Interface
abstract class StorageInterface {
  /// Returns value for the provided [key].
  String? read(String key);

  /// Writes the provided [key], [value] pair asynchronously.
  /// Optionally, you can provide an [expireIn] duration to expire the key.
  Future<void> write({required String key, required String value, Duration? expireIn});

  /// Deletes the provided [key] asynchronously.
  Future<void> delete(String key);
}

final class PersistentStorage implements StorageInterface {
  const PersistentStorage({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  int get _now => DateTime.now().millisecondsSinceEpoch;

  @override
  String? read(String key) {
    final value = _sharedPreferences.getString(key);
    final expireAt = _sharedPreferences.getInt('${key}_expire_at');

    if (value == null || (expireAt != null && expireAt < _now)) {
      return null;
    }

    return value;
  }

  @override
  Future<void> write({required String key, required String value, Duration? expireIn}) async {
    if (expireIn != null) {
      await _sharedPreferences.setInt('${key}_expire_at', _now + expireIn.inMilliseconds);
    }
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _sharedPreferences.remove(key);
  }
}
