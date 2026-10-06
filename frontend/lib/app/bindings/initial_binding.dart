import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/dashboard_controller.dart';
import '../../../controllers/patrimonio_controller.dart';
import '../../../controllers/perfil_controller.dart';
import '../../../controllers/professor_controller.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/dashboard_service.dart';
import '../../../services/patrimonio_service.dart';
import '../../../services/perfil_service.dart';
import '../../../services/professor_service.dart';
import '../../../services/session_manager.dart';
import '../../../services/storage_service.dart';

class InitialBinding {
  Future<void> dependencies() async {
    Get.put<StorageService>(
      StorageService(),
      permanent: true,
    );

    Get.put<SessionManager>(
      SessionManager(Get.find<StorageService>()),
      permanent: true,
    );

    Get.put<ApiService>(
      ApiService(
        storage: Get.find<StorageService>(),
        sessionManager: Get.find<SessionManager>(),
      ),
      permanent: true,
    );

    Get.put<AuthService>(
      AuthService(Get.find<ApiService>()),
      permanent: true,
    );

    Get.put<ProfessorService>(
      ProfessorService(Get.find<ApiService>()),
      permanent: true,
    );

    Get.put<PatrimonioService>(
      PatrimonioService(Get.find<ApiService>()),
      permanent: true,
    );

    Get.put<DashboardService>(
      DashboardService(Get.find<ApiService>()),
      permanent: true,
    );

    Get.put<PerfilService>(
      PerfilService(Get.find<ApiService>()),
      permanent: true,
    );

    Get.put<AuthController>(
      AuthController(
        authService: Get.find<AuthService>(),
        sessionManager: Get.find<SessionManager>(),
        storage: Get.find<StorageService>(),
      ),
      permanent: true,
    );

    Get.put<DashboardController>(
      DashboardController(Get.find<DashboardService>()),
      permanent: true,
    );

    Get.put<ProfessorController>(
      ProfessorController(Get.find<ProfessorService>()),
      permanent: true,
    );

    Get.put<PatrimonioController>(
      PatrimonioController(Get.find<PatrimonioService>()),
      permanent: true,
    );

    Get.put<PerfilController>(
      PerfilController(Get.find<PerfilService>()),
      permanent: true,
    );
  }
}
