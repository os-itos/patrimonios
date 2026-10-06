import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/utils/date_utils.dart';
import '../../models/patrimonio.dart';
import 'patrimonios_view.dart';

/// Tela "Detalhes do Item" do professor - somente visualização (RN03).
class ProfessorPatrimonioDetalhesView extends StatelessWidget {
  final Patrimonio patrimonio;

  const ProfessorPatrimonioDetalhesView({
    super.key,
    required this.patrimonio,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final nomeProfessor = auth.currentUser.value?.nome;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: Get.back,
        ),
        title: const Text(
          'Detalhes do Item',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE5E7EB)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _Cabecalho(status: patrimonio.status),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                _Campo(rotulo: 'Nome', valor: patrimonio.descricao),
                _Campo(
                  rotulo: 'Código/Tombamento',
                  valor: patrimonio.tombamento,
                ),
                _Campo(rotulo: 'Categoria', valor: patrimonio.categoria),
                _Campo(rotulo: 'Marca', valor: patrimonio.marca),
                _Campo(
                  rotulo: 'Número de Série',
                  valor: patrimonio.numeroSerie,
                ),
                _Campo(
                  rotulo: 'Localização',
                  valor: patrimonio.localizacao,
                ),
                _Campo(
                  rotulo: 'Data de Atribuição',
                  valor: AppDateUtils.formatDate(
                    patrimonio.dataAtribuicao,
                  ),
                ),
                _Campo(
                  rotulo: 'Responsável',
                  valor: nomeProfessor == null
                      ? 'Você'
                      : 'Você ($nomeProfessor)',
                  ultimo: true,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          const ProfessorBottomNav(indiceAtual: 1),
    );
  }
}

class _Cabecalho extends StatelessWidget {
  final StatusPatrimonio status;

  const _Cabecalho({required this.status});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 125,
        color: const Color(0xFFE5E7EB),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.inventory_2_outlined,
                size: 56,
                color: Color(0xFF9CA3AF),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: StatusBadge(status: status),
            ),
            const Positioned(
              top: 10,
              right: 10,
              child: _SomenteVisualizacao(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SomenteVisualizacao extends StatelessWidget {
  const _SomenteVisualizacao();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: const Text(
        'Somente Visualização',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFDC2626),
        ),
      ),
    );
  }
}

/// Linha rótulo + valor com divisor inferior.
class _Campo extends StatelessWidget {
  final String rotulo;
  final String? valor;
  final bool ultimo;

  const _Campo({
    required this.rotulo,
    required this.valor,
    this.ultimo = false,
  });

  @override
  Widget build(BuildContext context) {
    final texto =
        (valor == null || valor!.trim().isEmpty) ? '-' : valor!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border: ultimo
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFE5E7EB)),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rotulo,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
    );
  }
}