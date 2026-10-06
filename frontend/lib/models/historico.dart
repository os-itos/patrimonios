class Historico {
  final int id;
  final String acao;
  final int? professorId;
  final String? motivo;
  final DateTime? data;

  const Historico({
    required this.id,
    required this.acao,
    this.professorId,
    this.motivo,
    this.data,
  });

  factory Historico.fromJson(Map<String, dynamic> json) {
    return Historico(
      id: (json['id'] as num).toInt(),
      acao: json['acao']?.toString() ?? '',
      professorId:
          (json['professor_id'] as num?)?.toInt(),
      motivo: json['motivo']?.toString(),
      data: json['data'] != null
          ? DateTime.tryParse(
              json['data'].toString(),
            )
          : null,
    );
  }
}
