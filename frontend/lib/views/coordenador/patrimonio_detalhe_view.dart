import 'package:flutter/material.dart';
import '/models/patrimonio_dados.dart';

class PatrimonioDetailView extends StatelessWidget {
  final Patrimonio patrimonio;

  const PatrimonioDetailView({
    super.key,
    required this.patrimonio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1F2937),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detalhes do Item',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEM
            Container(
              height: 135,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),
              child: patrimonio.imagem != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        patrimonio.imagem!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
            ),

            const SizedBox(height: 14),

            // CARD DOS DADOS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  campo(
                    'Nome',
                    patrimonio.nome,
                  ),
                  campo(
                    'Código/Tombamento',
                    patrimonio.codigo ?? 'Não informado',
                  ),
                  campo(
                    'Categoria',
                    patrimonio.categoria ?? 'Não informado',
                  ),
                  campo(
                    'Número de Série',
                    patrimonio.numeroSerie ?? 'Não informado',
                  ),
                  campo(
                    'Estado de Conservação',
                    patrimonio.estadoConservacao ?? 'Não informado',
                  ),
                  campo(
                    'Responsável Atual',
                    patrimonio.responsavel,
                  ),
                  campo(
                    'Observações',
                    patrimonio.observacoes ?? patrimonio.descricao,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // BOTÕES EDITAR E EXCLUIR
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Tela de edição
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(
                        color: Colors.blue,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Excluir patrimônio
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Excluir'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // DEVOLVER EQUIPAMENTO
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Devolver equipamento
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Devolver Equipamento',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 5),
          Divider(
            color: Colors.grey.shade300,
            height: 1,
          ),
        ],
      ),
    );
  }
}
