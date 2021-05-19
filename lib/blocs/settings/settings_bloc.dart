import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/services/api/jsonrpc_client.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_event.dart';
part 'settings_state.dart';

const defaultApiUrl = 'http://localhost:8880/api';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.rpcClient, String x) : super(SettingsInitial(x));

  final api.RPCClient rpcClient;

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is SettingsStarted) {
      final prefs = await SharedPreferences.getInstance();
      final apiUrl = prefs.getString('apiurl') ?? defaultApiUrl;
      rpcClient.url = apiUrl;
      yield SettingsUpdateSuccess(apiUrl);
    }
    if (event is SettingsUpdated) {
      yield SettingsUpdateInProgress(event.url);
      final oldUrl = rpcClient.url;
      try {
        rpcClient.url = event.url;
        final resp = await rpcClient.call('public.ping', null);
        if (resp is String && resp == 'Pong') {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('apiurl', event.url);
          yield SettingsUpdateSuccess(event.url);
        } else {
          rpcClient.url = oldUrl;
          yield SettingsUpdateFailed(event.url, 'cant update url, because response is not "pong", but $resp');
        }
      } catch (e) {
        rpcClient.url = oldUrl;
        yield SettingsUpdateFailed(oldUrl, e.toString());
      }
    }
  }
}
