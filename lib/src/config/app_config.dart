import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/storage_service.dart';

class AppConfig {
  AppConfig._();

  static String get baseUrl => _getBaseUrl();

  static Future<void> init() async {
    await StorageService.instance.init();
  }

  static String _getBaseUrl() {
    return dotenv.get('API_BASE_URL', fallback: 'https://api.example.com');
  }
}
