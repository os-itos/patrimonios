class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const cadastro = '/cadastro';
  static const recuperacao = '/recuperacao';

  static const admin = '/admin';
  static const adminProfessores = '/admin/professores';
  static const adminCadastrarProfessor =
      '/admin/professores/cadastrar';
  static const adminDetalhesProfessor =
      '/admin/professores/detalhes';

  static const adminPatrimonios = '/admin/patrimonios';
  static const adminCadastrarPatrimonio =
      '/admin/patrimonios/cadastrar';
  static const adminDetalhesPatrimonio =
      '/admin/patrimonios/detalhes';
  static const adminAtribuirPatrimonio =
      '/admin/patrimonios/atribuir';
  static const adminDevolverPatrimonio =
      '/admin/patrimonios/devolver';
  static const adminHistoricoPatrimonio =
      '/admin/patrimonios/historico';

  static const professor = '/professor';
  static const professorPatrimonios =
      '/professor/patrimonios';
  static const professorPerfil = '/professor/perfil';
  static const professorSenha = '/professor/senha';
  static const adminEditarPatrimonio =
    '/admin/patrimonios/editar';
}
