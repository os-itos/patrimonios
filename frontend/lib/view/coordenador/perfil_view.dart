import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/app/routes/app_routes.dart';
import '/controllers/auth_controller.dart';
import '/controllers/perfil_controller.dart';
import '/models/usuario.dart';

/// Rota: [AppRoutes.professorPerfil] 
class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final PerfilController controller = Get.find<PerfilController>();
  final AuthController auth = Get.find<AuthController>();

  static const _background = Color(0xFFF3F5F9);
  static const _border = Color(0xFFE3E7EE);
  static const _title = Color(0xFF1F2937);
  static const _subtitle = Color(0xFF6B7280);
  static const _blue = Color(0xFF2563EB);
  static const _blueLight = Color(0xFFEAF1FF);
  static const _red = Color(0xFFDC2626);

  // A API (/me) não retorna dados da escola; ajuste aqui ou
  // mova para um service/endpoint quando existir.
  static const _nomeEscola = 'Escola Estadual D. Pedro II';
  static const _cnpj = '12.345.678/0001-90';
  static const _endereco = 'Av. Paulista, 1000 - São Paulo/SP';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  Future<void> _carregar() async {
    try {
      await controller.carregar();
    } catch (_) {
      // O erro fica em controller.errorMessage.
    }
  }

  void _mostrarMensagem(String texto, {bool erro = false}) {
    Get.snackbar(
      erro ? 'Erro' : 'Sucesso',
      texto,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      backgroundColor: erro ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
      colorText: _title,
    );
  }

  Future<void> _editarDados(Usuario usuario) async {
    final nomeCtrl = TextEditingController(text: usuario.nome);
    final telefoneCtrl = TextEditingController(text: usuario.telefone ?? '');

    final salvar = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Editar Dados'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: telefoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () => Get.back(result: true),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    final nome = nomeCtrl.text.trim();
    final telefone = telefoneCtrl.text.trim();
    nomeCtrl.dispose();
    telefoneCtrl.dispose();

    if (salvar != true) return;

    if (nome.isEmpty) {
      _mostrarMensagem('O nome não pode ficar vazio.', erro: true);
      return;
    }

    try {
      await controller.atualizar(
        nome: nome,
        telefone: telefone.isEmpty ? null : telefone,
      );
      await auth.refreshCurrentUser();
      _mostrarMensagem('Dados atualizados com sucesso.');
    } catch (error) {
      _mostrarMensagem(error.toString(), erro: true);
    }
  }

  Future<void> _alterarSenha() async {
    final atualCtrl = TextEditingController();
    final novaCtrl = TextEditingController();
    final confirmaCtrl = TextEditingController();

    final salvar = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Alterar Senha'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: atualCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha atual'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: novaCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nova senha'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmaCtrl,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirmar nova senha'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(100, 44)),
            onPressed: () => Get.back(result: true),
            child: const Text('Alterar'),
          ),
        ],
      ),
    );

    final atual = atualCtrl.text;
    final nova = novaCtrl.text;
    final confirma = confirmaCtrl.text;
    atualCtrl.dispose();
    novaCtrl.dispose();
    confirmaCtrl.dispose();

    if (salvar != true) return;

    if (atual.isEmpty || nova.isEmpty) {
      _mostrarMensagem('Preencha todos os campos.', erro: true);
      return;
    }
    if (nova != confirma) {
      _mostrarMensagem('A confirmação não confere com a nova senha.',
          erro: true);
      return;
    }

    try {
      await controller.alterarSenha(senhaAtual: atual, novaSenha: nova);
      _mostrarMensagem('Senha alterada com sucesso.');
    } catch (error) {
      _mostrarMensagem(error.toString(), erro: true);
    }
  }

  Future<void> _sair() async {
    final confirmar = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Sair', style: TextStyle(color: _red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await auth.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: _title,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(() {
        final usuario = controller.usuario.value ?? auth.currentUser.value;

        if (usuario == null) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value.isNotEmpty
                        ? controller.errorMessage.value
                        : 'Não foi possível carregar o perfil.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _subtitle),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _carregar,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _carregar,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _buildUsuarioCard(usuario),
              const SizedBox(height: 16),
              _buildInstituicaoCard(),
              const SizedBox(height: 16),
              _buildOutlinedButton('Editar Dados', () => _editarDados(usuario)),
              const SizedBox(height: 12),
              _buildOutlinedButton('Alterar Senha', _alterarSenha),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: _sair,
                  child: const Text(
                    'Sair',
                    style: TextStyle(
                      color: _red,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }

  Widget _buildUsuarioCard(Usuario usuario) {
    final inicial =
        usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : '?';
    final cargo = usuario.isAdmin ? 'Coordenador Geral' : 'Professor';

    return _buildCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: _blueLight,
            child: Text(
              inicial,
              style: const TextStyle(
                color: _blue,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, ${usuario.nome}',
                  style: const TextStyle(
                    color: _title,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  usuario.email,
                  style: const TextStyle(color: _subtitle, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _blueLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    cargo,
                    style: const TextStyle(
                      color: _blue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstituicaoCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dados da Instituição',
            style: TextStyle(
              color: _title,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _border),
          const SizedBox(height: 12),
          _buildInfo('Nome da Escola', _nomeEscola),
          const SizedBox(height: 12),
          _buildInfo('CNPJ', _cnpj),
          const SizedBox(height: 12),
          _buildInfo('Endereço', _endereco),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _subtitle,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: const TextStyle(color: _title, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildOutlinedButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _blue,
          backgroundColor: Colors.white,
          side: const BorderSide(color: _blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: _blue,
        unselectedItemColor: _subtitle,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed(AppRoutes.admin);
              break;
            case 1:
              Get.offAllNamed(AppRoutes.adminPatrimonios);
              break;
            case 2:
              Get.offAllNamed(AppRoutes.adminProfessores);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Patrimônios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Professores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}