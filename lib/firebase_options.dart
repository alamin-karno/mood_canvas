import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Firebase options loaded from `.env`.
/// Run `flutterfire configure` to generate platform-specific overrides.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        return web;
    }
  }

  static FirebaseOptions get web => _fromEnv();

  static FirebaseOptions get android => _fromEnv();

  static FirebaseOptions get ios => _fromEnv();

  static FirebaseOptions get macos => _fromEnv();

  static FirebaseOptions _fromEnv() {
    return FirebaseOptions(
      apiKey: dotenv.get('FIREBASE_API_KEY'),
      appId: dotenv.get('FIREBASE_APP_ID'),
      messagingSenderId: dotenv.get('FIREBASE_MESSAGING_SENDER_ID'),
      projectId: dotenv.get('FIREBASE_PROJECT_ID'),
      authDomain: dotenv.get('FIREBASE_AUTH_DOMAIN'),
      storageBucket: dotenv.get('FIREBASE_STORAGE_BUCKET'),
    );
  }
}
