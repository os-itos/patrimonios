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
final TextEditingController obser