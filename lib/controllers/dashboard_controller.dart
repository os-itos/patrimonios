import 'package:get/get.dart';

import '../models/dashboard.dart';
import '../services/dashboard_service.dart';

// busca os numeros do painel do coordenador
class DashboardController extends GetxController {
  final DashboardService service;

  final RxBool isLoading = false.obs;
  final Rxn<Dashboard> dashboard = Rxn<Dashboard>();
  final RxString errorMessage = ''.obs;

  DashboardController(this.service);

  Future<void> carregar() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      dashboard.value = await service.buscar();
    } catch (error) {
      errorMessage.value = error.toString();
      // joga o erro de novo pra tela decidir o que fazer
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
