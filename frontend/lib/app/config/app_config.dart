class AppConfig {
  const AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8081/api',
  );

  static const Duration requestTimeout = Duration(seconds: 15);
}
