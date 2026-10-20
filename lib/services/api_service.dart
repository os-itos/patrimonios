import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app/config/app_config.dart';
import '../core/errors/api_exception.dart';
import 'session_manager.dart';
import 'storage_service.dart';

// cliente http central. toda chamada passa por aqui, assim o token
// e o tratamento de erro ficam num lugar so
class ApiService {
  final StorageService storage;
  final SessionManager sessionManager;

  final http.Client _client;

  ApiService({
    required this.storage,
    required this.sessionManager,
    http.Client? client,
  }) : _client = client ?? http.Client();

  // atalhos pra cada metodo http
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) {
    return _request(
      method: 'GET',
      endpoint: endpoint,
      queryParameters: queryParameters,
    );
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) {
    return _request(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) {
    return _request(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) {
    return _request(
      method: 'DELETE',
      endpoint: endpoint,
      requiresAuth: requiresAuth,
    );
  }

  // monta a url, coloca o token e faz a requisicao
  Future<dynamic> _request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse(
      '${AppConfig.baseUrl}$endpoint',
    ).replace(
      queryParameters: queryParameters,
    );

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // rota protegida manda o header authorization: bearer <token>
    if (requiresAuth) {
      final token = await storage.getToken();

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    try {
      late http.Response response;

      switch (method) {
        case 'GET':
          response = await _client
              .get(uri, headers: headers)
              .timeout(AppConfig.requestTimeout);

          break;

        case 'POST':
          response = await _client
              .post(
                uri,
                headers: headers,
                body: body == null ? null : jsonEncode(body),
              )
              .timeout(AppConfig.requestTimeout);

          break;

        case 'PUT':
          response = await _client
              .put(
                uri,
                headers: headers,
                body: body == null ? null : jsonEncode(body),
              )
              .timeout(AppConfig.requestTimeout);

          break;

        case 'DELETE':
          response = await _client
              .delete(uri, headers: headers)
              .timeout(AppConfig.requestTimeout);

          break;

        default:
          throw const ApiException(
            message: 'Metodo HTTP nao suportado.',
          );
      }

      return _handleResponse(response);
    } on TimeoutException {
      throw const NetworkException(
        message: 'A API demorou muito para responder.',
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const NetworkException();
    }
  }

  // le a resposta: 2xx devolve os dados, o resto vira exception
  Future<dynamic> _handleResponse(
    http.Response response,
  ) async {
    dynamic data;

    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = response.body;
      }
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    final message = _extractMessage(data);

    switch (response.statusCode) {
      // token invalido ou vencido: limpa a sessao e volta pro login
      case 401:
        await sessionManager.expireSession();

        throw UnauthorizedException(
          message: message,
        );

      case 403:
        throw ForbiddenException(
          message: message,
        );

      case 404:
        throw NotFoundException(
          message: message,
        );

      default:
        throw ApiException(
          statusCode: response.statusCode,
          message: message,
          data: data,
        );
    }
  }

  // a api manda o erro em "error", mas aceita outros nomes tambem
  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail != null) {
        return detail.toString();
      }

      final message = data['message'];
      if (message != null) {
        return message.toString();
      }

      final error = data['error'];
      if (error != null) {
        return error.toString();
      }
    }

    return 'O servidor retornou um erro.';
  }

  void dispose() {
    _client.close();
  }
}
