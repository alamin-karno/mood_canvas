import 'package:mood_canvas/src/services/storage_service.dart';

class AppConfig {
  AppConfig._();

  static Future<void> init() async {
    await StorageService.instance.init();
  }
}
