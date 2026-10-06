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

        body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  11,
                  10,
                  11,
                  11,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Item a devolver:',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.1,
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      widget.item,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.2,
                        color: darkTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      widget.patrimonio,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 1.2,
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      height: 1,
                      color: const Color(0xFFE9EBEF),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Responsável Atual:',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.1,
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      widget.responsavel,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.2,
                        color: darkTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Estado de Conservação na Entrega',
                style: TextStyle(
                  fontSize: 11,
                  color: darkTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                width: double.infinity,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _estadoConservacao,
                    isExpanded: true,
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: secondaryTextColor,
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    dropdownColor: Colors.white,

                    style: const TextStyle(
                      fontSize: 11,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: 'Excelente / Bom',
                        child: Text('Excelente / Bom'),
                      ),
                      DropdownMenuItem(
                        value: 'Bom',
                        child: Text('Bom'),
                      ),
                      DropdownMenuItem(
                        value: 'Regular',
                        child: Text('Regular'),
                      ),
                      DropdownMenuItem(
                        value: 'Ruim',
                        child: Text('Ruim'),
                      ),
                      DropdownMenuItem(
                        value: 'Danificado',
                        child: Text('Danificado'),
                      ),
                    ],

                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _estadoConservacao = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 13),

              const Text(
                'Observações de Devolução',
                style: TextStyle(
                  fontSize: 11,
                  color: darkTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                width: double.infinity,
                height: 59,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _observacoesController,
                  maxLines: 3,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,

                  style: const TextStyle(
                    fontSize: 11,
                    color: darkTextColor,
                    height: 1.25,
                  ),

                  decoration: const InputDecoration(
                    hintText:
                        'Registre se o item possui avarias ou acessórios\n'
                        'pendentes.',

                    hintStyle: TextStyle(
                      fontSize: 11,
                      color: secondaryTextColor,
                      height: 1.25,
                    ),

                    border: InputBorder.none,

                    contentPadding: EdgeInsets.fromLTRB(
                      8,
                      7,
                      8,
                      6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 34),



