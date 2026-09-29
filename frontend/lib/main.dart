import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'views/patrimonio_page.dart'; 
import 'views/coordenador/patrimonio_view.dart';
import 'views/auth/login_view.dart';
import 'views/auth/cadastro_view.dart';
import 'views/auth/recuperacao_view.dart';

import 'views/admin/admin_home_view.dart';
import 'views/admin/professores/professores_view.dart';
import 'views/admin/professores/cadastrar_professor_view.dart';
import 'views/admin/professores/detalhes_professor_view.dart';

import 'views/admin/patrimonios/patrimonios_view.dart';
import 'views/admin/patrimonios/cadastrar_patrimonio_view.dart';
import 'views/admin/patrimonios/detalhes_patrimonio_view.dart';
import 'views/admin/patrimonios/atribuir_patrimonio_view.dart';
import 'views/admin/patrimonios/devolver_patrimonio_view.dart';
import 'views/admin/patrimonios/historico_patrimonio_view.dart';

import 'views/professor/professor_home_view.dart';
import 'views/professor/meus_patrimonios_view.dart';
import 'views/professor/perfil_view.dart';
import 'views/professor/alterar_senha_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Controller principal de autenticação
  Get.put(AuthController(), permanent: true);

  runApp(const PatrimonioApp());
}

class PatrimonioApp extends StatelessWidget {
  const PatrimonioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patrimônio Escolar',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),

      initialRoute: '/login',

      getPages: [
        // =========================
        // AUTENTICAÇÃO
        // =========================

        GetPage(
          name: '/login',
          page: () => const LoginView(),
        ),

        GetPage(
          name: '/cadastro',
          page: () => const CadastroView(),
        ),

        GetPage(
          name: '/recuperacao',
          page: () => const RecuperacaoView(),
        ),

        // =========================
        // ADMIN
        // =========================

        GetPage(
          name: '/admin',
          page: () => const AdminHomeView(),
        ),

        // Professores
        GetPage(
          name: '/admin/professores',
          page: () => const ProfessoresView(),
        ),

        GetPage(
          name: '/admin/professores/cadastrar',
          page: () => const CadastrarProfessorView(),
        ),

        GetPage(
          name: '/admin/professores/detalhes',
          page: () => const DetalhesProfessorView(),
        ),

        // Patrimônios
        GetPage(
          name: '/admin/patrimonios',
          page: () => const PatrimoniosView(),
        ),

        GetPage(
          name: '/admin/patrimonios/cadastrar',
          page: () => const CadastrarPatrimonioView(),
        ),

        GetPage(
          name: '/admin/patrimonios/detalhes',
          page: () => const DetalhesPatrimonioView(),
        ),

        GetPage(
          name: '/admin/patrimonios/atribuir',
          page: () => const AtribuirPatrimonioView(),
        ),

        GetPage(
          name: '/admin/patrimonios/devolver',
          page: () => const DevolverPatrimonioView(),
        ),

        GetPage(
          name: '/admin/patrimonios/historico',
          page: () => const HistoricoPatrimonioView(),
        ),

        // =========================
        // PROFESSOR
        // =========================

        GetPage(
          name: '/professor',
          page: () => const ProfessorHomeView(),
        ),

        GetPage(
          name: '/professor/patrimonios',
          page: () => const MeusPatrimoniosView(),
        ),

        GetPage(
          name: '/professor/perfil',
          page: () => const PerfilView(),
        ),

        GetPage(
          name: '/professor/senha',
          page: () => const AlterarSenhaView(),
        ),
      ],

      // Impede que o usuário volte para telas anteriores
      // depois de trocar de fluxo de autenticação.
      unknownRoute: GetPage(
        name: '/404',
        page: () => const LoginView(),
      ),
    );
  }
}
