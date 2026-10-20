import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../models/usuario.dart';
import 'storage_service.dart';

// guarda a sessao em memoria (token e usuario) e salva no storage
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
    String? refreshToken,
  }) async {
    _token = token;
    isAuthenticated.value = true;
    this.user.value = user;

    await storage.saveToken(token);
    await storage.saveUser(user);

    if (refreshToken != null) {
      await storage.saveRefreshToken(refreshToken);
    }
  }

  // le o que ficou salvo da ultima vez que o app abriu
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

  // chamado quando a api responde 401
  Future<void> expireSession() async {
    await clear();

    // quando o app ta abrindo (restaurando sessao) ainda nao tem tela nenhuma
    if (Get.key.currentState != null &&
        Get.currentRoute != AppRoutes.login) {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
