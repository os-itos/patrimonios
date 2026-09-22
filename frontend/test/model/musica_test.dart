import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/patrimonio_dados.dart';

void main() {
  group('Testes do Model Patrimonio', () {
      test('Deve converter JSON para objeto Patrimonio (fromJson)', () {
      final json = {
        'id': 1,
        'nome': 'cadeira',
        'descricao': 'cadeira de madeira',
        'local': 'C13',
        'responsavel': 'Thiagão',
      };

      final patrimonio = Patrimonio.fromJson(json);

      expect(patrimonio.id, 1);
      expect(patrimonio.nome, 'cadeira');
      expect(patrimonio.descricao, 'cadeira de madeira');
      expect(patrimonio.local, 'C13');
      expect(patrimonio.responsavel, 'Thiagão');
    });

    test('Deve converter objeto Patrimonio para JSON (toJson)', () {
      final patrimonio = Patrimonio(
        id: 2,
        nome: 'mesa',
        descricao: 'mesa de vidro',
        local: 'C14',
        responsavel: 'Maria',
      );

      final json = patrimonio.toJson();

      expect(json['id'], 2);
      expect(json['nome'], 'mesa');
      expect(json['descricao'], 'mesa de vidro');
      expect(json['local'], 'C14');
      expect(json['responsavel'], 'Maria');
    });

    test('Teste de conversão Patrimonio -> JSON', () {
      final patrimonio = Patrimonio(
        id: 1,
        nome: 'Cadeira',
        descricao: 'Giratória',
        local: 'C14',
        responsavel: 'Maria',
      );

      final json = patrimonio.toJson();

      expect(json['local'], 'C14');
      expect(json['responsavel'], 'Maria');
    });

    test('Teste de conversão: JSON -> Patrimonio -> JSON', () {
      final jsonOriginal = {
        'id': 3,
        'nome': 'Monitor',
        'descricao': 'Monitor 27 polegadas',
        'local': 'C09',
        'responsavel': 'Alecrim',
      };

      final patrimonio = Patrimonio.fromJson(jsonOriginal);
      final jsonConvertido = patrimonio.toJson();

      expect(jsonConvertido, jsonOriginal);
    });
  });
}