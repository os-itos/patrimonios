import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../controllers/patrimonio_controller.dart';
import '../../models/patrimonio.dart';

// detalhes do patrimonio pro coordenador, com as acoes
class PatrimonioDetailView extends StatelessWidget {
  final Patrimonio patrimonio;

  const PatrimonioDetailView({super.key, required this.patrimonio});

  bool get _emUso => patrimonio.status == StatusPatrimonio.emUso;

  // se ta disponivel vai pra tela de atribuir, se ta em uso vai pra devolver
  // se deu certo fecha os detalhes pra lista recarregar
  Future<void> _atribuirOuDevolver(BuildContext context) async {
    final navigator = Navigator.of(context);

    final concluido = await Get.toNamed(
      _emUso
          ? AppRoutes.adminDevolverPatrimonio
          : AppRoutes.adminAtribuirPatrimonio,
      arguments: patrimonio,
    );

    // aqui usa o pop do navigator e nao o back do getx, porque o snackbar
    // de sucesso ainda ta aberto e o back ia fechar so ele
    if (concluido == true) navigator.pop();
  }

  // pede confirmacao antes de excluir
  Future<void> _excluir(BuildContext context) async {
    final navigator = Navigator.of(context);

    final confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Excluir patrimônio'),
        content: Text('Deseja excluir "${patrimonio.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await Get.find<PatrimonioController>().excluir(patrimonio.id);
      navigator.pop();
      Get.snackbar(
        'Sucesso',
        'Patrimônio excluído.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Erro',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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
            // imagem / icone
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

            // card dos dados
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
                  // nome
                  campo('Nome', patrimonio.nome),

                  // tombamento
                  campo('Código/Tombamento', patrimonio.tombamento),

                  // categoria
                  campo('Categoria', patrimonio.categoria),

                  // marca
                  campo('Marca', patrimonio.marca ?? 'Não informado'),

                  // numero de série
                  campo(
                    'Número de Série',
                    patrimonio.numeroSerie ?? 'Não informado',
                  ),

                  // localizacao
                  campo(
                    'Localização',
                    patrimonio.localizacao ?? 'Não informado',
                  ),

                  // status
                  campo('Status', patrimonio.status.label),

                  // professor
                  campo(
                    'Professor',
                    patrimonio.professorNome ??
                        patrimonio.professorId?.toString() ??
                        'Não atribuído',
                  ),

                  // data da atribuicao
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

            // botoes
            Row(
              children: [
                // editar
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.snackbar(
                      'Em breve',
                      'A edição de patrimônio ainda não está disponível.',
                      snackPosition: SnackPosition.BOTTOM,
                    ),

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

                // excluir
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _excluir(context),

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

            // botao de atribuir ou devolver (muda conforme o status)
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                // atribuir so vale pra item disponivel e devolver so pra item em uso,
                // nos outros status o botao fica desativado
                onPressed: _emUso ||
                        patrimonio.status == StatusPatrimonio.disponivel
                    ? () => _atribuirOuDevolver(context)
                    : null,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 15),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                child: Text(
                  _emUso ? 'Devolver Equipamento' : 'Atribuir a Professor',

                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // campo
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

  // formata a data
  String formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }
}
