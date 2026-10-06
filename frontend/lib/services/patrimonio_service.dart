import '../models/historico.dart';
import '../models/patrimonio.dart';
import 'api_service.dart';

class PatrimonioService {
  final ApiService api;

  const PatrimonioService(this.api);

  Future<List<Patrimonio>> listar({
    StatusPatrimonio? status,
    String? categoria,
    String? busca,
  }) async {
    final query = <String, String>{};

    if (status != null) {
      query['status'] = status.apiValue;
    }

    if (categoria != null &&
        categoria.trim().isNotEmpty) {
      query['categoria'] = categoria.trim();
    }

    if (busca != null &&
        busca.trim().isNotEmpty) {
      query['busca'] = busca.trim();
    }

    final response = await api.get(
      '/patrimonios',
      queryParameters:
          query.isEmpty ? null : query,
    );

    final list = List<dynamic>.from(response as List);

    return list
        .map(
          (item) => Patrimonio.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<Patrimonio> buscar(int id) async {
    final response = await api.get(
      '/patrimonios/$id',
    );

    return Patrimonio.fromJson(
      Map<String, dynamic>.from(response as Map),
    );
  }

  Future<void> cadastrar({
    required String tombamento,
    required String descricao,
    required String categoria,
    String? marca,
    String? numeroSerie,
    String? localizacao,
    StatusPatrimonio status = StatusPatrimonio.disponivel,
  }) async {
    await api.post(
      '/patrimonios',
      body: {
        'tombamento': tombamento,
        'descricao': descricao,
        'categoria': categoria,
        'marca': marca,
        'numero_serie': numeroSerie,
        'localizacao': localizacao,
        'status': status.apiValue,
      },
    );
  }

  Future<void> atualizar({
    required int id,
    String? descricao,
    String? categoria,
    String? marca,
    String? numeroSerie,
    String? localizacao,
    StatusPatrimonio? status,
  }) async {
    await api.put(
      '/patrimonios/$id',
      body: {
        'descricao': descricao,
        'categoria': categoria,
        'marca': marca,
        'numero_serie': numeroSerie,
        'localizacao': localizacao,
        'status': status?.apiValue,
      },
    );
  }

  Future<void> excluir(int id) async {
    await api.delete('/patrimonios/$id');
  }

  Future<void> atribuir({
    required int patrimonioId,
    required int professorId,
  }) async {
    await api.post(
      '/patrimonios/$patrimonioId/atribuir',
      body: {
        'professor_id': professorId,
      },
    );
  }

  Future<void> devolver({
    required int patrimonioId,
    String? motivo,
  }) async {
    await api.post(
      '/patrimonios/$patrimonioId/devolver',
      body: {
        'motivo': motivo,
      },
    );
  }

  Future<List<Historico>> historico(
    int patrimonioId,
  ) async {
    final response = await api.get(
      '/patrimonios/$patrimonioId/historico',
    );

    final list = List<dynamic>.from(response as List);

    return list
        .map(
          (item) => Historico.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
