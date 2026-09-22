import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/patrimonio_dados.dart';
import '../services/patrimonio_service.dart';

class PatrimonioController extends GetxController {
  final PatrimonioService _service = Get.put(PatrimonioService());

  // Estados reativos
  final patrimonios = <Patrimonio>[].obs;
  final patrimonioSelecionado = Rxn<Patrimonio>();
  final isLoading = false.obs;
  final termoBusca = ''.obs;

  @override
  void onInit() {
    super.onInit();
    carregarPatrimonios();
  }

  // 1. LISTAR
  Future<void> carregarPatrimonios() async {
    isLoading.value = true;
    final response = await _service.listar();

    if (response.isOk && response.body != null) {
      patrimonios.assignAll(response.body!);
    } else {
      _mostrarNotificacao('Erro', 'Falha ao conectar com o servidor', Colors.red);
    }
    isLoading.value = false;
  }

  // 2. PESQUISAR (Filtro reativo para uso direto na View)
  List<Patrimonio> get patrimoniosFiltrados {
    if (termoBusca.value.trim().isEmpty) {
      return patrimonios;
    }
    final query = termoBusca.value.toLowerCase();
    return patrimonios.where((p) {
      final nome = p.nome.toLowerCase();
      final codigo = p.codigo?.toLowerCase() ?? '';
      return nome.contains(query) || codigo.contains(query);
    }).toList();
  }

  void pesquisar(String query) {
    termoBusca.value = query;
  }

  // 3. VISUALIZAR
  Future<void> visualizar(int id) async {
    isLoading.value = true;
    final response = await _service.obterPorId(id);

    if (response.isOk && response.body != null) {
      patrimonioSelecionado.value = response.body!;
    } else {
      // Fallback local se o endpoint por ID não for utilizado
      patrimonioSelecionado.value = patrimonios.firstWhereOrNull((p) => p.id == id);
      if (patrimonioSelecionado.value == null) {
        _mostrarNotificacao('Erro', 'Patrimônio não encontrado', Colors.red);
      }
    }
    isLoading.value = false;
  }

  // 4. CADASTRAR
  Future<void> adicionar(Patrimonio patrimonio) async {
    isLoading.value = true;
    final response = await _service.cadastrar(patrimonio);

    if (response.isOk && response.body != null) {
      patrimonios.add(response.body!);
      Get.back();
      _mostrarNotificacao('Sucesso', 'Patrimônio cadastrado com sucesso!', Colors.green);
    } else {
      _mostrarNotificacao('Erro', 'Falha ao cadastrar patrimônio', Colors.red);
    }
    isLoading.value = false;
  }

  // 5. EDITAR
  Future<void> editar(int id, Patrimonio patrimonio) async {
    isLoading.value = true;
    final response = await _service.atualizar(id, patrimonio);

    if (response.isOk && response.body != null) {
      final index = patrimonios.indexWhere((p) => p.id == id);
      if (index != -1) {
        patrimonios[index] = response.body!;
      }
      if (patrimonioSelecionado.value?.id == id) {
        patrimonioSelecionado.value = response.body!;
      }
      Get.back();
      _mostrarNotificacao('Sucesso', 'Patrimônio atualizado com sucesso!', Colors.green);
    } else {
      _mostrarNotificacao('Erro', 'Falha ao atualizar patrimônio', Colors.red);
    }
    isLoading.value = false;
  }

  // 6. EXCLUIR
  Future<void> remover(int id) async {
    isLoading.value = true;
    final response = await _service.excluir(id);

    if (response.isOk) {
      patrimonios.removeWhere((p) => p.id == id);
      if (patrimonioSelecionado.value?.id == id) {
        patrimonioSelecionado.value = null;
      }
      _mostrarNotificacao('Sucesso', 'Patrimônio excluído!', Colors.orange);
    } else {
      _mostrarNotificacao('Erro', 'Falha ao excluir patrimônio', Colors.red);
    }
    isLoading.value = false;
  }

  // Helper privado para padronizar exibição de Snackbars
  void _mostrarNotificacao(String titulo, String mensagem, Color corFundo) {
    Get.snackbar(
      titulo,
      mensagem,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: corFundo,
      colorText: Colors.white,
    );
  }
}