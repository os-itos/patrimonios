import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const PerfilPage(),
    );
  }
}

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Color(0xFF263143),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 15, 14, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _perfilCard(),
                  const SizedBox(height: 14),
                  _instituicaoCard(),
                  const SizedBox(height: 14),
                  _botao(
                    texto: 'Editar Dados',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 8),
                  _botao(
                    texto: 'Alterar Senha',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 17),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Sair',
                      style: TextStyle(
                        color: Color(0xFFFF3030),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _bottomNavigation(),
        ],
      ),
    );
  }

  Widget _perfilCard() {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE1E3E8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF5FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'C',
                style: TextStyle(
                  color: Color(0xFF1557FF),
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Olá, Coordenador',
                style: TextStyle(
                  color: Color(0xFF263143),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                      ),
              ),
              const SizedBox(height: 3),
              const Text(
                'coordenador@escola.edu.br',
                style: TextStyle(
                  color: Color(0xFF7A8494),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'Coordenador Geral',
                  style: TextStyle(
                    color: Color(0xFF1557FF),
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _instituicaoCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE1E3E8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dados da Instituição',
            style: TextStyle(
              color: Color(0xFF263143),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            ),
          const SizedBox(height: 9),
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 10),
          _informacao(
            'Nome da Escola',
            'Escola Estadual D. Pedro II',
          ),
          const SizedBox(height: 8),
          _informacao(
            'CNPJ',
            '12.345.678/0001-90',
          ),
          const SizedBox(height: 8),
          _informacao(
            'Endereço',
            'Av. Paulista, 1000 - São Paulo/SP',
          ),
        ],
      ),
    );
  }

  Widget _informacao(String titulo, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF697386),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: const TextStyle(
            color: Color(0xFF263143),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _botao({
    required String texto,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 37,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFF1557FF),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: Color(0xFF1557FF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E5EA),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _itemNav(
            Icons.home_outlined,
            'Início',
            false,
          ),
          _itemNav(
            Icons.inventory_2_outlined,
            'Patrimônios',
            false,
          ),
          _itemNav(
            Icons.people_outline,
            'Professores',
            false,
          ),
          _itemNav(
            Icons.person_outline,
            'Perfil',
            true,
          ),
        ],
      ),
    );
  }

  Widget _itemNav(
    IconData icone,
    String texto,
    bool selecionado,
  ) {
    final cor = selecionado
        ? const Color(0xFF1557FF)
        : const Color(0xFF697386);

    return SizedBox(
      width: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icone,
            size: 22,
            color: cor,
          ),
          const SizedBox(height: 4),
          Text(
            texto,
            style: TextStyle(
              color: cor,
              fontSize: 10,
              fontWeight:
                  selecionado ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
            
          