import '../models/usuario.dart';
import 'api_service.dart';

// rotas do perfil do usuario logado
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

  // a api troca a senha na mesma rota do perfil
  // e nem pede a senha atual
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
