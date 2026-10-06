import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../models/usuario.dart';
import 'storage_service.dart';

class SessionManager {
  final StorageService storage;

  final RxBool isAuthenticated = false.obs;
  final Rxn<Usuario> user = Rxn<Usuario>();

  SessionManager(this.storage);

  String? get tokenCache =>
      isAuthenticated.value ? _token : null;

  String? _token;

  Future<void> setSession({
    required String token,
    required Usuario user,
  }) async {
    _token = token;
    isAuthenticated.value = true;
    this.user.value = user;

    await storage.saveToken(token);
    await storage.saveUser(user);
  }

  Future<void> loadStoredSession() async {
    final token = await storage.getToken();
    final user = await storage.getUser();

    _token = token;
    isAuthenticated.value =
        token != null && token.isNotEmpty && user != null;
    this.user.value = user;
  }

  Future<void> clear() async {
    _token = null;
    isAuthenticated.value = false;
    user.value = null;

    await storage.clearSession();
  }

  Future<void> expireSession() async {
    await clear();

    if (Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
