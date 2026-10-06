import 'package:get/get.dart';

import '../models/historico.dart';
import '../models/patrimonio.dart';
import '../services/patrimonio_service.dart';

class PatrimonioController extends GetxController {
  final PatrimonioService service;

  final RxBool isLoading = false.obs;
  final RxList<Patrimonio> patrimonios =
      <Patrimonio>[].obs;
  final Rxn<Patrimonio> patrimonioSelecionado =
      Rxn<Patrimonio>();
  final RxList<Historico> historico =
      <Historico>[].obs;

  final Rxn<StatusPatrimonio> statusFiltro =
      Rxn<StatusPatrimonio>();
  final RxString categoriaFiltro = ''.obs;
  final RxString busca = ''.obs;
  final RxString errorMessage = ''.obs;

  PatrimonioController(this.service);

  Future<void> carregarPatrimonios() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      patrimonios.assignAll(
        await service.listar(
          status: statusFiltro.value,
          categoria: categoriaFiltro.value,
          busca: busca.value,
        ),
      );
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> buscarPatrimonio(int id) async {
    isLoading.value = true;

    try {
      patrimonioSelecionado.value =
          await service.buscar(id);
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cadastrar({
    required String tombamento,
    required String descricao,
    required String categoria,
    String? marca,
    String? numeroSerie,
    String? localizacao,
    StatusPatrimonio status =
        StatusPatrimonio.disponivel,
  }) async {
    isLoading.value = true;

    try {
      await service.cadastrar(
        tombamento: tombamento,
        descricao: descricao,
        categoria: categoria,
        marca: marca,
        numeroSerie: numeroSerie,
        localizacao: localizacao,
        status: status,
      );

      await carregarPatrimonios();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> atualizar({
    required int id,
    String? descricao,
    String? categoria,
    String? marca,
    String? numeroSerie,
    String? localizacao,
    StatusPatrimonio? status,
  }) async {
    isLoading.value = true;

    try {
      await service.atualizar(
        id: id,
        descricao: descricao,
        categoria: categoria,
        marca: marca,
        numeroSerie: numeroSerie,
        localizacao: localizacao,
        status: status,
      );

      await carregarPatrimonios();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> excluir(int id) async {
    isLoading.value = true;

    try {
      await service.excluir(id);
      await carregarPatrimonios();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> atribuir({
    required int patrimonioId,
    required int professorId,
  }) async {
    isLoading.value = true;

    try {
      await service.atribuir(
        patrimonioId: patrimonioId,
        professorId: professorId,
      );

      await carregarPatrimonios();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> devolver({
    required int patrimonioId,
    String? motivo,
  }) async {
    isLoading.value = true;

    try {
      await service.devolver(
        patrimonioId: patrimonioId,
        motivo: motivo,
      );

      await carregarPatrimonios();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> carregarHistorico(int patrimonioId) async {
    isLoading.value = true;

    try {
      historico.assignAll(
        await service.historico(patrimonioId),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void definirStatus(StatusPatrimonio? status) {
    statusFiltro.value = status;
  }

  void definirCategoria(String categoria) {
    categoriaFiltro.value = categoria.trim();
  }

  void definirBusca(String valor) {
    busca.value = valor;
  }

  void limparFiltros() {
    statusFiltro.value = null;
    categoriaFiltro.value = '';
    busca.value = '';
  }
}
