import 'package:get/get.dart';

import '../models/professor.dart';
import '../services/professor_service.dart';

class ProfessorController extends GetxController {
  final ProfessorService service;

  final RxBool isLoading = false.obs;
  final RxList<Professor> professores =
      <Professor>[].obs;
  final Rxn<Professor> professorSelecionado =
      Rxn<Professor>();
  final RxString errorMessage = ''.obs;

  ProfessorController(this.service);

  Future<void> carregarProfessores() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      professores.assignAll(
        await service.listar(),
      );
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> carregarProfessor(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      professorSelecionado.value =
          await service.buscar(id);
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
    String? matricula,
    String? departamento,
  }) async {
    isLoading.value = true;

    try {
      await service.cadastrar(
        nome: nome,
        email: email,
        senha: senha,
        telefone: telefone,
        matricula: matricula,
        departamento: departamento,
      );

      await carregarProfessores();
    } finally {
      isLoading.value = false;
    }
  }
}
