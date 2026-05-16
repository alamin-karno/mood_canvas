import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'injection.dart';
import 'src/app.dart';
import 'src/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await AppConfig.init();
  await setupInjection();
  runApp(const App());
}
