import 'package:flutter/material.dart';

import '/models/professor.dart';
import '/models/patrimonio.dart';

class ProfessorDetailView extends StatelessWidget {
  final Professor professor;

  const ProfessorDetailView({super.key, required this.professor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF263238)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detalhes do Professor',
          style: TextStyle(
            color: Color(0xFF263238),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // CONTEÚDO
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD DO PROFESSOR
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  // FOTO / INICIAL
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF2FF),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      professor.nome.isNotEmpty
                          ? professor.nome[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(width: 11),

                  // DADOS DO PROFESSOR
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          professor.nome,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          professor.email,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF6B7280),
                          ),
                        ),

                        const SizedBox(height: 2),

                        if (professor.matricula != null)
                          Text(
                            'Matrícula: ${professor.matricula}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // TÍTULO
            Text(
              'Patrimônios Atribuídos (${professor.quantidadePatrimonios})',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),

            const SizedBox(height: 8),

            // LISTA DE PATRIMÔNIOS
            if (professor.patrimonios.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Center(
                  child: Text(
                    'Nenhum patrimônio atribuído.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: professor.patrimonios.length,
                itemBuilder: (context, index) {
                  final patrimonio = professor.patrimonios[index];

                  return _buildPatrimonioCard(patrimonio);
                },
              ),
          ],
        ),
      ),

      // NAVEGAÇÃO INFERIOR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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

  Widget _buildPatrimonioCard(Patrimonio patrimonio) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DESCRIÇÃO
          Text(
            patrimonio.descricao,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 3),

          // TOMBAMENTO
          Text(
            patrimonio.tombamento,
            style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 8),

          // CATEGORIA E STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CATEGORIA
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  patrimonio.categoria,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // STATUS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Atribuído',
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFFD99400),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
