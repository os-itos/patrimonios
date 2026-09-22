import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../../lib/models/patrimonio_dados.dart';
import '../../lib/services/patrimonio_service.dart';

void main() {
  late PatrimonioService service;

  setUpAll(() {
    service = Get.put(PatrimonioService());
    service.baseUrl = 'http://localhost:8000';
  });

  group('Testes do PatrimonioService', () {
    test('Deve listar os patrimônios (GET /patrimonios)', () async {
      final response = await service.listar();

      expect(response.isOk, true);
      expect(response.body, isA<List<Patrimonio>>());
      expect(response.body!.isNotEmpty, true);
    });

    test('Deve buscar um patrimônio por ID existente (GET /patrimonios/{id})', () async {
      final response = await service.buscar(1);

      expect(response.statusCode, 200);
      expect(response.body, isA<Patrimonio>());
      expect(response.body!.id, 1);
    });

    test('Deve cadastrar um novo patrimônio (POST /patrimonios)', () async {
      final novoPatrimonio = Patrimonio(
        nome: 'Projetor EPSON Teste',
        descricao: 'Projetor Full HD para testes',
        local: 'Lab 01',
        responsavel: 'João',
      );

      final response = await service.cadastrar(novoPatrimonio);

      expect(response.isOk, true);
      expect(response.body, isA<Patrimonio>());
      expect(response.body!.id, isNotNull);
      expect(response.body!.nome, 'Projetor EPSON Teste');
    });

    test('Deve atualizar um patrimônio existente (PUT /patrimonios/{id})', () async {
      final patrimonioModificado = Patrimonio(
        id: 1,
        nome: 'Cadeira Atualizada',
        descricao: 'Cadeira de madeira atualizada',
        local: 'C13',
        responsavel: 'Thiagão',
      );

      final response = await service.atualizar(1, patrimonioModificado);

      expect(response.statusCode, 200);
      expect(response.body!.nome, 'Cadeira Atualizada');
    });

    test('Deve excluir um patrimônio existente (DELETE /patrimonios/{id})', () async {
  
      final responseDelete = await service.excluir(2);
      expect(responseDelete.statusCode, 200);

      final responseBusca = await service.buscar(2);
      expect(responseBusca.statusCode, 404);
    });

    group('Testes de Erro', () {
      test('Deve retornar 404 ao buscar patrimônio inexistente', () async {
        final response = await service.buscar(999);
        expect(response.statusCode, 404);
      });

      test('Deve retornar erro ao tentar excluir patrimônio inexistente', () async {
        final response = await service.excluir(999);
        expect(response.statusCode, 404);
      });

      test('Deve retornar erro (422 Unprocessable Entity) com dados inválidos', () async {
        final response = await service.post('/patrimonios', {
          "nome": "Sem descrição e local obrigatórios"
        });

        expect(response.statusCode, 422);
      });
    });
  });
}