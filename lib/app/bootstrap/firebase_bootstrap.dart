import 'package:book_me_mobile_app/app/config/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseBootstrap {
  const FirebaseBootstrap._();

  static Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    FirebaseConfig.validateCurrentEnvironment();

    await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  }
}
