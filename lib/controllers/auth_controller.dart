import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/session_manager.dart';
import '../services/storage_service.dart';

// cuida do login, do logout e de lembrar quem ta logado
class AuthController extends GetxController {
  final AuthService authService;
  final SessionManager sessionManager;
  final StorageService storage;

  // variaveis observaveis: a tela atualiza sozinha quando mudam (obx)
  final RxBool isLoading = false.obs;
  final Rxn<Usuario> currentUser = Rxn<Usuario>();
  final RxString errorMessage = ''.obs;

  AuthController({
    required this.authService,
    required this.sessionManager,
    required this.storage,
  });

  // atalhos pra saber se ta logado e qual o perfil
  bool get isAuthenticated =>
      sessionManager.isAuthenticated.value;

  bool get isAdmin =>
      currentUser.value?.role == UserRole.admin;

  bool get isProfessor =>
      currentUser.value?.role == UserRole.professor;

  // faz o login, salva o token e manda pra tela certa de acordo com a role
  Future<void> login({
    required String email,
    required String senha,
  }) async {
    errorMessage.value = '';
    isLoading.value = true;

    try {
      final response = await authService.login(
        email: email.trim(),
        senha: senha,
      );

      currentUser.value = response.usuario;

      await sessionManager.setSession(
        token: response.accessToken,
        user: response.usuario,
        refreshToken: response.refreshToken,
      );

      if (response.usuario.isAdmin) {
        Get.offAllNamed(AppRoutes.admin);
      } else {
        Get.offAllNamed(AppRoutes.professor);
      }
    } catch (error) {
      errorMessage.value = error.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // usado quando o app abre: se tem token salvo, confere na api se ainda vale
  Future<bool> restoreSession() async {
    isLoading.value = true;

    try {
      await sessionManager.loadStoredSession();

      if (!sessionManager.isAuthenticated.value) {
        return false;
      }

      final user = await authService.me();

      currentUser.value = user;

      final token = await storage.getToken();

      if (token == null || token.isEmpty) {
        await sessionManager.clear();
        return false;
      }

      await sessionManager.setSession(
        token: token,
        user: user,
      );

      return true;
    } catch (_) {
      await sessionManager.clear();
      currentUser.value = null;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // sai da conta: avisa a api, limpa o token e volta pro login
  Future<void> logout() async {
    isLoading.value = true;

    try {
      try {
        await authService.logout(await storage.getRefreshToken());
      // se a api falhar no logout tudo bem, a gente limpa local mesmo
      } catch (_) {}

      await sessionManager.clear();
      currentUser.value = null;

      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }

  // busca de novo os dados do usuario (depois de editar o perfil)
  Future<void> refreshCurrentUser() async {
    currentUser.value = await authService.me();

    final token = await storage.getToken();

    if (token != null && token.isNotEmpty) {
      await sessionManager.setSession(
        token: token,
        user: currentUser.value!,
      );
    }
  }
}
