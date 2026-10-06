import 'package:get/get.dart';

import '../../views/dashboard_view.dart';
// TODO: importe aqui as views dos colegas quando elas existirem no projeto:
// import '../../views/login_patrimonio.dart';
// import '../../views/patrimonio_detail_view.dart';
// import '../../views/patrimonio_edit_view.dart';
import 'app_routes.dart';
import 'auth_middleware.dart';

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    // Dashboard do administrador (precisa estar logado como admin).
    GetPage(
      name: AppRoutes.admin,
      page: () => const DashboardView(),
      middlewares: [AdminMiddleware()],
    ),

    // TODO: reative estas rotas quando as views acima estiverem importadas.
    //
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => const LoginPatrimonio(),
    // ),
    // GetPage(
    //   name: AppRoutes.adminDetalhesPatrimonio,
    //   page: () => PatrimonioDetailView(patrimonio: Get.arguments),
    // ),
    // GetPage(
    //   name: AppRoutes.adminEditarPatrimonio,
    //   page: () => PatrimonioEditView(patrimonio: Get.arguments),
    // ),
  ];
}