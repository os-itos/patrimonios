import 'package:get/get.dart';

import '../models/usuario.dart';
import '../services/perfil_service.dart';

// dados do usuario logado e alteracao de perfil e senha
class PerfilController extends GetxController {
  final PerfilService service;

  final RxBool isLoading = false.obs;
  final Rxn<Usuario> usuario = Rxn<Usuario>();
  final RxString errorMessage = ''.obs;

  PerfilController(this.service);

  Future<void> carregar() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      usuario.value = await service.buscar();
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> atualizar({
    String? nome,
    String? telefone,
  }) async {
    isLoading.value = true;

    try {
      await service.atualizar(
        nome: nome,
        telefone: telefone,
      );

      // busca de novo pra tela mostrar o que ficou salvo
      usuario.value = await service.buscar();
    } finally {
      isLoading.value = false;
    }
  }

  // a api nao confere a senha atual, ela so recebe a senha nova
  // mas a tela continua pedindo a atual pra pessoa confirmar
  Future<void> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    isLoading.value = true;

    try {
      await service.alterarSenha(
        novaSenha: novaSenha,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
