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

InputDecoration campoDecoracao({
required String hintText,
Widget? suffixIcon,
}) {
return InputDecoration(
hintText: hintText,
hintStyle: const TextStyle(
color: Color(0xFF7A8190),
fontSize: 12,
),
filled: true,
fillColor: const Color(0xFFF8F8F8),
contentPadding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 10,
),
suffixIcon: suffixIcon,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(6),
borderSide: const BorderSide(
color: Color(0xFFD9DCE1),
width: 1,
),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(6),
borderSide: const BorderSide(
color: Color(0xFFD9DCE1),
width: 1,
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(6),
borderSide: const BorderSide(
color: Color(0xFF1E5BD7),
width: 1.5,
),
),
);
}

Widget tituloCampo(String texto) {
return Padding(
padding: const EdgeInsets.only(bottom: 6),
child: Text(
texto,
style: const TextStyle(
fontSize: 11,
fontWeight: FontWeight.w600,
color: Color(0xFF263142),
),
),
);
}

Widget campoTexto({
required String titulo,
required String hint,
required TextEditingController controller,
int maxLines = 1,
}) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
tituloCampo(titulo),
TextFormField(
controller: controller,
maxLines: maxLines,
style: const TextStyle(
fontSize: 12,
color: Color(0xFF263142),
),
decoration: campoDecoracao(
hintText: hint,
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return 'Preencha este campo';
}
return null;
},
),
],
);
}

Widget campoDropdown({
required String titulo,
required String hint,
required String? valor,
required List<String> itens,
required ValueChanged<String?> onChanged,
}) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
tituloCampo(titulo),
DropdownButtonFormField<String>(
value: valor,
isExpanded: true,
icon: const Icon(
Icons.keyboard_arrow_down,
size: 18,
color: Color(0xFF647080),
),
style: const TextStyle(
fontSize: 12,
color: Color(0xFF263142),
),
decoration: campoDecoracao(
hintText: hint,
),
hint: Text(
hint,
style: const TextStyle(
color: Color(0xFF7A8190),
fontSize: 12,
),
),
items: itens.map((item) {
return DropdownMenuItem<String>(
value: item,
child: Text(item),
);
}).toList(),
onChanged: onChanged,
),
],
);
}
