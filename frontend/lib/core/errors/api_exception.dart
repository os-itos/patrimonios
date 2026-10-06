class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  const ApiException({
    this.statusCode,
    required this.message,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException($statusCode): $message';
  }
}

class NetworkException extends ApiException {
  const NetworkException({
    String message = 'Nao foi possivel conectar a API.',
  }) : super(message: message);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    String message = 'Sessao expirada ou credenciais invalidas.',
  }) : super(
          statusCode: 401,
          message: message,
        );
}

class ForbiddenException extends ApiException {
  const ForbiddenException({
    String message = 'Voce nao possui permissao para esta acao.',
  }) : super(
          statusCode: 403,
          message: message,
        );
}

class NotFoundException extends ApiException {
  const NotFoundException({
    String message = 'Recurso nao encontrado.',
  }) : super(
          statusCode: 404,
          message: message,
        );
}
