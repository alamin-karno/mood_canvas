import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for simple key-value persistence.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);
}
