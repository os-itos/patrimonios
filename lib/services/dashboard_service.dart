import '../models/dashboard.dart';
import 'api_service.dart';

// metricas do painel do coordenador
class DashboardService {
  final ApiService api;

  const DashboardService(this.api);

  Future<Dashboard> buscar() async {
    final response = await api.get('/admin/patrimonios/stats');

    return Dashboard.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }
}
