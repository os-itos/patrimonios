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
          