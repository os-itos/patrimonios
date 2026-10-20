class Historico {
  final int id;
  final String acao;
  final int? professorId;
  final String? professorNome;
  final String? motivo;
  final DateTime? data;

  const Historico({
    required this.id,
    required this.acao,
    this.professorId,
    this.professorNome,
    this.motivo,
    this.data,
  });

  factory Historico.fromJson(Map<String, dynamic> json) {
    return Historico(
      id: (json['id'] as num).toInt(),
      acao: json['acao']?.toString() ?? '',
      professorId:
          (json['professorId'] as num?)?.toInt(),
      professorNome: json['professorNome']?.toString(),
      motivo: json['motivo']?.toString(),
      data: json['dataRegistro'] != null
          ? DateTime.tryParse(
              json['dataRegistro'].toString(),
            )
          : null,
    );
  }
}
