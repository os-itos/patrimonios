import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/patrimonio.dart';
import '../../../controllers/patrimonio_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../app/routes/app_routes.dart';

class PatrimonioDetailView extends StatefulWidget {
  final Patrimonio patrimonio;

  const PatrimonioDetailView({
    super.key,
    required this.patrimonio,
  });

  @override
  State<PatrimonioDetailView> createState() =>
      _PatrimonioDetailViewState();
}

class _PatrimonioDetailViewState
    extends State<PatrimonioDetailView> {
  final PatrimonioController patrimonioController =
      Get.find<PatrimonioController>();

  final AuthController authController =
      Get.find<AuthController>();

  Patrimonio get patrimonio => widget.patrimonio;

  bool get isAdmin => authController.isAdmin;

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
            Get.back();
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
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ===============================
            // IDENTIFICACAO
            // ===============================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Container(
                        width: 58,
                        height: 58,

                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFE8F0FF),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color:
                              Color(0xFF1D5DFF),
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              patrimonio.descricao,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Color(0xFF1F2937),
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              patrimonio.tombamento,
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 10),

                            _StatusBadge(
                              status:
                                  patrimonio.status,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ===============================
            // DADOS
            // ===============================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Informações do patrimônio',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  _Campo(
                    titulo: 'Tombamento',
                    valor:
                        patrimonio.tombamento,
                  ),

                  _Campo(
                    titulo: 'Descrição',
                    valor:
                        patrimonio.descricao,
                  ),

                  _Campo(
                    titulo: 'Categoria',
                    valor:
                        patrimonio.categoria,
                  ),

                  _Campo(
                    titulo: 'Marca',
                    valor:
                        patrimonio.marca ??
                            'Não informado',
                  ),

                  _Campo(
                    titulo: 'Número de Série',
                    valor:
                        patrimonio.numeroSerie ??
                            'Não informado',
                  ),

                  _Campo(
                    titulo: 'Localização',
                    valor:
                        patrimonio.localizacao ??
                            'Não informado',
                  ),

                  _Campo(
                    titulo: 'Professor responsável',
                    valor:
                        patrimonio.professorId !=
                                null
                            ? 'Professor #${patrimonio.professorId}'
                            : 'Nenhum',
                  ),

                  _Campo(
                    titulo: 'Data de atribuição',
                    valor:
                        patrimonio.dataAtribuicao !=
                                null
                            ? _formatarData(
                                patrimonio
                                    .dataAtribuicao!,
                              )
                            : 'Não atribuído',
                    ultimo: true,
                  ),
                ],
              ),
            ),

            // ===============================
            // ACOES DO ADMIN
            // ===============================

            if (isAdmin) ...[
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.adminEditarPatrimonio,
                          arguments: patrimonio,
                        );
                      },

                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor:
                            const Color(
                          0xFF1D5DFF,
                        ),

                        side:
                            const BorderSide(
                          color:
                              Color(0xFF1D5DFF),
                        ),

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 15,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                        ),
                      ),

                      child:
                          const Text('Editar'),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _confirmarExclusao,

                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor:
                            Colors.red,

                        side:
                            const BorderSide(
                          color: Colors.red,
                        ),

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 15,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                        ),
                      ),

                      child:
                          const Text('Excluir'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (patrimonio.status ==
                  StatusPatrimonio.emUso)
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed:
                        _confirmarDevolucao,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF16A34A),

                      foregroundColor:
                          Colors.white,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 15,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),
                      ),
                    ),

                    child: const Text(
                      'Devolver Equipamento',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarExclusao() async {
    final confirmar =
        await Get.dialog<bool>(
      AlertDialog(
        title:
            const Text('Excluir patrimônio?'),

        content: const Text(
          'Essa ação não poderá ser desfeita.',
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Cancelar'),
          ),

          FilledButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      return;
    }

    try {
      await patrimonioController.excluir(
        patrimonio.id,
      );

      Get.back();

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

  Future<void> _confirmarDevolucao() async {
    final motivoController =
        TextEditingController();

    final confirmar =
        await Get.dialog<bool>(
      AlertDialog(
        title:
            const Text('Devolver equipamento'),

        content: TextField(
          controller: motivoController,
          maxLines: 3,

          decoration:
              const InputDecoration(
            labelText: 'Motivo da devolução',
            hintText:
                'Digite o motivo, se necessário',
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },

            child:
                const Text('Cancelar'),
          ),

          FilledButton(
            onPressed: () {
              Get.back(result: true);
            },

            child:
                const Text('Devolver'),
          ),
        ],
      ),
    );

    if (confirmar != true) {
      motivoController.dispose();
      return;
    }

    try {
      await patrimonioController.devolver(
        patrimonioId: patrimonio.id,
        motivo:
            motivoController.text.trim().isEmpty
                ? null
                : motivoController.text.trim(),
      );

      Get.back();

      Get.snackbar(
        'Sucesso',
        'Equipamento devolvido.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Erro',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      motivoController.dispose();
    }
  }

  String _formatarData(DateTime data) {
    final dia =
        data.day.toString().padLeft(2, '0');

    final mes =
        data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }
}

class _Campo extends StatelessWidget {
  final String titulo;
  final String valor;
  final bool ultimo;

  const _Campo({
    required this.titulo,
    required this.valor,
    this.ultimo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 10),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 11,
              color:
                  Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            valor,
            style: const TextStyle(
              fontSize: 13,
              color:
                  Color(0xFF1F2937),
            ),
          ),

          if (!ultimo) ...[
            const SizedBox(height: 5),

            Divider(
              color:
                  Colors.grey.shade300,
              height: 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StatusPatrimonio status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color cor;

    switch (status) {
      case StatusPatrimonio.disponivel:
        cor = Colors.green;
        break;

      case StatusPatrimonio.emUso:
        cor = Colors.blue;
        break;

      case StatusPatrimonio.emManutencao:
        cor = Colors.orange;
        break;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status.label,
        style: TextStyle(
          color: cor,
          fontSize: 12,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}
