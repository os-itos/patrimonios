import '../models/usuario.dart';
import 'api_service.dart';

class PerfilService {
  final ApiService api;

  const PerfilService(this.api);

  Future<Usuario> buscar() async {
    final response = await api.get('/me');

    return Usuario.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  Future<void> atualizar({
    String? nome,
    String? telefone,
  }) async {
    await api.put(
      '/me',
      body: {
        'nome': nome,
        'telefone': telefone,
      },
    );
  }

  Future<void> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    await api.put(
      '/me/senha',
      body: {
        'senha_atual': senhaAtual,
        'nova_senha': novaSenha,
      },
    );
  }
}
