import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/patrimonio_controller.dart';
import '../../models/patrimonio.dart';

/// Tela de listagem de patrimônios (admin).
/// Rota: [AppRoutes.adminPatrimonios].
class PatrimonioListView extends StatefulWidget {
  const PatrimonioListView({super.key});

  @override
  State<PatrimonioListView> createState() => _PatrimonioListViewState();
}

class _PatrimonioListViewState extends State<PatrimonioListView> {
  final PatrimonioController controller = Get.find<PatrimonioController>();
  final TextEditingController _buscaController = TextEditingController();
  Timer? _debounce;

  static const _background = Color(0xFFF3F5F9);
  static const _border = Color(0xFFE3E7EE);
  static const _title = Color(0xFF1F2937);
  static const _subtitle = Color(0xFF6B7280);
  static const _blue = Color(0xFF2563EB);
  static const _blueLight = Color(0xFFEAF1FF);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    try {
      await controller.carregarPatrimonios();
    } catch (_) {
      // O erro fica em controller.errorMessage.
    }
  }

  void _onBuscaChanged(String valor) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      controller.definirBusca(valor);
      _carregar();
    });
  }

  Future<void> _abrirDetalhes(Patrimonio patrimonio) async {
    await Get.toNamed(
      AppRoutes.adminDetalhesPatrimonio,
      arguments: patrimonio,
    );
    _carregar();
  }

  Future<void> _cadastrar() async {
    await Get.toNamed(AppRoutes.adminCadastrarPatrimonio);
    _carregar();
  }

  void _abrirFiltros() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            final atual = controller.statusFiltro.value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por status',
                  style: TextStyle(
                    color: _title,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Todos'),
                      selected: atual == null,
                      onSelected: (_) => controller.definirStatus(null),
                    ),
                    ...StatusPatrimonio.values.map(
                      (s) => ChoiceChip(
                        label: Text(_statusStyle(s).label),
                        selected: atual == s,
                        onSelected: (_) => controller.definirStatus(s),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.limparFiltros();
                          _buscaController.clear();
                          Get.back();
                          _carregar();
                        },
                        child: const Text('Limpar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Get.back();
                          _carregar();
                        },
                        child: const Text('Aplicar'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Text(
          'Patrimônios',
          style: TextStyle(
            color: _title,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: _cadastrar,
              customBorder: const CircleBorder(),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _buildSearchField(),
          ),
          Expanded(child: _buildList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 12, right: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: _subtitle),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _buscaController,
              onChanged: _onBuscaChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: _title, fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Buscar patrimônio...',
                hintStyle: TextStyle(color: _subtitle, fontSize: 15),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
              ),
            ),
          ),
          Obx(() {
            final filtrando = controller.statusFiltro.value != null;
            return IconButton(
              onPressed: _abrirFiltros,
              icon: Icon(
                Icons.tune,
                color: filtrando ? _blue : _blue.withValues(alpha: 0.8),
              ),
              style: filtrando
                  ? IconButton.styleFrom(backgroundColor: _blueLight)
                  : null,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
      final itens = controller.patrimonios;

      if (controller.isLoading.value && itens.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty && itens.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: _subtitle),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _carregar,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _carregar,
        child: itens.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      'Nenhum patrimônio encontrado.',
                      style: TextStyle(color: _subtitle),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: itens.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _buildCard(itens[index]),
              ),
      );
    });
  }

  Widget _buildCard(Patrimonio patrimonio) {
    final status = _statusStyle(patrimonio.status);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _abrirDetalhes(patrimonio),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patrimonio.descricao,
                style: const TextStyle(
                  color: _title,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                patrimonio.tombamento,
                style: const TextStyle(color: _subtitle, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTag(patrimonio.categoria, _blueLight, _blue),
                  _buildTag(status.label, status.background, status.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _StatusStyle _statusStyle(StatusPatrimonio status) {
    switch (status) {
      case StatusPatrimonio.disponivel:
        return const _StatusStyle(
          'Disponível',
          Color(0xFF16A34A),
          Color(0xFFDCFCE7),
        );
      case StatusPatrimonio.emUso:
        return const _StatusStyle(
          'Atribuído',
          Color(0xFFD97706),
          Color(0xFFFDEFC8),
        );
      case StatusPatrimonio.emManutencao:
        return const _StatusStyle(
          'Em Manutenção',
          Color(0xFFDC2626),
          Color(0xFFFEE2E2),
        );
    }
  }

  Widget _buildTag(String label, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: _blue,
        unselectedItemColor: _subtitle,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.admin);
              break;
            case 2:
              Get.offAllNamed(AppRoutes.adminProfessores);
              break;
            case 3:
              Get.offAllNamed(AppRoutes.professorPerfil);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Patrimônios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Professores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
class _StatusStyle {
  final String label;
  final Color color;
  final Color background;

  const _StatusStyle(this.label, this.color, this.background);
}

