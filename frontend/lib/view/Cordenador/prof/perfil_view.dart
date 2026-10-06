import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/perfil_controller.dart';
import '../../../core/errors/api_exception.dart';
import '../../../models/usuario.dart';

class _C {
  const _C._();

  static const text = Color(0xFF1F2937);
  static const muted = Color(0xFF6B7280);
  static const primary = Color(0xFF2563EB);
  static const border = Color(0xFFE5E7EB);
  static const danger = Color(0xFFDC2626);
}

/// Tela de perfil do usuário logado.
///
/// Usa o [PerfilController] (GET/PUT /api/me e PUT /api/me/senha) e o
/// [AuthController] para sair. Nenhuma chamada HTTP é feita aqui.
class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final PerfilController _controller = Get.find<PerfilController>();
  final AuthController _auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    try {
      await _controller.carregar();
    } catch (_) {}
  }

  String _mensagem(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }

  void _aviso(String titulo, String mensagem) {
    Get.snackbar(
      titulo,
      mensagem,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _editarDados(Usuario usuario) async {
    final resultado = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _EditarDadosDialog(usuario: usuario),
    );

    if (resultado == null) return;

    try {
      await _controller.atualizar(
        nome: resultado['nome'],
        telefone: resultado['telefone'],
      );

      // Mantém o nome exibido em outras telas (ex.: dashboard) em dia.
      await _auth.refreshCurrentUser();

      _aviso('Pronto', 'Dados atualizados com sucesso.');
    } catch (error) {
      _aviso('Não foi possível salvar', _mensagem(error));
    }
  }

  Future<void> _alterarSenha() async {
    final resultado = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const _AlterarSenhaDialog(),
    );

    if (resultado == null) return;

    try {
      await _controller.alterarSenha(
        senhaAtual: resultado['atual']!,
        novaSenha: resultado['nova']!,
      );

      _aviso('Pronto', 'Senha alterada com sucesso.');
    } catch (error) {
      _aviso('Não foi possível alterar a senha', _mensagem(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Perfil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _C.text,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final usuario = _controller.usuario.value;

          if (usuario == null) {
            if (_controller.errorMessage.value.isNotEmpty) {
              return _Erro(
                mensagem: _controller.errorMessage.value,
                onRetry: _carregar,
              );
            }

            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _carregar,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _CartaoUsuario(usuario: usuario),
                const SizedBox(height: 16),
                _CartaoVinculo(usuario: usuario),
                const SizedBox(height: 16),
                _BotaoContorno(
                  label: 'Editar Dados',
                  onPressed: () => _editarDados(usuario),
                ),
                const SizedBox(height: 12),
                _BotaoContorno(
                  label: 'Alterar Senha',
                  onPressed: _alterarSenha,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _auth.logout,
                  child: const Text(
                    'Sair',
                    style: TextStyle(
                      color: _C.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Cartões
// ---------------------------------------------------------------

class _CartaoUsuario extends StatelessWidget {
  final Usuario usuario;

  const _CartaoUsuario({required this.usuario});

  @override
  Widget build(BuildContext context) {
    final inicial =
        usuario.nome.trim().isEmpty ? '?' : usuario.nome.trim()[0].toUpperCase();

    final cargo = usuario.isAdmin ? 'Administrador' : 'Professor';
    final matricula = usuario.matricula;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoracao,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE0EAFF),
              shape: BoxShape.circle,
            ),
            child: Text(
              inicial,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _C.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usuario.nome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _C.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  usuario.email,
                  style: const TextStyle(fontSize: 13, color: _C.muted),
                ),
                if (matricula != null && matricula.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Matrícula: $matricula',
                    style: const TextStyle(fontSize: 13, color: _C.muted),
                  ),
                ],
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    cargo,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16A34A),
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
}

class _CartaoVinculo extends StatelessWidget {
  final Usuario usuario;

  const _CartaoVinculo({required this.usuario});

  @override
  Widget build(BuildContext context) {
    final departamento = usuario.departamento;
    final telefone = usuario.telefone;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _decoracao,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vínculo Institucional',
            style: TextStyle(fontSize: 14, color: _C.muted),
          ),
          const SizedBox(height: 4),
          Text(
            (departamento != null && departamento.isNotEmpty)
                ? departamento
                : 'Não informado',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _C.text,
            ),
          ),
          if (telefone != null && telefone.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Telefone',
              style: TextStyle(fontSize: 14, color: _C.muted),
            ),
            const SizedBox(height: 4),
            Text(
              telefone,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _C.text,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

final BoxDecoration _decoracao = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: _C.border),
);

class _BotaoContorno extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _BotaoContorno({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _C.primary,
          backgroundColor: Colors.white,
          side: const BorderSide(color: _C.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _Erro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onRetry;

  const _Erro({required this.mensagem, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: _C.muted),
            const SizedBox(height: 12),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _C.muted),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// Diálogos
// ---------------------------------------------------------------

class _EditarDadosDialog extends StatefulWidget {
  final Usuario usuario;

  const _EditarDadosDialog({required this.usuario});

  @override
  State<_EditarDadosDialog> createState() => _EditarDadosDialogState();
}

class _EditarDadosDialogState extends State<_EditarDadosDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome;
  late final TextEditingController _telefone;

  @override
  void initState() {
    super.initState();
    _nome = TextEditingController(text: widget.usuario.nome);
    _telefone = TextEditingController(text: widget.usuario.telefone ?? '');
  }

  @override
  void dispose() {
    _nome.dispose();
    _telefone.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop({
      'nome': _nome.text.trim(),
      'telefone': _telefone.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar dados'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nome,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(96, 40)),
          onPressed: _salvar,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

class _AlterarSenhaDialog extends StatefulWidget {
  const _AlterarSenhaDialog();

  @override
  State<_AlterarSenhaDialog> createState() => _AlterarSenhaDialogState();
}

class _AlterarSenhaDialogState extends State<_AlterarSenhaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _atual = TextEditingController();
  final _nova = TextEditingController();
  final _confirmar = TextEditingController();

  @override
  void dispose() {
    _atual.dispose();
    _nova.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop({
      'atual': _atual.text,
      'nova': _nova.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alterar senha'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _atual,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha atual'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a senha atual' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nova,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nova senha'),
                validator: (v) => (v == null || v.length < 6)
                    ? 'Use pelo menos 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmar,
                obscureText: true,
                decoration:
                    const InputDecoration(labelText: 'Confirmar nova senha'),
                validator: (v) =>
                    v != _nova.text ? 'As senhas não conferem' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(96, 40)),
          onPressed: _salvar,
          child: const Text('Alterar'),
        ),
      ],
    );
  }
}