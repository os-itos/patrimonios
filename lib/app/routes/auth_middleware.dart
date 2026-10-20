import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import 'app_routes.dart';

// so deixa entrar se tiver logado, se nao manda pro login
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();

    if (!auth.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.login);
    }

    return null;
  }
}

// telas do coordenador: se for professor manda pro painel dele
class AdminMiddleware extends AuthMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();

    if (!auth.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.login);
    }

    if (!auth.isAdmin) {
      return const RouteSettings(name: AppRoutes.professor);
    }

    return null;
  }
}

// telas do professor: se for admin manda pro painel do admin
class ProfessorMiddleware extends AuthMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();

    if (!auth.isAuthenticated) {
      return const RouteSettings(name: AppRoutes.login);
    }

    if (!auth.isProfessor) {
      return const RouteSettings(name: AppRoutes.admin);
    }

    return null;
  }
}
