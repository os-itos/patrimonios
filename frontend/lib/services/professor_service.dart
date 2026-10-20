import '../models/professor.dart';
import 'api_service.dart';

class ProfessorService {
  final ApiService api;

  const ProfessorService(this.api);

  Future<List<Professor>> listar() async {
    final response = await api.get('/admin/professores');

    // Resposta: { "total": 2, "professores": [ ... ] }
    final list = List<dynamic>.from(
      (response as Map)['professores'] as List? ?? const [],
    );

    return list
        .map(
          (item) => Professor.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<Professor> buscar(int id) async {
    final response = await api.get(
      '/admin/professores/$id',
    );

    // Resposta: { "professor": { ... }, "patrimonios": [ ... ] }
    final data = Map<String, dynamic>.from(response as Map);

    return Professor.fromJson(
      Map<String, dynamic>.from(data['professor'] as Map),
      patrimonios: data['patrimonios'] as List?,
    );
  }

  Future<void> cadastrar({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
    String? matricula,
    String? departamento,
  }) async {
    await api.post(
      '/admin/professores',
      body: {
        'nome': nome,
        'email': email,
        'password': senha,
        if (telefone != null) 'telefone': telefone,
        if (matricula != null) 'matricula': matricula,
        if (departamento != null) 'departamento': departamento,
      },
    );
  }
}
