import 'package:get/get.dart';

import '../../views/auth/login_view.dart';
import '../../views/coordenador/patrimonio_detalhe_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPatrimonio(),
    ),

    GetPage(
      name: AppRoutes.adminDetalhesPatrimonio,
      page: () {
        final patrimonio = Get.arguments;
        return PatrimonioDetailView(
          patrimonio: patrimonio,
        );
      },
    ),
    GetPage(
      name: AppRoutes.adminEditarPatrimonio,
      page: () {
        final patrimonio = Get.arguments;
        return PatrimonioEditView(
          patrimonio: patrimonio,
        );
      },
    ),
  ];
}