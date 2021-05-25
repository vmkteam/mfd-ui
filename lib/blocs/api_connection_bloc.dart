import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/services/api/jsonrpc_client.dart' as api;

part 'api_connection_event.dart';
part 'api_connection_state.dart';

class ApiConnectionBloc extends Bloc<ApiConnectionEvent, ApiConnectionState> {
  ApiConnectionBloc(this.rpcClient) : super(ApiConnectionInitial());

  final api.RPCClient rpcClient;

  @override
  Stream<ApiConnectionState> mapEventToState(
    ApiConnectionEvent event,
  ) async* {
    if (event is CheckConnection) {
      yield ApiConnectionInProgress(event.url);
      final oldUrl = rpcClient.url;
      try {
        rpcClient.url = event.url;
        final resp = await rpcClient.call('public.ping', null);
        if (resp is String && resp == 'Pong') {
          yield ApiConnectionSuccess(event.url);
        } else {
          rpcClient.url = oldUrl;
          yield ApiConnectionFailed(event.url, Exception('cant update url, because response is not "pong", but $resp'));
        }
      } on Exception catch (e) {
        rpcClient.url = oldUrl;
        yield ApiConnectionFailed(event.url, e);
      }
    }
  }
}
