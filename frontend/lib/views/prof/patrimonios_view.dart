import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/patrimonio_controller.dart';
import '../../models/patrimonio.dart';
import 'patrimonio_detalhes_view.dart';

/// Tela "Meus Patrimônios" (RF08) - somente leitura (RN03).
class ProfessorPatrimoniosView extends StatefulWidget {
  const ProfessorPatrimoniosView({super.key});

  @override
  State<ProfessorPatrimoniosView> createState() =>
      _ProfessorPatrimoniosViewState();
}

class _ProfessorPatrimoniosViewState
    extends State<ProfessorPatrimoniosView> {
  final PatrimonioController controller =
      Get.find<PatrimonioController>();

  @override
  void initState() {
    super.initState();
    controller.limparFiltros();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      await controller.carregarPatrimonios();
    } catch (_) {
      // a mensagem de erro fica em controller.errorMessage
    }
  }

  List<Patrimonio> get _filtrados {
    final termo = controller.busca.value.trim().toLowerCase();
    if (termo.isEmpty) return controller.patrimonios;

    return controller.patrimonios.where((p) {
      return p.descricao.toLowerCase().contains(termo) ||
          p.tombamento.toLowerCase().contains(termo) ||
          p.categoria.toLowerCase().contains(termo);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          'Meus Patrimônios',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _CampoBusca(onChanged: controller.definirBusca),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.patrimonios.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.patrimonios.isEmpty) {
                return _MensagemEstado(
                  icone: Icons.wifi_off_rounded,
                  titulo: 'Não foi possível carregar',
                  descricao: controller.errorMessage.value,
                  acao: _carregar,
                );
              }

              final itens = _filtrados;

              if (itens.isEmpty) {
                return _MensagemEstado(
                  icone: Icons.inventory_2_outlined,
                  titulo: controller.busca.value.isEmpty
                      ? 'Nenhum patrimônio atribuído'
                      : 'Nenhum resultado encontrado',
                  descricao: controller.busca.value.isEmpty
                      ? 'Quando um bem for atribuído a você, ele aparecerá aqui.'
                      : 'Tente buscar por outro nome ou código.',
                );
              }

              return RefreshIndicator(
                onRefresh: _carregar,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: itens.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final patrimonio = itens[index];
                    return PatrimonioCard(
                      patrimonio: patrimonio,
                      onTap: () => Get.to(
                        () => ProfessorPatrimonioDetalhesView(
                          patrimonio: patrimonio,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar:
          const ProfessorBottomNav(indiceAtual: 1),
    );
  }
}

class _CampoBusca extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _CampoBusca({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Buscar patrimônio...',
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF6B7280),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB)),
        ),
      ),
    );
  }
}

/// Card reutilizável de patrimônio.
class PatrimonioCard extends StatelessWidget {
  final Patrimonio patrimonio;
  final VoidCallback? onTap;

  const PatrimonioCard({
    super.key,
    required this.patrimonio,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patrimonio.descricao,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                patrimonio.tombamento,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoriaBadge(texto: patrimonio.categoria),
                  StatusBadge(status: patrimonio.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge azul da categoria.
class CategoriaBadge extends StatelessWidget {
  final String texto;

  const CategoriaBadge({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return _Badge(
      texto: texto,
      fundo: const Color(0xFFEAF1FF),
      cor: const Color(0xFF1D4ED8),
    );
  }
}

/// Badge de status. Para o professor, "em uso" é exibido como "Atribuído".
class StatusBadge extends StatelessWidget {
  final StatusPatrimonio status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case StatusPatrimonio.emUso:
        return const _Badge(
          texto: 'Atribuído',
          fundo: Color(0xFFFDEFC3),
          cor: Color(0xFFD97706),
          borda: Color(0xFFFCE29A),
        );
      case StatusPatrimonio.disponivel:
        return const _Badge(
          texto: 'Disponível',
          fundo: Color(0xFFDCFCE7),
          cor: Color(0xFF15803D),
        );
      case StatusPatrimonio.emManutencao:
        return const _Badge(
          texto: 'Em manutenção',
          fundo: Color(0xFFFEE2E2),
          cor: Color(0xFFDC2626),
        );
    }
  }
}

class _Badge extends StatelessWidget {
  final String texto;
  final Color fundo;
  final Color cor;
  final Color? borda;

  const _Badge({
    required this.texto,
    required this.fundo,
    required this.cor,
    this.borda,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(8),
        border: borda == null ? null : Border.all(color: borda!),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: cor,
        ),
      ),
    );
  }
}

class _MensagemEstado extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;
  final VoidCallback? acao;

  const _MensagemEstado({
    required this.icone,
    required this.titulo,
    required this.descricao,
    this.acao,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 48, color: const Color(0xFF9CA3AF)),
            const SizedBox(height: 12),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            if (acao != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: acao,
                child: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Barra de navegação inferior do professor (Início / Patrimônios / Perfil).
class ProfessorBottomNav extends StatelessWidget {
  final int indiceAtual;

  const ProfessorBottomNav({super.key, required this.indiceAtual});

  void _ir(int indice) {
    if (indice == indiceAtual) return;

    switch (indice) {
      case 0:
        Get.offAllNamed(AppRoutes.professor);
        break;
      case 1:
        Get.offAllNamed(AppRoutes.professorPatrimonios);
        break;
      case 2:
        Get.offAllNamed(AppRoutes.professorPerfil);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final ativo = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ativo
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF6B7280),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final ativo = states.contains(WidgetState.selected);
            return IconThemeData(
              color: ativo
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF6B7280),
            );
          }),
        ),
        child: NavigationBar(
          height: 64,
          elevation: 0,
          selectedIndex: indiceAtual,
          onDestinationSelected: _ir,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_outlined),
              label: 'Início',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_outlined),
              label: 'Patrimônios',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_outline),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}