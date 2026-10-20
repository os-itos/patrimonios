// numeros do painel do coordenador
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

  // isso aqui vem da rota /admin/patrimonios/stats
  factory Dashboard.fromJson(Map<String, dynamic> json) {
    final rawCategorias = json['porCategoria'];

    final categorias = <String, int>{};

    if (rawCategorias is Map) {
      for (final entry in rawCategorias.entries) {
        categorias[
          entry.key.toString()
        ] = (entry.value as num).toInt();
      }
    }

    return Dashboard(
      totalBens: (json['totalPatrimonios'] as num?)?.toInt() ?? 0,
      disponiveis:
          (json['patrimoniosDisponiveis'] as num?)?.toInt() ?? 0,
      emUso: (json['patrimoniosEmUso'] as num?)?.toInt() ?? 0,
      emManutencao:
          (json['patrimoniosEmManutencao'] as num?)?.toInt() ?? 0,
      categorias: categorias,
    );
  }
}
