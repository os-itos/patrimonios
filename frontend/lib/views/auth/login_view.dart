import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../app/routes/app_routes.dart';

class LoginPatrimonio extends StatefulWidget {
  const LoginPatrimonio({super.key});

  @override
  State<LoginPatrimonio> createState() => _LoginPatrimonioState();
}

class _LoginPatrimonioState extends State<LoginPatrimonio> {
  final AuthController authController =
      Get.find<AuthController>();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController senhaController =
      TextEditingController();

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  bool esconderSenha = true;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> entrar() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      await authController.login(
        email: emailController.text.trim(),
        senha: senhaController.text,
      );
    } catch (_) {
      Get.snackbar(
        'Erro no login',
        authController.errorMessage.value.isEmpty
            ? 'Nao foi possivel entrar.'
            : authController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 247, 247, 247),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24),

            child: Form(
              key: formKey,

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D5DFF),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Patrimônio',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Gestão de Patrimônios Escolares',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color.fromARGB(
                        255,
                        145,
                        145,
                        145,
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,

                    margin: const EdgeInsets.only(
                      top: 30,
                    ),

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(15),
                      color: Colors.white,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Acessar conta',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'E-mail Institucional',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 5),

                        TextFormField(
                          controller: emailController,

                          keyboardType:
                              TextInputType.emailAddress,

                          decoration: InputDecoration(
                            hintText:
                                'coordenador@escola.edu.br',

                            prefixIcon: const Icon(
                              Icons.email_outlined,
                            ),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10),

                              borderSide:
                                  const BorderSide(
                                color: Color.fromARGB(
                                  45,
                                  13,
                                  13,
                                  13,
                                ),
                                width: 1,
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10),

                              borderSide:
                                  const BorderSide(
                                color:
                                    Color(0xFF1D5DFF),
                                width: 2,
                              ),
                            ),
                          ),

                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Digite seu e-mail.';
                            }

                            if (!GetUtils.isEmail(
                              value.trim(),
                            )) {
                              return 'Digite um e-mail valido.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Senha',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 5),

                        TextFormField(
                          controller: senhaController,

                          obscureText: esconderSenha,

                          decoration: InputDecoration(
                            hintText:
                                'Digite sua senha',

                            prefixIcon:
                                const Icon(Icons.lock),

                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  esconderSenha =
                                      !esconderSenha;
                                });
                              },

                              icon: Icon(
                                esconderSenha
                                    ? Icons
                                        .visibility_off_outlined
                                    : Icons
                                        .visibility_outlined,
                              ),
                            ),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10),

                              borderSide:
                                  const BorderSide(
                                color: Color.fromARGB(
                                  45,
                                  13,
                                  13,
                                  13,
                                ),
                                width: 1,
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10),

                              borderSide:
                                  const BorderSide(
                                color:
                                    Color(0xFF1D5DFF),
                                width: 2,
                              ),
                            ),
                          ),

                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return 'Digite sua senha.';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 50,

                            child: ElevatedButton(
                              onPressed:
                                  authController.isLoading.value
                                      ? null
                                      : entrar,

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFF1D5DFF,
                                ),

                                foregroundColor:
                                    Colors.white,

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),

                              child:
                                  authController
                                          .isLoading
                                          .value
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color:
                                                Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Entrar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                        ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(
                                AppRoutes.recuperacao,
                              );
                            },

                            child: const Text(
                              'Esqueci minha senha',
                              style: TextStyle(
                                color:
                                    Color(0xFF1D5DFF),
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w600,
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
        ),
      ),
    );
  }
}
