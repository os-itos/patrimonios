import 'package:flutter/material.dart';
import '../../services/patrimonio_service.dart';
import '../../models/patrimonio_dados.dart';

class PatrimonioView extends StatefulWidget {
  const PatrimonioView({super.key});

  @override
  State<PatrimonioView> createState() => _PatrimonioViewState();
}

class _PatrimonioViewState extends State<PatrimonioView> {
  final PatrimonioService _service = PatrimonioService();
  List<Patrimonio> _patrimonios = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _service.onInit();
    _carregarPatrimonios();
  }

  Future<void> _carregarPatrimonios() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final response = await _service.listar();

    if (response.isOk && response.body != null) {
      setState(() {
        _patrimonios = response.body!;
        _carregando = false;
      });
    } else {
      setState(() {
        _erro = 'Erro ao carregar patrimônios: ${response.statusText}';
        _carregando = false;
      });
    }
  }

  Future<void> _excluirPatrimonio(int id) async {
    final response = await _service.excluir(id);
    if (response.isOk) {
      _carregarPatrimonios();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: ${response.statusText}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Patrimônios'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _carregarPatrimonios,
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_erro!, style: const TextStyle(color: Colors.red)),
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
      return const Center(child: Text('Nenhum patrimônio cadastrado.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _patrimonios.length,
      itemBuilder: (context, index) {
        final patrimonio = _patrimonios[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(
              patrimonio.nome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${patrimonio.local} • ${patrimonio.responsavel}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _excluirPatrimonio(patrimonio.id ?? 0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}