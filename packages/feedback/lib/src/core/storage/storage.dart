import 'package:shared_preferences/shared_preferences.dart';

/// A Dart Storage Client Interface
abstract class Storage {
  /// Returns value for the provided [key].
  String? read(String key);

  /// Writes the provided [key], [value] pair asynchronously.
  Future<void> write({required String key, required String value});
}

final class PersistentStorage implements Storage {
  const PersistentStorage({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  String? read(String key) {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    await _sharedPreferences.setString(key, value);
  }
}
