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