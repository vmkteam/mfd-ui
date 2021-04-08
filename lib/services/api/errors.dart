class ApiRpcError extends Error {
  ApiRpcError(this.method, this.params, this.code, this.message);

  final String method;
  final dynamic params;
  final int code;
  final String message;

  @override
  String toString() {
    return '$method code=$code: $message';
  }
}

class ApiServerError extends Error {
  ApiServerError(this.method, this.params, this.status);

  final String method;
  final dynamic params;
  final int status;

  @override
  String toString() {
    return '$method status=$status';
  }
}
