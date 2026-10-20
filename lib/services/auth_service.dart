import '../models/login_response.dart';
import '../models/usuario.dart';
import 'api_service.dart';

// rotas de autenticacao da api
class AuthService {
  final ApiService api;

  const AuthService(this.api);

  Future<LoginResponse> login({
    required String email,
    required String senha,
  }) async {
    final response = await api.post(
      '/auth/login',
      body: {
        'email': email,
        'password': senha,
      },
      requiresAuth: false,
    );

    return LoginResponse.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  // dados do usuario logado
  Future<Usuario> me() async {
    final response = await api.get('/profile');

    return Usuario.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  // recuperacao de senha (o codigo aparece no console da api)
  Future<void> recuperarSenha({
    required String email,
  }) async {
    await api.post(
      '/auth/forgot-password',
      body: {
        'email': email,
      },
      requiresAuth: false,
    );
  }

  Future<void> resetarSenha({
    required String email,
    required String codigo,
    required String novaSenha,
  }) async {
    await api.post(
      '/auth/reset-password',
      body: {
        'email': email,
        'code': codigo,
        'newPassword': novaSenha,
      },
      requiresAuth: false,
    );
  }

  // a api precisa do refresh token pra encerrar a sessao
  Future<void> logout(String? refreshToken) async {
    await api.post(
      '/auth/logout',
      body: {
        'refreshToken': refreshToken ?? '',
      },
    );
  }
}
