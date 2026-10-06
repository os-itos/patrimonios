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

  