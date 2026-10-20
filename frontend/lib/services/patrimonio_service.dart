import '../models/historico.dart';
import '../models/patrimonio.dart';
import 'api_service.dart';

class PatrimonioService {
  final ApiService api;

  const PatrimonioService(this.api);

  /// Admin recebe todos os bens; professor recebe só os dele (RBAC na API).
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

    // Resposta: { "total": 3, "role": "...", "items": [ ... ] }
    final list = List<dynamic>.from(
      (response as Map)['items'] as List? ?? const [],
    );

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
    required String nome,
    required String categoria,
    String? descricao,
    String? marca,
    String? modelo,
    String? numeroSerie,
    String? estadoConservacao,
    String? localizacao,
    String? observacoes,
  }) async {
    await api.post(
      '/patrimonios',
      body: {
        'codigo': tombamento,
        'nome': nome,
        'categoria': categoria,
        if (descricao != null) 'descricao': descricao,
        if (marca != null) 'marca': marca,
        if (modelo != null) 'modelo': modelo,
        if (numeroSerie != null) 'numeroSerie': numeroSerie,
        if (estadoConservacao != null) 'estadoConservacao': estadoConservacao,
        if (localizacao != null) 'localizacao': localizacao,
        if (observacoes != null) 'observacoes': observacoes,
      },
    );
  }

  Future<void> atualizar({
    required int id,
    String? nome,
    String? descricao,
    String? categoria,
    String? marca,
    String? modelo,
    String? numeroSerie,
    String? estadoConservacao,
    String? localizacao,
    String? observacoes,
    StatusPatrimonio? status,
  }) async {
    await api.put(
      '/patrimonios/$id',
      body: {
        if (nome != null) 'nome': nome,
        if (descricao != null) 'descricao': descricao,
        if (categoria != null) 'categoria': categoria,
        if (marca != null) 'marca': marca,
        if (modelo != null) 'modelo': modelo,
        if (numeroSerie != null) 'numeroSerie': numeroSerie,
        if (estadoConservacao != null) 'estadoConservacao': estadoConservacao,
        if (localizacao != null) 'localizacao': localizacao,
        if (observacoes != null) 'observacoes': observacoes,
        if (status != null) 'status': status.apiValue,
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
      '/admin/patrimonios/$patrimonioId/atribuir',
      body: {
        'professorId': professorId,
      },
    );
  }

  Future<void> devolver({
    required int patrimonioId,
    String? motivo,
  }) async {
    await api.post(
      '/admin/patrimonios/$patrimonioId/desatribuir',
      body: {
        if (motivo != null) 'motivo': motivo,
      },
    );
  }

  Future<List<Historico>> historico(
    int patrimonioId,
  ) async {
    final response = await api.get(
      '/admin/patrimonios/$patrimonioId/historico',
    );

    // Resposta: { "patrimonioId": 1, "total": 2, "historico": [ ... ] }
    final list = List<dynamic>.from(
      (response as Map)['historico'] as List? ?? const [],
    );

    return list
        .map(
          (item) => Historico.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
