import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/patrimonio_dados.dart';
import '../../services/patrimonio_service.dart';

class PatrimoniosPage extends StatefulWidget {
  const PatrimoniosPage({super.key});

  @override
  State<PatrimoniosPage> createState() => _PatrimoniosPageState();
}

class _PatrimoniosPageState extends State<PatrimoniosPage> {
  final PatrimonioService _service = Get.put(PatrimonioService());
  List<Patrimonio> _patrimonios = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarPatrimonios();
  }

  Future<void> _carregarPatrimonios() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final response = await _service.listar();

    if (response.status.hasError) {
      setState(() {
        _erro = 'Erro ao carregar patrimônios: ${response.statusText}';
        _carregando = false;
      });
    } else {
      setState(() {
        _patrimonios = response.body ?? [];
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Patrimônios',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
              ),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: const CircleBorder(),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
        child: Column(
          children: [
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar patrimônio...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    onPressed: _carregarPatrimonios,
                    icon: const Icon(
                      Icons.refresh,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF6B7280),
        selectedFontSize: 9,
        unselectedFontSize: 9,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Patrimônios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Professores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_erro!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _carregarPatrimonios,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_patrimonios.isEmpty) {
      return const Center(child: Text('Nenhum patrimônio encontrado.'));
    }

    return ListView.builder(
      itemCount: _patrimonios.length,
      itemBuilder: (context, index) {
        final patrimonio = _patrimonios[index];
        return PatrimonioCard(patrimonio: patrimonio);
      },
    );
  }
}

class PatrimonioCard extends StatelessWidget {
  final Patrimonio patrimonio;

  const PatrimonioCard({super.key, required this.patrimonio});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            patrimonio.nome,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          if (patrimonio.codigo != null)
            Text(
              patrimonio.codigo!,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 10,
              ),
            ),
          const SizedBox(height: 6),
          Text(
            patrimonio.descricao,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _infoChip(Icons.place_outlined, patrimonio.local),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _infoChip(Icons.person_outline, patrimonio.responsavel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: const Color(0xFF2563EB)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              texto,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}