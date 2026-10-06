import 'package/material.dart';
import 'package/get.dart';

class CadastroPatrimonioView extends StatefulWidget {
const CadastroPatrimonioView({super.key});

@override
State<CadastroPatrimonioView> createState() =>
_CadastroPatrimonioViewState();
}

class _CadastroPatrimonioViewState extends State<CadastroPatrimonioView> {
final _formKey = GlobalKey<FormState>();

final TextEditingController nomeController = TextEditingController();
final TextEditingController codigoController = TextEditingController();
final TextEditingController serieController = TextEditingController();
final TextEditingController observacoesController =
TextEditingController();

String? categoriaSelecionada;
String? estadoSelecionado;

final List<String> categorias = [
'Informática',
'Mobiliário',
'Eletrônicos',
'Ferramentas',
'Equipamentos',
'Outros',
];

final List<String> estados = [
'Novo',
'Bom',
'Regular',
'Ruim',
'Danificado',
];

@override
void dispose() {
nomeController.dispose();
codigoController.dispose();
serieController.dispose();
observacoesController.dispose();
super.dispose();
}

void salvarPatrimonio() {
if (!_formKey.currentState!.validate()) {
return;
}

if (categoriaSelecionada == null) {
  Get.snackbar(
    'Atenção',
    'Selecione uma categoria.',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.orange,
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
  );
  return;
}

if (estadoSelecionado == null) {
  Get.snackbar(
    'Atenção',
    'Selecione o estado de conservação.',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.orange,
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
  );
  return;
}

// Dados preenchidos no formulário.
final patrimonio = {
  'nome': nomeController.text.trim(),
  'codigo_tombamento': codigoController.text.trim(),
  'categoria': categoriaSelecionada,
  'numero_serie': serieController.text.trim(),
  'estado_conservacao': estadoSelecionado,
  'observacoes': observacoesController.text.trim(),
};

debugPrint('Patrimônio cadastrado: $patrimonio');

Get.snackbar(
  'Sucesso',
  'Patrimônio cadastrado com sucesso!',
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.green,
  colorText: Colors.white,
  margin: const EdgeInsets.all(16),
  duration: const Duration(seconds: 2),
);

Future.delayed(const Duration(milliseconds: 500), () {
  if (mounted) {
    Get.back();
  }
});

}
