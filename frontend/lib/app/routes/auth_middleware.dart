import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import 'app_routes.dart';

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
