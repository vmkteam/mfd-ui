import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mfdui/services/api/api_client.dart';
import 'package:mfdui/services/api/errors.dart';
import 'package:mfdui/services/api/rpc.dart';

const String _AuthHeader = 'Auth-Token';

class RPCClient implements JSONRPCClient {
  RPCClient(this.url, this._client);

  http.Client _client;
  String url;
  int _reqId = 0;
  String _token = '';

  set token(String token) => _token = token;

  Function()? _on401;
  set on401(Function() x) => _on401 = x;

  @override
  Future<dynamic> call(String method, dynamic params) async {
    final RPCRequest req = RPCRequest('2.0', _generateId(), method, params);

    final http.Request request = http.Request('POST', Uri.parse(url));
    request.body = jsonEncode(req);
    request.headers['Content-Type'] = ContentType.json.toString();
    if (_token != '') {
      request.headers[_AuthHeader] = _token;
    }

    final http.StreamedResponse stream = await _client.send(request).timeout(const Duration(seconds: 10));
    final http.Response response = await http.Response.fromStream(stream);

    if (response.statusCode != 200) {
      if (response.statusCode == 401 && _on401 != null) {
        // todo onExpire;
        _token = '';
        _on401!();
      }
      throw ApiServerError(method, params, response.statusCode);
    }
    final String body = utf8.decode(response.bodyBytes);
    return Future<dynamic>(() {
      final Map<String, dynamic> m = jsonDecode(body) as Map<String, dynamic>;
      final RPCResponse resp = RPCResponse.fromJson(m);
      if (resp.error != null) {
        final RPCError err = resp.error!;

        if (err.code == 401 && _on401 != null) {
          // todo onExpire;
          _token = '';
          _on401!();
        }
        throw ApiRpcError(method, params, err.code, err.message);
      }
      return resp.result;
    });
  }

  dynamic _generateId() => _reqId = _reqId + 1;
}

void printPrettyJson(Map json) {
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');
  final String pp = encoder.convert(json);
  print(pp);
}
