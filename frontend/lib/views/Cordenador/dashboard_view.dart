import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 
// ---------------- CONFIG ----------------
const String _baseUrl = 'http://10.0.2.2:3000/api'; // troque pela sua API
const bool _usarMock = false; // true = mostra dados de exemplo sem API
// ----------------------------------------
 
class _C {
  static const text = Color(0xFF1F2937);
  static const muted = Color(0xFF6B7280);
  static const primary = Color(0xFF2563EB);
}
// ---------------- MODELOS ----------------
class _Atividade {
  final String titulo, descricao, tipo;
  final DateTime data;
  _Atividade(this.titulo, this.descricao, this.tipo, this.data);
 
  factory _Atividade.fromJson(Map<String, dynamic> j) => _Atividade(
        j['titulo'] ?? '',
        j['descricao'] ?? '',
        j['tipo'] ?? 'atribuido',
        DateTime.tryParse(j['data'] ?? '') ?? DateTime.now(),
      );
 
  String get dataFormatada {
    final n = DateTime.now();
    final diff = DateTime(n.year, n.month, n.day)
        .difference(DateTime(data.year, data.month, data.day))
        .inDays;
    final h =
        '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    if (diff == 0) return 'Hoje, $h';
    if (diff == 1) return 'Ontem, $h';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}, $h';
  }
}
 
class _Dados {
  final String nome;
  final int total, disponiveis, atribuidos, manutencao;
  final List<_Atividade> atividades;
  _Dados(this.nome, this.total, this.disponiveis, this.atribuidos,
      this.manutencao, this.atividades);
 
  factory _Dados.fromJson(Map<String, dynamic> j) => _Dados(
        j['coordenador'] ?? 'Coordenador',
        j['total'] ?? 0,
        j['disponiveis'] ?? 0,
        j['atribuidos'] ?? 0,
        j['manutencao'] ?? 0,
        (j['atividades'] as List? ?? [])
            .map((e) => _Atividade.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
// ---------------- API ----------------
// GET {_baseUrl}/dashboard
Future<_Dados> _buscarDados() async {
  if (_usarMock) {
    await Future.delayed(const Duration(milliseconds: 600));
    final agora = DateTime.now();
    return _Dados('Coordenador', 148, 84, 52, 12, [
      _Atividade('Notebook Dell atribuído', 'Destinatário: Prof. Maria Silva',
          'atribuido', DateTime(agora.year, agora.month, agora.day, 10, 30)),
      _Atividade(
          'Projetor Epson devolvido',
          'Devolvido por: Prof. João Souza',
          'devolvido',
          DateTime(agora.year, agora.month, agora.day, 16, 15)
              .subtract(const Duration(days: 1))),
    ]);
  }
  final r = await http.get(Uri.parse('$_baseUrl/dashboard'), headers: {
    'Content-Type': 'application/json',
    // 'Authorization': 'Bearer SEU_TOKEN',
  }).timeout(const Duration(seconds: 15));
  if (r.statusCode == 200) {
    return _Dados.fromJson(jsonDecode(utf8.decode(r.bodyBytes)));
  }
  throw Exception('Erro ${r.statusCode} ao carregar dados');
}