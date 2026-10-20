// erro padrao das chamadas da api, com o status http e a mensagem
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  const ApiException({
    this.statusCode,
    required this.message,
    this.data,
  });

  // as telas mostram o erro direto, entao aqui volta so a mensagem
  @override
  String toString() => message;
}

// quando nem chegou na api (sem internet, api desligada ou timeout)
class NetworkException extends ApiException {
  const NetworkException({
    String message = 'Nao foi possivel conectar a API.',
  }) : super(message: message);
}

// 401: token vencido ou login errado
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    String message = 'Sessao expirada ou credenciais invalidas.',
  }) : super(
          statusCode: 401,
          message: message,
        );
}

// 403: sem permissao (ex: professor tentando editar)
class ForbiddenException extends ApiException {
  const ForbiddenException({
    String message = 'Voce nao possui permissao para esta acao.',
  }) : super(
          statusCode: 403,
          message: message,
        );
}

// 404: nao achou o recurso
class NotFoundException extends ApiException {
  const NotFoundException({
    String message = 'Recurso nao encontrado.',
  }) : super(
          statusCode: 404,
          message: message,
        );
}
