import 'patrimonio.dart';

class Professor {
  final int id;
  final String nome;
  final String email;
  final String? telefone;
  final String? matricula;
  final String? departamento;
  final int quantidadePatrimonios;
  final List<Patrimonio> patrimonios;

  const Professor({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.matricula,
    this.departamento,
    this.quantidadePatrimonios = 0,
    this.patrimonios = const [],
  });

  factory Professor.fromJson(Map<String, dynamic> json) {
    final rawPatrimonios = json['patrimonios'];

    return Professor(
      id: (json['id'] as num).toInt(),
      nome: json['nome']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefone: json['telefone']?.toString(),
      matricula: json['matricula']?.toString(),
      departamento: json['departamento']?.toString(),
      quantidadePatrimonios:
          (json['quantidade_patrimonios'] as num?)?.toInt() ??
          (rawPatrimonios is List ? rawPatrimonios.length : 0),
      patrimonios: rawPatrimonios is List
          ? rawPatrimonios
              .map(
                (item) => Patrimonio.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList()
          : const [],
    );
  }
}
