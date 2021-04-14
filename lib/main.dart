import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mfdui/blocs/settings/settings_bloc.dart';
import 'package:mfdui/components/main_page.dart';
import 'package:mfdui/services/api/api_client.dart';
import 'package:mfdui/services/api/jsonrpc_client.dart';

void main() {
  runApp(MyApp(RPCClient('http://localhost:8080/', http.Client())));
}

class MyApp extends StatelessWidget {
  const MyApp(this.rpcClient);

  final RPCClient rpcClient;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: rpcClient),
        RepositoryProvider(create: (context) => ApiClient(rpcClient)),
      ],
      child: BlocProvider<SettingsBloc>(
        create: (context) => SettingsBloc(rpcClient, defaultApiUrl)..add(SettingsStarted()),
        lazy: false,
        child: MaterialApp(
          title: 'MFDUI',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          routes: {
            '/': (context) => MainPage(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? mode = 'Full';
  TextEditingController terminalPathController = TextEditingController.fromValue(TextEditingValue(text: 'integrations'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Namespace: catalogue'),
        ),
        body: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Entity: City'),
                        SizedBox(width: 20),
                        DropdownButton<String>(
                          value: mode,
                          items: [
                            DropdownMenuItem(
                              child: Text('Full'),
                              value: 'Full',
                            ),
                            DropdownMenuItem(
                              child: Text('ReadOnly'),
                              value: 'ReadOnly',
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              mode = value;
                            });
                          },
                        )
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefix: Text('TerminalPath: '),
                      ),
                      controller: terminalPathController,
                    ),
                    SizedBox(height: 15),
                    Text('Атрибуты сущности'),
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Атрибут')),
                        DataColumn(label: Text('AttrName')),
                        DataColumn(label: Text('SearchName')),
                        DataColumn(label: Text('Summary')),
                        DataColumn(label: Text('Search?')),
                        DataColumn(label: Text('min/max')),
                        DataColumn(label: Text('Required')),
                        DataColumn(label: Text('Validate rule')),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(Text('ID')),
                            DataCell(Text('ID')),
                            DataCell(Text('ID')),
                            DataCell(Checkbox(value: true, onChanged: (value) {})),
                            DataCell(Checkbox(value: true, onChanged: (value) {})),
                            DataCell(Row(
                              children: [Expanded(child: TextField()), Text('/'), Expanded(child: TextField())],
                            )),
                            DataCell(Checkbox(value: false, onChanged: (value) {})),
                            DataCell(TextField()),
                          ],
                        ),
                        DataRow(
                          cells: [
                            DataCell(Text('Title')),
                            DataCell(Text('Title')),
                            DataCell(Text('TitleILike')),
                            DataCell(Checkbox(value: true, onChanged: (value) {})),
                            DataCell(Checkbox(value: true, onChanged: (value) {})),
                            DataCell(Row(
                              children: [
                                Expanded(child: TextField()),
                                Text('/'),
                                Expanded(child: TextField(controller: TextEditingController(text: '255')))
                              ],
                            )),
                            DataCell(Checkbox(value: false, onChanged: (value) {})),
                            DataCell(TextField()),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Text('Настройки шаблона'),
                    DataTable(
                      columns: [
                        DataColumn(label: Text('Атрибут')),
                        DataColumn(label: Text('s')),
                        DataColumn(label: Text('s')),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('s')), DataCell(Text('f')), DataCell(Text('e'))])
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
