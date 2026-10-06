import 'package:get/get.dart';

import '../models/dashboard.dart';
import '../services/dashboard_service.dart';

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
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
