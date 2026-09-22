import 'package:get/get.dart';
import '../models/patrimonio_dados.dart';

class PatrimonioService extends GetConnect {
  @override
  void onInit() {
    // Configura a URL base e o cabeçalho padrão das requisições
    baseUrl = 'http://127.0.0.1:8000'; 
    httpClient.defaultContentType = 'application/json';
    super.onInit();
  }

  // GET /patrimonios - Listar todos
  Future<Response<List<Patrimonio>>> listar() async {
    return await get<List<Patrimonio>>(
      '/patrimonios',
      decoder: (data) {
        if (data is List) {
          return data.map((e) => Patrimonio.fromJson(e as Map<String, dynamic>)).toList();
        }
        return <Patrimonio>[];
      },
    );
  }

  // GET /patrimonios/{id} - Buscar por ID (alinhado com o controller)
  Future<Response<Patrimonio?>> obterPorId(int id) async {
    return await get<Patrimonio?>(
      '/patrimonios/$id',
      decoder: (data) => _decodePatrimonio(data),
    );
  }

  // POST /patrimonios - Cadastrar novo
  Future<Response<Patrimonio?>> cadastrar(Patrimonio patrimonio) async {
    return await post<Patrimonio?>(
      '/patrimonios',
      patrimonio.toJson(),
      decoder: (data) => _decodePatrimonio(data),
    );
  }

  // PUT /patrimonios/{id} - Atualizar existente
  Future<Response<Patrimonio?>> atualizar(int id, Patrimonio patrimonio) async {
    return await put<Patrimonio?>(
      '/patrimonios/$id',
      patrimonio.toJson(),
      decoder: (data) => _decodePatrimonio(data),
    );
  }

  // DELETE /patrimonios/{id} - Excluir por ID
  Future<Response<void>> excluir(int id) async {
    return await delete('/patrimonios/$id');
  }

  // Helper privado para decodificar um único objeto Patrimonio com segurança de tipos
  Patrimonio? _decodePatrimonio(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Patrimonio.fromJson(data);
    }
    return null;
  }
}