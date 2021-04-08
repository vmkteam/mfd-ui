import 'package:json_annotation/json_annotation.dart';

part 'rpc.g.dart';

@JsonSerializable()
class RPCRequest {
  RPCRequest(this.jsonrpc, this.id, this.method, this.params);
  factory RPCRequest.fromJson(Map<String, dynamic> json) => _$RPCRequestFromJson(json);

  final String jsonrpc;
  final dynamic id;
  final String method;
  final dynamic params;

  Map<String, dynamic> toJson() => _$RPCRequestToJson(this);
}

@JsonSerializable()
class RPCResponse {
  RPCResponse({this.id, this.result, this.error});
  factory RPCResponse.fromJson(Map<String, dynamic> json) => _$RPCResponseFromJson(json);

  final int? id;
  final dynamic result;
  final RPCError? error;

  Map<String, dynamic> toJson() => _$RPCResponseToJson(this);
}

@JsonSerializable()
class RPCError {
  RPCError({required this.code, required this.message});
  factory RPCError.fromJson(Map<String, dynamic> json) => _$RPCErrorFromJson(json);

  final int code;
  final String message;

  Map<String, dynamic> toJson() => _$RPCErrorToJson(this);
}
