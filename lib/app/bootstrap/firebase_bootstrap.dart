import 'package:book_me_mobile_app/app/config/app_environment.dart';
import 'package:book_me_mobile_app/app/config/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    if (FirebaseConfig.hasRequiredConfiguration) {
      await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
      return;
    }

    if (!kIsWeb) {
      try {
        await Firebase.initializeApp();
        debugPrint(
          'Firebase initialized from native platform config '
          '(GoogleService-Info.plist / google-services.json).',
        );
        return;
      } catch (_) {
        if (!AppEnvironmentConfig.isDev) {
          FirebaseConfig.validateCurrentEnvironment();
        }
      }
    }

    if (AppEnvironmentConfig.isDev) {
      debugPrint(
        'Skipping Firebase initialization in dev. Missing defines: '
        '${FirebaseConfig.missingRequiredKeys.join(', ')}',
      );
      return;
    }

    FirebaseConfig.validateCurrentEnvironment();
  }
}
