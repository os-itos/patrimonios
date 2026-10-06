import 'package:flutter/material.dart';

class DevolverPatrimonioView extends StatefulWidget {
  const DevolverPatrimonioView({
    super.key,
    this.item = 'Projetor Epson PowerLite',
    this.patrimonio = 'PAT-2023-0089',
    this.responsavel = 'Prof. Mara Silva',
  });

  final String item;
  final String patrimonio;
  final String responsavel;

  @override
  State<DevolverPatrimonioView> createState() =>
      _DevolverPatrimonioViewState();
}

class _DevolverPatrimonioViewState extends State<DevolverPatrimonioView> {
  final TextEditingController _observacoesController =
      TextEditingController();

  String _estadoConservacao = 'Excelente / Bom';

  @override
  void dispose() {
    _observacoesController.dispose();
    super.dispose();
  }

  void _confirmarDevolucao() {
    FocusScope.of(context).unfocus();

    // Aqui você pode chamar o controller/API responsável pela devolução.
    //
    // Exemplo:
    // final controller = Get.find<PatrimonioController>();
    // controller.devolverPatrimonio(...);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Devolução registrada com sucesso.'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF5F6FA);
    const greenColor = Color(0xFF16A34A);
    const darkTextColor = Color(0xFF263244);
    const secondaryTextColor = Color(0xFF687385);
    const borderColor = Color(0xFFE3E6EB);

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 52,
        titleSpacing: 0,

        title: Row(
          children: [
            const SizedBox(width: 14),

            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(20),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back,
                  size: 22,
                  color: darkTextColor,
                ),
              ),
            ),

            const SizedBox(width: 0),

            const Text(
              'Registrar Devolução',
              style: TextStyle(
                color: darkTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

