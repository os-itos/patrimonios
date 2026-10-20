import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await InitialBinding().dependencies();

  // Se já existe um token salvo e válido, abre direto no painel do usuário.
  final auth = Get.find<AuthController>();
  final logado = await auth.restoreSession();

  final rotaInicial = !logado
      ? AppRoutes.login
      : auth.isAdmin
          ? AppRoutes.admin
          : AppRoutes.professor;

  runApp(PatrimonioApp(rotaInicial: rotaInicial));
}

class PatrimonioApp extends StatelessWidget {
  final String rotaInicial;

  const PatrimonioApp({super.key, required this.rotaInicial});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patrimônio Escolar',
      theme: AppTheme.light,
      initialRoute: rotaInicial,
      getPages: AppPages.pages,
    );
  }
}
