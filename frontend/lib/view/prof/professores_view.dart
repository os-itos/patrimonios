import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/professor_controller.dart';
import '../../models/professor.dart';

/// Rota: [AppRoutes.adminProfessores].
class ProfessorListView extends StatefulWidget {
  const ProfessorListView({super.key});

  @override
  State<ProfessorListView> createState() => _ProfessorListViewState();
}

class _ProfessorListViewState extends State<ProfessorListView> {
  final ProfessorController controller = Get.find<ProfessorController>();
  final TextEditingController _buscaController = TextEditingController();
  final RxString _busca = ''.obs;

  static const _background = Color(0xFFF3F5F9);
  static const _border = Color(0xFFE3E7EE);
  static const _title = Color(0xFF1F2937);
  static const _subtitle = Color(0xFF6B7280);
  static const _blue = Color(0xFF2563EB);
  static const _blueLight = Color(0xFFEAF1FF);
  static const _grayLight = Color(0xFFEEF0F4);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    try {
      await controller.carregarProfessores();
    } catch (_) {
    }
  }

  Future<void> _abrirDetalhes(Professor professor) async {
    await Get.toNamed(
      AppRoutes.adminDetalhesProfessor,
      arguments: professor,
    );
    _carregar();
  }

  Future<void> _cadastrar() async {
    await Get.toNamed(AppRoutes.adminCadastrarProfessor);
    _carregar();
  }
  List<Professor> _filtrar(List<Professor> lista) {
    final termo = _busca.value.trim().toLowerCase();
    if (termo.isEmpty) return lista;

    return lista
        .where(
          (p) =>
              p.nome.toLowerCase().contains(termo) ||
              p.email.toLowerCase().contains(termo) ||
              (p.matricula ?? '').toLowerCase().contains(termo),
        )
        .toList();
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
          'Professores',
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
              onChanged: (v) => _busca.value = v,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: _title, fontSize: 15),
              decoration: const InputDecoration(
                hintText: 'Buscar professor...',
                hintStyle: TextStyle(color: _subtitle, fontSize: 15),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
      final todos = controller.professores;
      final itens = _filtrar(todos);

      if (controller.isLoading.value && todos.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty && todos.isEmpty) {
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
                      'Nenhum professor encontrado.',
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

  Widget _buildCard(Professor professor) {
    final inicial =
        professor.nome.isNotEmpty ? professor.nome[0].toUpperCase() : '?';
    final nomeExibicao = professor.nome.toLowerCase().startsWith('prof')
        ? professor.nome
        : 'Prof. ${professor.nome}';
    final qtd = professor.quantidadePatrimonios;
    final temItens = qtd > 0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _abrirDetalhes(professor),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _blueLight,
                child: Text(
                  inicial,
                  style: const TextStyle(
                    color: _blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomeExibicao,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _title,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      professor.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _subtitle, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: temItens ? _blueLight : _grayLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$qtd itens',
                  style: TextStyle(
                    color: temItens ? _blue : _subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
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
        currentIndex: 2,
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
            case 1:
              Get.offAllNamed(AppRoutes.adminPatrimonios);
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
            label: 'Patrimônios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people_alt_outlined),
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