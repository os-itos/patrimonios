import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // registra os services e controllers antes de abrir o app
  await InitialBinding().dependencies();

  // se ja tem token salvo e ainda vale, abre direto no painel certo
  final auth = Get.find<AuthController>();
  final logado = await auth.restoreSession();

  final rotaInicial = !logado
      ? AppRoutes.login
      : auth.isAdmin
          ? AppRoutes.admin
          : AppRoutes.professor;

  // device preview: mostra o app dentro de um celular no chrome/pc.
  // so liga fora do modo release, entao no apk final nao aparece
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      defaultDevice: Devices.android.samsungGalaxyS20,
      builder: (context) => PatrimonioApp(rotaInicial: rotaInicial),
    ),
  );
}

// widget raiz, com as rotas do getx
class PatrimonioApp extends StatelessWidget {
  final String rotaInicial;

  const PatrimonioApp({super.key, required this.rotaInicial});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patrimônio Escolar',
      // essas duas linhas fazem o app usar o tamanho e o idioma do celular do preview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: AppTheme.light,
      initialRoute: rotaInicial,
      getPages: AppPages.pages,
    );
  }
}
