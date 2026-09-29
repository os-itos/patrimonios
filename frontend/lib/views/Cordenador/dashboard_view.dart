import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 
// ---------------- CONFIG ----------------
const String _baseUrl = 'http://10.0.2.2:3000/api'; // troque pela sua API
const bool _usarMock = false; // true = mostra dados de exemplo sem API
// ----------------------------------------
 
class _C {
  static const text = Color(0xFF1F2937);
  static const muted = Color(0xFF6B7280);
  static const primary = Color(0xFF2563EB);
}
// ---------------- MODELOS ----------------
class _Atividade {
  final String titulo, descricao, tipo;
  final DateTime data;
  _Atividade(this.titulo, this.descricao, this.tipo, this.data);
 
  factory _Atividade.fromJson(Map<String, dynamic> j) => _Atividade(
        j['titulo'] ?? '',
        j['descricao'] ?? '',
        j['tipo'] ?? 'atribuido',
        DateTime.tryParse(j['data'] ?? '') ?? DateTime.now(),
      );
 
  String get dataFormatada {
    final n = DateTime.now();
    final diff = DateTime(n.year, n.month, n.day)
        .difference(DateTime(data.year, data.month, data.day))
        .inDays;
    final h =
        '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    if (diff == 0) return 'Hoje, $h';
    if (diff == 1) return 'Ontem, $h';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}, $h';
  }
}
 
class _Dados {
  final String nome;
  final int total, disponiveis, atribuidos, manutencao;
  final List<_Atividade> atividades;
  _Dados(this.nome, this.total, this.disponiveis, this.atribuidos,
      this.manutencao, this.atividades);
 
  factory _Dados.fromJson(Map<String, dynamic> j) => _Dados(
        j['coordenador'] ?? 'Coordenador',
        j['total'] ?? 0,
        j['disponiveis'] ?? 0,
        j['atribuidos'] ?? 0,
        j['manutencao'] ?? 0,
        (j['atividades'] as List? ?? [])
            .map((e) => _Atividade.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
// ---------------- API ----------------
// GET {_baseUrl}/dashboard
Future<_Dados> _buscarDados() async {
  if (_usarMock) {
    await Future.delayed(const Duration(milliseconds: 600));
    final agora = DateTime.now();
    return _Dados('Coordenador', 148, 84, 52, 12, [
      _Atividade('Notebook Dell atribuído', 'Destinatário: Prof. Maria Silva',
          'atribuido', DateTime(agora.year, agora.month, agora.day, 10, 30)),
      _Atividade(
          'Projetor Epson devolvido',
          'Devolvido por: Prof. João Souza',
          'devolvido',
          DateTime(agora.year, agora.month, agora.day, 16, 15)
              .subtract(const Duration(days: 1))),
    ]);
  }
  final r = await http.get(Uri.parse('$_baseUrl/dashboard'), headers: {
    'Content-Type': 'application/json',
    // 'Authorization': 'Bearer SEU_TOKEN',
  }).timeout(const Duration(seconds: 15));
  if (r.statusCode == 200) {
    return _Dados.fromJson(jsonDecode(utf8.decode(r.bodyBytes)));
  }
  throw Exception('Erro ${r.statusCode} ao carregar dados');
}
// ---------------- TELA ----------------
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
 
  @override
  State<DashboardView> createState() => _DashboardViewState();
}
 
class _DashboardViewState extends State<DashboardView> {
  late Future<_Dados> _future;
  int _tab = 0;
 
  @override
  void initState() {
    super.initState();
    _future = _buscarDados();
  }
 
  Future<void> _reload() async {
    final f = _buscarDados();
    setState(() => _future = f);
    try {
      await f;
    } catch (_) {}
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: FutureBuilder<_Dados>(
          future: _future,
          builder: (context, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (s.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off, size: 48, color: _C.muted),
                      const SizedBox(height: 12),
                      Text('${s.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: _C.muted)),
                      const SizedBox(height: 16),
                      FilledButton(
                          onPressed: _reload,
                          child: const Text('Tentar novamente')),
                    ],
                  ),
                ),
              );
            }
            return _conteudo(s.data!);
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_outlined, color: _C.primary),
              label: 'Início'),
          NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_outlined, color: _C.primary),
              label: 'Patrimônios'),
          NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people_outline, color: _C.primary),
              label: 'Professores'),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_outline, color: _C.primary),
              label: 'Perfil'),
        ],
      ),
    );
  }
 
  Widget _conteudo(_Dados d) {
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
          Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bem-vindo de volta,',
                      style: TextStyle(color: _C.muted, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('Olá, ${d.nome}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: _C.text)),
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
                      offset: Offset(0, 2))
                ],
              ),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, color: _C.text)),
            ),
          ]),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.35,
            children: [
              _StatCard('Total', d.total, Icons.archive_outlined,
                  const Color(0xFF2563EB), const Color(0xFFE0EAFF)),
              _StatCard('Disponíveis', d.disponiveis, Icons.check,
                  const Color(0xFF16A34A), const Color(0xFFDCFCE7)),
              _StatCard('Atribuídos', d.atribuidos, Icons.person_outline,
                  const Color(0xFFD97706), const Color(0xFFFEF3C7)),
              _StatCard('Manutenção', d.manutencao, Icons.build_outlined,
                  const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Atividades Recentes',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: _C.text)),
          const SizedBox(height: 12),
          if (d.atividades.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                  child: Text('Nenhuma atividade recente',
                      style: TextStyle(color: _C.muted))),
            )
          else
            ...d.atividades.map((a) => _ActivityTile(a)),
        ],
      ),
    );
  }
}
 
class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color, bg;
  const _StatCard(this.label, this.value, this.icon, this.color, this.bg);
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: _C.muted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: bg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Text('$value',
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w800, color: _C.text)),
        ],
      ),
    );
  }
}
 
class _ActivityTile extends StatelessWidget {
  final _Atividade a;
  const _ActivityTile(this.a);
 
  @override
  Widget build(BuildContext context) {
    final dev = a.tipo == 'devolvido';
    final color = dev ? const Color(0xFF16A34A) : const Color(0xFF2563EB);
    final bg = dev ? const Color(0xFFDCFCE7) : const Color(0xFFE0EAFF);
    final icon = dev ? Icons.assignment_return_outlined : Icons.share_outlined;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(a.titulo,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: _C.text)),
              const SizedBox(height: 2),
              Text(a.descricao,
                  style: const TextStyle(fontSize: 12.5, color: _C.muted)),
              const SizedBox(height: 2),
              Text(a.dataFormatada,
                  style: const TextStyle(
                      fontSize: 11.5, color: Color(0xFF9CA3AF))),
            ],
          ),
        ),
      ]),
    );
  }
}