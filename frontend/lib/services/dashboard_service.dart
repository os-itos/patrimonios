import '../models/dashboard.dart';
import 'api_service.dart';

class DashboardService {
  final ApiService api;

  const DashboardService(this.api);

  Future<Dashboard> buscar() async {
    final response = await api.get('/dashboard');

    return Dashboard.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }
}
