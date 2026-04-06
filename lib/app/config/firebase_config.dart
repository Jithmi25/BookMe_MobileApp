import 'package:book_me_mobile_app/app/config/app_environment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  const FirebaseConfig._();

  static FirebaseOptions get currentPlatform {
    switch (AppEnvironmentConfig.current) {
      case AppEnvironment.dev:
        return _devOptions;
      case AppEnvironment.prod:
        return _prodOptions;
    }
  }

  static void validateCurrentEnvironment() {
    final options = currentPlatform;

    final missingKeys = <String>[];

    if (options.apiKey.isEmpty) {
      missingKeys.add(_devApiKey);
    }
    if (options.projectId.isEmpty) {
      missingKeys.add(_devProjectId);
    }
    if (options.messagingSenderId.isEmpty) {
      missingKeys.add(_devMessagingSenderId);
    }
    if (options.appId.isEmpty) {
      missingKeys.add(_activeAppIdKey);
    }

    if (missingKeys.isNotEmpty) {
      throw StateError(
        'Missing Firebase config for ${AppEnvironmentConfig.current.name}: '
        '${missingKeys.join(', ')}. '
        'Pass values using --dart-define.',
      );
    }
  }

  static FirebaseOptions get _devOptions {
    return FirebaseOptions(
      apiKey: const String.fromEnvironment(_devApiKey, defaultValue: ''),
      appId: _devAppId,
      messagingSenderId: const String.fromEnvironment(
        _devMessagingSenderId,
        defaultValue: '',
      ),
      projectId: const String.fromEnvironment(_devProjectId, defaultValue: ''),
      storageBucket: const String.fromEnvironment(
        _devStorageBucket,
        defaultValue: '',
      ),
    );
  }

  static FirebaseOptions get _prodOptions {
    return _devOptions;
  }

  static String get _activeAppIdKey {
    if (kIsWeb) {
      return _devWebAppId;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _devAndroidAppId;
      case TargetPlatform.iOS:
        return _devIosAppId;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return _devWebAppId;
    }
  }

  static String get _devAppId {
    if (kIsWeb) {
      return const String.fromEnvironment(_devWebAppId, defaultValue: '');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const String.fromEnvironment(_devAndroidAppId, defaultValue: '');
      case TargetPlatform.iOS:
        return const String.fromEnvironment(_devIosAppId, defaultValue: '');
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return const String.fromEnvironment(_devWebAppId, defaultValue: '');
    }
  }
}

const String _devApiKey = 'FIREBASE_API_KEY_DEV';
const String _devProjectId = 'FIREBASE_PROJECT_ID_DEV';
const String _devMessagingSenderId = 'FIREBASE_MESSAGING_SENDER_ID_DEV';
const String _devStorageBucket = 'FIREBASE_STORAGE_BUCKET_DEV';
const String _devAndroidAppId = 'FIREBASE_ANDROID_APP_ID_DEV';
const String _devIosAppId = 'FIREBASE_IOS_APP_ID_DEV';
const String _devWebAppId = 'FIREBASE_WEB_APP_ID_DEV';
