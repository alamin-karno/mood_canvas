import 'package:flutter_web_plugins/url_strategy.dart';

import 'injection.dart';
import 'src/core/firebase/app_firebase.dart';
import 'src/imports/core_imports.dart';
import 'src/imports/packages_imports.dart';
import 'src/app.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  usePathUrlStrategy();

  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await AppFirebase.initialize();
  await AppConfig.init();
  await setupInjection();

  runApp(
    const LocalizationWrapper(
      child: StateWrapper(
        child: App(),
      ),
    ),
  );
}
