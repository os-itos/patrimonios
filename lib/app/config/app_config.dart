import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig._();

  // da pra trocar a url no flutter run usando o --dart-define
  // (chave api_base_url, em maiusculo) com o ip da maquina
  static const String _baseUrlDefinida = String.fromEnvironment('API_BASE_URL');

  // no emulador android o localhost é o proprio emulador, pra chegar no pc é 10.0.2.2
  // no chrome, windows e ios o localhost funciona normal
  static String get baseUrl {
    if (_baseUrlDefinida.isNotEmpty) return _baseUrlDefinida;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8081/api';
    }

    return 'http://localhost:8081/api';
  }

  // se a api nao responder nesse tempo a gente mostra erro
  static const Duration requestTimeout = Duration(seconds: 15);
}
