class Dashboard {
  final int totalBens;
  final int disponiveis;
  final int emUso;
  final int emManutencao;
  final Map<String, int> categorias;

  const Dashboard({
    required this.totalBens,
    required this.disponiveis,
    required this.emUso,
    required this.emManutencao,
    required this.categorias,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    final rawCategorias = json['categorias'];

    final categorias = <String, int>{};

    if (rawCategorias is Map) {
      for (final entry in rawCategorias.entries) {
        categorias[
          entry.key.toString()
        ] = (entry.value as num).toInt();
      }
    }

    return Dashboard(
      totalBens: (json['total_bens'] as num?)?.toInt() ?? 0,
      disponiveis:
          (json['disponiveis'] as num?)?.toInt() ?? 0,
      emUso: (json['em_uso'] as num?)?.toInt() ?? 0,
      emManutencao:
          (json['em_manutencao'] as num?)?.toInt() ?? 0,
      categorias: categorias,
    );
  }
}
