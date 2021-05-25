import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/api_connection_bloc.dart';
import 'package:mfdui/blocs/settings/settings_bloc.dart';

class ConnectionIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApiConnectionBloc, ApiConnectionState>(
      builder: (context, state) {
        if (state is ApiConnectionFailed) {
          return IconButton(
            tooltip: 'Disconnected from API\n${state.error.toString()}',
            splashRadius: 20,
            icon: const Icon(Icons.cloud_off),
            onPressed: () {
              final url = BlocProvider.of<SettingsBloc>(context).state.url;
              BlocProvider.of<ApiConnectionBloc>(context).add(CheckConnection(url));
            },
            color: Theme.of(context).errorColor,
          );
        }
        if (state is ApiConnectionInProgress) {
          return IconButton(
            tooltip: 'Connecting...',
            splashRadius: 20,
            icon: const CircularProgressIndicator(),
            onPressed: null,
            color: Theme.of(context).primaryColor,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
