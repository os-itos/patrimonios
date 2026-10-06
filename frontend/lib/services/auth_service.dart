import '../models/login_response.dart';
import '../models/usuario.dart';
import 'api_service.dart';

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
        'senha': senha,
      },
      requiresAuth: false,
    );

    return LoginResponse.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  Future<Usuario> me() async {
    final response = await api.get('/me');

    return Usuario.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  Future<void> recuperarSenha({
    required String email,
  }) async {
    await api.post(
      '/auth/recuperar-senha',
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
      '/auth/resetar-senha',
      body: {
        'email': email,
        'codigo': codigo,
        'nova_senha': novaSenha,
      },
      requiresAuth: false,
    );
  }

  Future<void> logout() async {
    await api.post('/auth/logout');
  }
}
