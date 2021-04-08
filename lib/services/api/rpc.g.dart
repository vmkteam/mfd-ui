// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RPCRequest _$RPCRequestFromJson(Map<String, dynamic> json) {
  return RPCRequest(
    json['jsonrpc'] as String,
    json['id'],
    json['method'] as String,
    json['params'],
  );
}

Map<String, dynamic> _$RPCRequestToJson(RPCRequest instance) =>
    <String, dynamic>{
      'jsonrpc': instance.jsonrpc,
      'id': instance.id,
      'method': instance.method,
      'params': instance.params,
    };

RPCResponse _$RPCResponseFromJson(Map<String, dynamic> json) {
  return RPCResponse(
    id: json['id'] as int?,
    result: json['result'],
    error: json['error'] == null
        ? null
        : RPCError.fromJson(json['error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RPCResponseToJson(RPCResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'error': instance.error,
    };

RPCError _$RPCErrorFromJson(Map<String, dynamic> json) {
  return RPCError(
    code: json['code'] as int,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$RPCErrorToJson(RPCError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
