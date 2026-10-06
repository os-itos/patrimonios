import 'package:flutter/material.dart';
import '/models/patrimonio.dart';

class PatrimonioDetailView extends StatelessWidget {
  final Patrimonio patrimonio;

  const PatrimonioDetailView({super.key, required this.patrimonio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
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
            // IMAGEM / ÍCONE
            Container(
              height: 135,
              width: double.infinity,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
              ),

              child: const Center(
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
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NOME
                  campo('Nome', patrimonio.descricao),

                  // TOMBAMENTO
                  campo('Código/Tombamento', patrimonio.tombamento),

                  // CATEGORIA
                  campo('Categoria', patrimonio.categoria),

                  // MARCA
                  campo('Marca', patrimonio.marca ?? 'Não informado'),

                  // NÚMERO DE SÉRIE
                  campo(
                    'Número de Série',
                    patrimonio.numeroSerie ?? 'Não informado',
                  ),

                  // LOCALIZAÇÃO
                  campo(
                    'Localização',
                    patrimonio.localizacao ?? 'Não informado',
                  ),

                  // STATUS
                  campo('Status', patrimonio.status.label),

                  // PROFESSOR
                  campo(
                    'Professor ID',
                    patrimonio.professorId?.toString() ?? 'Não atribuído',
                  ),

                  // DATA DA ATRIBUIÇÃO
                  campo(
                    'Data de Atribuição',
                    patrimonio.dataAtribuicao != null
                        ? formatarData(patrimonio.dataAtribuicao!)
                        : 'Não informado',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // BOTÕES
            Row(
              children: [
                // EDITAR
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Tela de edição
                    },

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,

                      side: const BorderSide(color: Colors.blue),

                      padding: const EdgeInsets.symmetric(vertical: 15),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    child: const Text('Editar'),
                  ),
                ),

                const SizedBox(width: 10),

                // EXCLUIR
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Excluir patrimônio
                    },

                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,

                      side: const BorderSide(color: Colors.red),

                      padding: const EdgeInsets.symmetric(vertical: 15),

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

                  padding: const EdgeInsets.symmetric(vertical: 15),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                child: const Text(
                  'Devolver Equipamento',

                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CAMPO
  Widget campo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            titulo,

            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 3),

          Text(
            valor,

            style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
          ),

          const SizedBox(height: 5),

          Divider(color: Colors.grey.shade300, height: 1),
        ],
      ),
    );
  }

  // FORMATA A DATA
  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }
}
