import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:mood_canvas/injection.dart';
import 'package:mood_canvas/src/app.dart';
import 'package:mood_canvas/src/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  await AppConfig.init();
  await setupInjection();

  runApp(const App());
}
