import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/services/api/jsonrpc_client.dart' as api;

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.rpcClient, String x) : super(SettingsInitial(x));

  final api.RPCClient rpcClient;

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsUpdated) {
      final oldUrl = rpcClient.url;
      try {
        rpcClient.url = event.url;
        final resp = await rpcClient.call('api.ping', null);
        if (resp is String && resp == 'pong') {
          yield SettingsUpdateSuccess(event.url);
        } else {
          rpcClient.url = oldUrl;
          yield SettingsUpdateFailed('cant update url, because response is not "pong", but $resp');
        }
      } catch (e) {
        rpcClient.url = oldUrl;
        yield SettingsUpdateFailed(e.toString());
      }
    }
  }
}
