import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/patrimonio_controller.dart';
import '/models/patrimonio.dart';

class ProfessorHomeView extends StatelessWidget {
  ProfessorHomeView({super.key});

  final PatrimonioController controller = Get.find<PatrimonioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CABEÇALHO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bem-vindo de volta,',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Olá, Professor',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF202938),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: const Icon(
                              Icons.notifications_none,
                              color: Color(0xFF263246),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // CARD DE QUANTIDADE
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Meus Patrimônios',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF2FF),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 17,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${controller.patrimonios.length}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF202938),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      const Text(
                        'Patrimônios Atribuídos',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF202938),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // LISTA DOS PATRIMÔNIOS
                      if (controller.patrimonios.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text('Nenhum patrimônio atribuído.'),
                          ),
                        )
                      else
                        ...controller.patrimonios.map(
                          (patrimonio) => _cardPatrimonio(patrimonio),
                        ),
                    ],
                  ),
                ),
              ),
              // MENU INFERIOR
              _menuInferior(),
            ],
          );
        }),
      ),
    );
  }

  Widget _cardPatrimonio(Patrimonio patrimonio) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E3E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            patrimonio.descricao,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263246),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            patrimonio.tombamento,
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              patrimonio.localizacao ?? 'Sem localização',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuInferior() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _itemMenu(Icons.home_outlined, 'Início', true),
          _itemMenu(Icons.inventory_2_outlined, 'Patrimônios', false),
          _itemMenu(Icons.person_outline, 'Perfil', false),
        ],
      ),
    );
  }

  Widget _itemMenu(IconData icone, String texto, bool selecionado) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icone,
          size: 21,
          color: selecionado ? Colors.blue : Colors.grey[600],
        ),
        const SizedBox(height: 2),
        Text(
          texto,
          style: TextStyle(
            fontSize: 10,
            color: selecionado ? Colors.blue : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
