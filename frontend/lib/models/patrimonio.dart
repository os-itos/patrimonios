enum StatusPatrimonio {
  disponivel,
  emUso,
  emManutencao;

  static StatusPatrimonio fromString(String value) {
    switch (value.toLowerCase()) {
      case 'disponivel':
        return StatusPatrimonio.disponivel;
      case 'em_uso':
        return StatusPatrimonio.emUso;
      case 'em_manutencao':
        return StatusPatrimonio.emManutencao;
      default:
        throw ArgumentError(
          'Status invalido: $value',
        );
    }
  }

  String get apiValue {
    switch (this) {
      case StatusPatrimonio.disponivel:
        return 'disponivel';
      case StatusPatrimonio.emUso:
        return 'em_uso';
      case StatusPatrimonio.emManutencao:
        return 'em_manutencao';
    }
  }

  String get label {
    switch (this) {
      case StatusPatrimonio.disponivel:
        return 'Disponivel';
      case StatusPatrimonio.emUso:
        return 'Em uso';
      case StatusPatrimonio.emManutencao:
        return 'Em manutencao';
    }
  }
}

class Patrimonio {
  final int id;
  final String tombamento;
  final String descricao;
  final String categoria;
  final String? marca;
  final String? numeroSerie;
  final String? localizacao;
  final StatusPatrimonio status;
  final int? professorId;
  final DateTime? dataAtribuicao;

  const Patrimonio({
    required this.id,
    required this.tombamento,
    required this.descricao,
    required this.categoria,
    this.marca,
    this.numeroSerie,
    this.localizacao,
    required this.status,
    this.professorId,
    this.dataAtribuicao,
  });

  factory Patrimonio.fromJson(Map<String, dynamic> json) {
    return Patrimonio(
      id: (json['id'] as num).toInt(),
      tombamento: json['tombamento']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      marca: json['marca']?.toString(),
      numeroSerie: json['numero_serie']?.toString(),
      localizacao: json['localizacao']?.toString(),
      status: StatusPatrimonio.fromString(
        json['status']?.toString() ?? 'disponivel',
      ),
      professorId:
          (json['professor_id'] as num?)?.toInt(),
      dataAtribuicao:
          json['data_atribuicao'] != null
              ? DateTime.tryParse(
                  json['data_atribuicao'].toString(),
                )
              : null,
    );
  }
}
