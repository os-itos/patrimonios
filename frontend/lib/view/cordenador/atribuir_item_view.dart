import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patrimonio_controller.dart';
import '../../controllers/professor_controller.dart';
import '../../models/patrimonio.dart';
import '../../models/professor.dart';

class AtribuirItem extends StatefulWidget {
  final Patrimonio patrimonio;

  const AtribuirItem({
    super.key,
    required this.patrimonio,
  });

  @override
  State<AtribuirItem> createState() => _AtribuirItemState();
}

class _AtribuirItemState extends State<AtribuirItem> {
  final PatrimonioController patrimonioController =
      Get.find<PatrimonioController>();

  final ProfessorController professorController =
      Get.find<ProfessorController>();

  int? professorSelecionado;

  @override
  void initState() {
    super.initState();

    professorController.carregarProfessores();
  }

  Future<void> _confirmarAtribuicao() async {
    if (professorSelecionado == null) {
      Get.snackbar(
        'Atenção',
        'Selecione um professor responsável.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await patrimonioController.atribuir(
        patrimonioId: widget.patrimonio.id,
        professorId: professorSelecionado!,
      );

      Get.back();

      Get.snackbar(
        'Sucesso',
        'Item atribuído com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Erro',
        'Não foi possível atribuir o item.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final patrimonio = widget.patrimonio;

    final bool disponivel =
        patrimonio.status == StatusPatrimonio.disponivel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        title: const Text(
          'Atribuir Item',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // ITEM
              // =========================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Item a ser atribuído:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            patrimonio.descricao,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            patrimonio.tombamento,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: disponivel
                            ? const Color.fromARGB(
                                120,
                                102,
                                255,
                                117,
                              )
                            : const Color.fromARGB(
                                100,
                                255,
                                100,
                                100,
                              ),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        patrimonio.status.label,
                        style: TextStyle(
                          color: disponivel
                              ? const Color.fromARGB(
                                  255,
                                  50,
                                  169,
                                  80,
                                )
                              : const Color.fromARGB(
                                  255,
                                  200,
                                  50,
                                  50,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =========================================================
              // PROFESSOR
              // =========================================================

              const Text(
                'Selecionar Professor Responsável',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Obx(() {
                if (professorController.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return DropdownButtonFormField<int>(
                  value: professorSelecionado,

                  decoration: InputDecoration(
                    hintText: 'Selecione um professor',

                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(
                          45,
                          13,
                          13,
                          13,
                        ),
                        width: 1,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF1D5DFF),
                        width: 2,
                      ),
                    ),
                  ),

                  items: professorController.professores
                      .map(
                        (Professor professor) {
                          return DropdownMenuItem<int>(
                            value: professor.id,
                            child: Text(professor.nome),
                          );
                        },
                      )
                      .toList(),

                  onChanged: (value) {
                    setState(() {
                      professorSelecionado = value;
                    });
                  },
                );
              }),

              const SizedBox(height: 20),

              // =========================================================
              // PRAZO
              // =========================================================

              const Text(
                'Prazo de Devolução (Opcional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                keyboardType: TextInputType.datetime,

                decoration: InputDecoration(
                  hintText: 'DD/MM/AAAA',

                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(
                        45,
                        13,
                        13,
                        13,
                      ),
                      width: 1,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF1D5DFF),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // =========================================================
              // BOTÃO
              // =========================================================

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: disponivel
                      ? _confirmarAtribuicao
                      : null,

                  style: FilledButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF1D5DFF),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    'Confirmar Atribuição',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}