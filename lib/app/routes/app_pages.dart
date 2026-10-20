import 'package:get/get.dart';

import '../../views/auth/tela_login_view.dart';
import '../../views/coordenador/atribuir_item_view.dart';
import '../../views/coordenador/cadastrar-patrimonio_view.dart';
import '../../views/coordenador/cadastrar_professor_view.dart';
import '../../views/coordenador/dashboard_view.dart';
import '../../views/coordenador/devolver-patrimonio_view.dart';
import '../../views/coordenador/patrimonio_detalhe_view.dart';
import '../../views/coordenador/patrimonios_view.dart';
import '../../views/coordenador/perfil_view.dart' as coordenador;
import '../../views/prof/detalhes_view.dart';
import '../../views/prof/patrimonios_view.dart';
import '../../views/prof/perfil_view.dart' as prof;
import '../../views/prof/prof_dashboard_view.dart';
import '../../views/prof/professores_view.dart';
import 'app_routes.dart';
import 'auth_middleware.dart';

// aqui liga cada rota na sua tela. as do admin e do professor passam
// pelo middleware que confere se ta logado e se é o perfil certo
class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const TelaLoginView(),
    ),

    // ----------------------- telas do coordenador (admin) -----------------------
    GetPage(
      name: AppRoutes.admin,
      page: () => const DashboardView(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminPerfil,
      page: () => const coordenador.PerfilView(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminPatrimonios,
      page: () => const PatrimonioListView(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminCadastrarPatrimonio,
      page: () => const CadastroPatrimonioView(),
      middlewares: [AdminMiddleware()],
    ),
    // essas aqui recebem o objeto que foi passado no arguments do tonamed
    GetPage(
      name: AppRoutes.adminDetalhesPatrimonio,
      page: () => PatrimonioDetailView(patrimonio: Get.arguments),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminAtribuirPatrimonio,
      page: () => AtribuirItem(patrimonio: Get.arguments),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminDevolverPatrimonio,
      page: () => DevolverPatrimonioView(patrimonio: Get.arguments),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminProfessores,
      page: () => const ProfessorListView(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminCadastrarProfessor,
      page: () => const CadastrarProfessorView(),
      middlewares: [AdminMiddleware()],
    ),
    GetPage(
      name: AppRoutes.adminDetalhesProfessor,
      page: () => ProfessorDetailView(professor: Get.arguments),
      middlewares: [AdminMiddleware()],
    ),

    // ---------------------------- telas do professor ----------------------------
    GetPage(
      name: AppRoutes.professor,
      page: () => const ProfessorHomeView(),
      middlewares: [ProfessorMiddleware()],
    ),
    GetPage(
      name: AppRoutes.professorPatrimonios,
      page: () => const ProfessorPatrimoniosView(),
      middlewares: [ProfessorMiddleware()],
    ),
    GetPage(
      name: AppRoutes.professorPerfil,
      page: () => const prof.PerfilView(),
      middlewares: [ProfessorMiddleware()],
    ),
  ];
}
