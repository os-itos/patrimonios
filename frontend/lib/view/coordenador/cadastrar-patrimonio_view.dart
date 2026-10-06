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

