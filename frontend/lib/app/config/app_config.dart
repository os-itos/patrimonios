import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig._();

  /// Pode ser sobrescrito com:
  /// flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8081/api
  static const String _baseUrlDefinida = String.fromEnvironment('API_BASE_URL');

  /// No emulador Android, `localhost` é o próprio emulador; a máquina
  /// host é acessada por 10.0.2.2. Web, Windows e iOS usam localhost.
  static String get baseUrl {
    if (_baseUrlDefinida.isNotEmpty) return _baseUrlDefinida;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8081/api';
    }

    return 'http://localhost:8081/api';
  }

  static const Duration requestTimeout = Duration(seconds: 15);
}
