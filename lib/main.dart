import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mfdui/blocs/settings/settings_bloc.dart';
import 'package:mfdui/components/main_page.dart';
import 'package:mfdui/editor/xmlpage/xml_page.dart';
import 'package:mfdui/editor/xmlvtpage/xmlvt_page.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart';
import 'package:mfdui/services/api/jsonrpc_client.dart';
import 'package:mfdui/services/public_repo.dart';

void main() {
  runApp(MyApp(RPCClient('http://localhost:8080/', http.Client())));
}

class MyApp extends StatelessWidget {
  const MyApp(this.rpcClient);

  final RPCClient rpcClient;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient(rpcClient);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: rpcClient),
        RepositoryProvider(create: (context) => apiClient),
        RepositoryProvider.value(value: PublicRepo(apiClient)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return ProjectBloc(RepositoryProvider.of<ApiClient>(context))..add(ProjectLoadCurrent());
            },
            lazy: false,
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(rpcClient, defaultApiUrl)..add(SettingsStarted()),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          title: 'MFDUI',
          theme: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  //borderSide: BorderSide(style: BorderStyle.none, width: 0),
                  ),
            ),
            cardTheme: CardTheme(
              elevation: 0,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(width: 1, color: Colors.blueGrey.shade100),
              ),
            ),
            errorColor: Colors.deepOrange.shade200,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          routes: {
            '/': (context) => MainPage(),
            '/xml': (context) => XMLPage(),
            '/xmlvt': (context) => XMLVTPage(),
          },
        ),
      ),
    );
  }
}
