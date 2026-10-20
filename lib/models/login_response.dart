import 'usuario.dart';

// o que a api devolve no login: token, refresh token e o usuario
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final Usuario usuario;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.usuario,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['token']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      usuario: Usuario.fromJson(
        Map<String, dynamic>.from(
          json['user'] as Map,
        ),
      ),
    );
  }
}
