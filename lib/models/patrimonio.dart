// status que um patrimonio pode ter na api
enum StatusPatrimonio {
  disponivel,
  emUso,
  emManutencao,
  baixado;

  // converte o texto da api pro enum
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

  // o contrario: do enum pro texto que a api espera
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

  // texto pra mostrar na tela
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

// um bem da escola (notebook, projetor, etc)
class Patrimonio {
  final int id;

  // na api esse campo se chama codigo, aqui a gente chama de tombamento
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

  // monta o patrimonio a partir do json da api
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
      // algumas respostas usam responsavel no lugar de professor
      professorId: ((json['professorId'] ?? json['responsavelId']) as num?)
          ?.toInt(),
      professorNome:
          _texto(json['professorNome'] ?? json['responsavelNome']),
      dataAtribuicao: json['dataAtribuicao'] != null
          ? DateTime.tryParse(json['dataAtribuicao'].toString())
          : null,
    );
  }

  // a api manda "" quando o campo ta vazio, ai a gente trata como null
  static String? _texto(dynamic valor) {
    final texto = valor?.toString();
    return (texto == null || texto.isEmpty) ? null : texto;
  }
}
