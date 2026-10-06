import 'package:get/get.dart';

import '../models/usuario.dart';
import '../services/perfil_service.dart';

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

      usuario.value = await service.buscar();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    isLoading.value = true;

    try {
      await service.alterarSenha(
        senhaAtual: senhaAtual,
        novaSenha: novaSenha,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
