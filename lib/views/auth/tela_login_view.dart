import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

// tela de login (rf01)
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

  // valida os campos e chama o login
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

    // fecha o teclado
    FocusScope.of(context).unfocus();

    try {
      // se der certo o controller de auth ja manda pra tela certa pela role
      await auth.login(email: email, senha: senha);
    } catch (_) {
      // a mensagem fica salva no controller e aparece embaixo do botao
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

              // icone
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

              // titulo
              const Text(
                'Patrimônio',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF273142),
                ),
              ),

              const SizedBox(height: 2),

              // subtitulo
              const Text(
                'Gestão de Patrimônios Escolares',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A8496),
                ),
              ),

              const SizedBox(height: 28),

              // card
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

                    // titulo do card
                    const Text(
                      'Acessar Conta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF273142),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // email
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

                    // senha
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

                    // botao entrar
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

                    // mensagem de erro da api (ex: email ou senha errados)
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

                    // esqueci a senha
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // ainda nao tem tela de recuperar senha
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