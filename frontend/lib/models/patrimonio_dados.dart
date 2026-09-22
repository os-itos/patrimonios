class Patrimonio {
  int? id;
  String? codigo;
  String nome;
  String descricao;
  String local;
  String responsavel;

  Patrimonio({
    this.id,
    this.codigo,
    required this.nome,
    required this.descricao,
    required this.local,
    required this.responsavel,
  });

  // Construtor factory com tratamento contra nulos e tipagem explícita
  factory Patrimonio.fromJson(Map<String, dynamic> json) {
    return Patrimonio(
      id: json['id'] as int?,
      codigo: json['codigo'] as String?,
      nome: json['nome'] as String? ?? '',
      descricao: json['descricao'] as String? ?? '',
      local: json['local'] as String? ?? '',
      responsavel: json['responsavel'] as String? ?? '',
    );
  }

  // Serialização para JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nome': nome,
      'descricao': descricao,
      'local': local,
      'responsavel': responsavel,
    };
    if (id != null) {
      data['id'] = id;
    }
    if (codigo != null) {
      data['codigo'] = codigo;
    }
    return data;
  }

  // Permite criar uma cópia alterando apenas alguns campos (muito útil em formulários de edição)
  Patrimonio copyWith({
    int? id,
    String? codigo,
    String? nome,
    String? descricao,
    String? local,
    String? responsavel,
  }) {
    return Patrimonio(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      local: local ?? this.local,
      responsavel: responsavel ?? this.responsavel,
    );
  }

  @override
  String toString() {
    return 'Patrimonio(id: $id, codigo: $codigo, nome: $nome, local: $local, responsavel: $responsavel)';
  }
}