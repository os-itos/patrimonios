import '../models/usuario.dart';
import 'api_service.dart';

class PerfilService {
  final ApiService api;

  const PerfilService(this.api);

  Future<Usuario> buscar() async {
    final response = await api.get('/profile');

    return Usuario.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  Future<void> atualizar({
    String? nome,
    String? telefone,
  }) async {
    await api.put(
      '/profile',
      body: {
        if (nome != null) 'nome': nome,
        if (telefone != null) 'telefone': telefone,
      },
    );
  }

  /// A API troca a senha pela mesma rota do perfil (`newPassword`)
  /// e não pede a senha atual.
  Future<void> alterarSenha({
    required String novaSenha,
  }) async {
    await api.put(
      '/profile',
      body: {
        'newPassword': novaSenha,
      },
    );
  }
}
