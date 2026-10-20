enum StatusPatrimonio {
  disponivel,
  emUso,
  emManutencao,
  baixado;

  static StatusPatrimonio fromString(String value) {
    switch (value.toLowerCase()) {
      case 'disponivel':
        return StatusPatrimonio.disponivel;
      case 'em_uso':
        return StatusPatrimonio.emUso;
      case 'em_manutencao':
        return StatusPatrimonio.emManutencao;
      case 'baixado':
        return StatusPatrimonio.baixado;
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
      case StatusPatrimonio.baixado:
        return 'baixado';
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
      case StatusPatrimonio.baixado:
        return 'Baixado';
    }
  }
}

class Patrimonio {
  final int id;

  /// Código de tombamento (campo `codigo` na API).
  final String tombamento;
  final String nome;
  final String descricao;
  final String categoria;
  final String? marca;
  final String? modelo;
  final String? numeroSerie;
  final String? estadoConservacao;
  final String? localizacao;
  final String? observacoes;
  final StatusPatrimonio status;
  final int? professorId;
  final String? professorNome;
  final DateTime? dataAtribuicao;

  const Patrimonio({
    required this.id,
    required this.tombamento,
    required this.nome,
    this.descricao = '',
    required this.categoria,
    this.marca,
    this.modelo,
    this.numeroSerie,
    this.estadoConservacao,
    this.localizacao,
    this.observacoes,
    required this.status,
    this.professorId,
    this.professorNome,
    this.dataAtribuicao,
  });

  factory Patrimonio.fromJson(Map<String, dynamic> json) {
    return Patrimonio(
      id: (json['id'] as num).toInt(),
      tombamento: json['codigo']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? '',
      marca: _texto(json['marca']),
      modelo: _texto(json['modelo']),
      numeroSerie: _texto(json['numeroSerie']),
      estadoConservacao: _texto(json['estadoConservacao']),
      localizacao: _texto(json['localizacao']),
      observacoes: _texto(json['observacoes']),
      status: StatusPatrimonio.fromString(
        json['status']?.toString() ?? 'disponivel',
      ),
      professorId: ((json['professorId'] ?? json['responsavelId']) as num?)
          ?.toInt(),
      professorNome:
          _texto(json['professorNome'] ?? json['responsavelNome']),
      dataAtribuicao: json['dataAtribuicao'] != null
          ? DateTime.tryParse(json['dataAtribuicao'].toString())
          : null,
    );
  }

  /// A API devolve "" para campos não preenchidos; tratamos como nulo.
  static String? _texto(dynamic valor) {
    final texto = valor?.toString();
    return (texto == null || texto.isEmpty) ? null : texto;
  }
}
