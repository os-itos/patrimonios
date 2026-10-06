import 'usuario.dart';

class LoginResponse {
  final String accessToken;
  final String tokenType;
  final Usuario usuario;

  const LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.usuario,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'bearer',
      usuario: Usuario.fromJson(
        Map<String, dynamic>.from(
          json['usuario'] as Map,
        ),
      ),
    );
  }
}
