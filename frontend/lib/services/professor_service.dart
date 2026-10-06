import '../models/professor.dart';
import 'api_service.dart';

class ProfessorService {
  final ApiService api;

  const ProfessorService(this.api);

  Future<List<Professor>> listar() async {
    final response = await api.get('/professores');

    final list = List<dynamic>.from(response as List);

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
      '/professores/$id',
    );

    return Professor.fromJson(
      Map<String, dynamic>.from(response as Map),
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
      '/professores',
      body: {
        'nome': nome,
        'email': email,
        'senha': senha,
        'telefone': telefone,
        'matricula': matricula,
        'departamento': departamento,
      },
    );
  }
}
