import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class TelaLoginView extends StatefulWidget {
  const TelaLoginView({super.key});

  @override
  State<TelaLoginView> createState() => _TelaLoginViewState();
}

class _TelaLoginViewState extends State<TelaLoginView> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController senhaController =
      TextEditingController();

  final AuthController auth = Get.find<AuthController>();

  bool esconderSenha = true;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> entrar() async {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (!GetUtils.isEmail(email) || senha.isEmpty) {
      Get.snackbar(
        'Atenção',
        'Informe um e-mail válido e a senha.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    try {
      // Em caso de sucesso o AuthController já redireciona pela role.
      await auth.login(email: email, senha: senha);
    } catch (_) {
      // A mensagem fica em auth.errorMessage e aparece abaixo do botão.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [

              const SizedBox(height: 35),

              // ÍCONE
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),

              const SizedBox(height: 10),

              // TÍTULO
              const Text(
                'Patrimônio',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF273142),
                ),
              ),

              const SizedBox(height: 2),

              // SUBTÍTULO
              const Text(
                'Gestão de Patrimônios Escolares',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A8496),
                ),
              ),

              const SizedBox(height: 28),

              // CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // TÍTULO DO CARD
                    const Text(
                      'Acessar Conta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF273142),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // EMAIL
                    const Text(
                      'E-mail Institucional',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF273142),
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'coordenador@escola.edu.br',
                        hintStyle: const TextStyle(
                          color: Color(0xFF7A8496),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDE1E7),
                            width: 1,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // SENHA
                    const Text(
                      'Senha',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF273142),
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: senhaController,
                      obscureText: esconderSenha,
                      onSubmitted: (_) => entrar(),
                      decoration: InputDecoration(
                        hintText: 'Digite sua senha',
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => esconderSenha = !esconderSenha,
                          ),
                          icon: Icon(
                            esconderSenha
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF7A8496),
                          ),
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFF7A8496),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFDDE1E7),
                            width: 1,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2563EB),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // BOTÃO ENTRAR
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Obx(() => ElevatedButton(
                        onPressed: auth.isLoading.value ? null : entrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: auth.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      )),
                    ),

                    // MENSAGEM DE ERRO DA API (ex.: e-mail ou senha incorretos)
                    Obx(() {
                      final erro = auth.errorMessage.value;
                      if (erro.isEmpty) return const SizedBox.shrink();

                      return Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          erro,
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 13,
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 22),

                    // ESQUECI A SENHA
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Recuperação de senha
                        },
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration:
                                TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}