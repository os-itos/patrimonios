import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/professor_controller.dart';

/// Cadastro de professor pelo coordenador (RN02 / RF06).
/// Segue o mesmo visual da tela "Novo Patrimônio".
class CadastrarProfessorView extends StatefulWidget {
  const CadastrarProfessorView({super.key});

  @override
  State<CadastrarProfessorView> createState() =>
      _CadastrarProfessorViewState();
}

class _CadastrarProfessorViewState extends State<CadastrarProfessorView> {
  final ProfessorController controller = Get.find<ProfessorController>();

  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final matriculaController = TextEditingController();
  final departamentoController = TextEditingController();
  final telefoneController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    matriculaController.dispose();
    departamentoController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  String? _opcional(TextEditingController c) {
    final texto = c.text.trim();
    return texto.isEmpty ? null : texto;
  }

  Future<void> salvarProfessor() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await controller.cadastrar(
        nome: nomeController.text.trim(),
        email: emailController.text.trim(),
        senha: senhaController.text,
        matricula: _opcional(matriculaController),
        departamento: _opcional(departamentoController),
        telefone: _opcional(telefoneController),
      );

      // Fecha a tela antes do snackbar: com um snackbar aberto,
      // o Get.back() fecharia só o snackbar.
      Get.back();

      Get.snackbar(
        'Sucesso',
        'Professor cadastrado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } catch (error) {
      Get.snackbar(
        'Erro',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  InputDecoration campoDecoracao({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF7A8190), fontSize: 12),
      filled: true,
      fillColor: const Color(0xFFF8F8F8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFD9DCE1), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFD9DCE1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF1E5BD7), width: 1.5),
      ),
    );
  }

  Widget campoTexto({
    required String titulo,
    required String hint,
    required TextEditingController controller,
    bool obrigatorio = false,
    bool senha = false,
    TextInputType? teclado,
    String? Function(String)? validarExtra,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF263142),
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: senha,
          keyboardType: teclado,
          style: const TextStyle(fontSize: 12, color: Color(0xFF263142)),
          decoration: campoDecoracao(hintText: hint),
          validator: (value) {
            final texto = value?.trim() ?? '';
            if (obrigatorio && texto.isEmpty) return 'Preencha este campo';
            if (texto.isNotEmpty && validarExtra != null) {
              return validarExtra(texto);
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF0F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF263142),
            size: 22,
          ),
        ),
        title: const Text(
          'Novo Professor',
          style: TextStyle(
            color: Color(0xFF263142),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                campoTexto(
                  titulo: 'Nome Completo',
                  hint: 'Ex: Prof. Carlos Drummond',
                  controller: nomeController,
                  obrigatorio: true,
                ),
                const SizedBox(height: 12),
                campoTexto(
                  titulo: 'E-mail Institucional',
                  hint: 'professor@escola.com',
                  controller: emailController,
                  obrigatorio: true,
                  teclado: TextInputType.emailAddress,
                  validarExtra: (v) =>
                      GetUtils.isEmail(v) ? null : 'E-mail inválido',
                ),
                const SizedBox(height: 12),
                campoTexto(
                  titulo: 'Senha Provisória',
                  hint: 'Mínimo de 6 caracteres',
                  controller: senhaController,
                  obrigatorio: true,
                  senha: true,
                  validarExtra: (v) =>
                      v.length < 6 ? 'Use pelo menos 6 caracteres' : null,
                ),
                const SizedBox(height: 12),
                campoTexto(
                  titulo: 'Matrícula',
                  hint: 'Ex: PROF-2024-03',
                  controller: matriculaController,
                ),
                const SizedBox(height: 12),
                campoTexto(
                  titulo: 'Departamento',
                  hint: 'Ex: Ciências da Natureza',
                  controller: departamentoController,
                ),
                const SizedBox(height: 12),
                campoTexto(
                  titulo: 'Telefone',
                  hint: '(11) 98765-1003',
                  controller: telefoneController,
                  teclado: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 44,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value ? null : salvarProfessor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2059D6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Salvar Professor',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
