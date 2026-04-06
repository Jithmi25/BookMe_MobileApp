enum AppEnvironment { dev, prod }

class AppEnvironmentConfig {
  const AppEnvironmentConfig._();

  static const String _envKey = 'APP_ENV';
  static const String _defaultEnv = 'dev';

  static AppEnvironment get current {
    const rawValue = String.fromEnvironment(_envKey, defaultValue: _defaultEnv);

    return AppEnvironment.values.firstWhere(
      (environment) => environment.name == rawValue,
      orElse: () => AppEnvironment.dev,
    );
  }

  static bool get isDev => current == AppEnvironment.dev;
}
