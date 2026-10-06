import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../models/dashboard.dart';

class _C {
  const _C._();

  static const text = Color(0xFF1F2937);
  static const muted = Color(0xFF6B7280);
  static const primary = Color(0xFF2563EB);
  static const border = Color(0xFFE5E7EB);
}

/// Tela inicial do administrador.
///
/// Consome `GET /api/dashboard` através do [DashboardController]
/// (registrado no InitialBinding). Não faz nenhuma chamada HTTP aqui.
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController _controller = Get.find<DashboardController>();
  final AuthController _auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  /// O controller dá `rethrow` em caso de erro; aqui o erro já fica
  /// guardado em `errorMessage`, então só evitamos exceção não tratada.
  Future<void> _carregar() async {
    try {
      await _controller.carregar();
    } catch (_) {}
  }

  Future<void> _atualizar() async {
    await _carregar();

    if (_controller.errorMessage.value.isNotEmpty &&
        _controller.dashboard.value != null) {
      Get.snackbar(
        'Não foi possível atualizar',
        _controller.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _emBreve(int index) {
    if (index == 0) return;

    Get.snackbar(
      'Em breve',
      'Esta área ainda não está disponível.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Obx(() {
          final dados = _controller.dashboard.value;

          if (dados == null) {
            if (_controller.errorMessage.value.isNotEmpty) {
              return _Erro(
                mensagem: _controller.errorMessage.value,
                onRetry: _carregar,
              );
            }

            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _atualizar,
            child: _Conteudo(
              dados: dados,
              nome: _auth.currentUser.value?.nome ?? 'Coordenador',
              onSair: _auth.logout,
            ),
          );
        }),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        selectedIndex: 0,
        onDestinationSelected: _emBreve,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_outlined, color: _C.primary),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Patrimônios',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Professores',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// Conteúdo
// ---------------------------------------------------------------

class _Conteudo extends StatelessWidget {
  final Dashboard dados;
  final String nome;
  final VoidCallback onSair;

  const _Conteudo({
    required this.dados,
    required this.nome,
    required this.onSair,
  });

  @override
  Widget build(BuildContext context) {
    // Maior categoria primeiro.
    final categorias = dados.categorias.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bem-vindo de volta,',
                    style: TextStyle(color: _C.muted, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Olá, $nome',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _C.text,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                tooltip: 'Sair',
                onPressed: onSair,
                icon: const Icon(Icons.logout, color: _C.text, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.35,
          children: [
            _StatCard(
              label: 'Total',
              value: dados.totalBens,
              icon: Icons.archive_outlined,
              color: const Color(0xFF2563EB),
              bg: const Color(0xFFE0EAFF),
            ),
            _StatCard(
              label: 'Disponíveis',
              value: dados.disponiveis,
              icon: Icons.check,
              color: const Color(0xFF16A34A),
              bg: const Color(0xFFDCFCE7),
            ),
            _StatCard(
              label: 'Em uso',
              value: dados.emUso,
              icon: Icons.person_outline,
              color: const Color(0xFFD97706),
              bg: const Color(0xFFFEF3C7),
            ),
            _StatCard(
              label: 'Manutenção',
              value: dados.emManutencao,
              icon: Icons.build_outlined,
              color: const Color(0xFFDC2626),
              bg: const Color(0xFFFEE2E2),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Bens por categoria',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _C.text,
          ),
        ),
        const SizedBox(height: 12),
        if (categorias.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Nenhum patrimônio cadastrado',
                style: TextStyle(color: _C.muted),
              ),
            ),
          )
        else
          ...categorias.map(
            (c) => _CategoriaTile(
              nome: c.key,
              quantidade: c.value,
              total: dados.totalBens,
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color bg;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _C.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _C.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriaTile extends StatelessWidget {
  final String nome;
  final int quantidade;
  final int total;

  const _CategoriaTile({
    required this.nome,
    required this.quantidade,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final proporcao = total > 0 ? (quantidade / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  nome,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _C.text,
                  ),
                ),
              ),
              Text(
                '$quantidade',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: _C.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: proporcao.toDouble(),
              minHeight: 6,
              backgroundColor: const Color(0xFFE0EAFF),
              color: _C.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Erro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onRetry;

  const _Erro({required this.mensagem, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: _C.muted),
            const SizedBox(height: 12),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _C.muted),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}