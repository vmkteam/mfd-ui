import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/editor/namespace_autocomplete.dart';
import 'package:mfdui/editor/table_autocomplete.dart';
import 'package:mfdui/editor/xmlvtpage/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart' as api;
import 'package:mfdui/ui/ui.dart';

class XMLVTMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is! ProjectLoadSuccess) {
            return Container();
          }
          final namespaces = state.project.namespaces;
          return BlocBuilder<EditorBloc, EditorState>(
            builder: (context, editorState) {
              String? selectedEntityName;
              if (editorState is EditorEntityLoadSuccess) {
                selectedEntityName = editorState.vtentity.name;
              }
              if (editorState is EditorEntityLoadInProgress) {
                selectedEntityName = editorState.entityName;
              }

              return Scrollbar(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final int itemIndex = index ~/ 2;
                        if (namespaces.length <= itemIndex) {
                          return null;
                        }
                        if (index.isOdd) {
                          return const Divider();
                        }
                        final namespace = namespaces[itemIndex];
                        final Iterable<Widget> tiles = namespace.entities.map(
                          (e) => ListTile(
                            selected: e == selectedEntityName,
                            selectedTileColor: Colors.blueGrey.shade50,
                            dense: true,
                            title: Text(e),
                            onTap: () => BlocProvider.of<EditorBloc>(context).add(EditorEntitySelected(namespace.name, e)),
                          ),
                        );
                        return Column(
                          children: [
                            ListTile(
                              title: Text(namespace.name, style: Theme.of(context).textTheme.headline6),
                            ),
                            ...ListTile.divideTiles(
                              context: context,
                              tiles: tiles,
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OpenProjectDialogResult {
  _OpenProjectDialogResult(this.filepath, this.pgConnection);

  final String filepath;
  final String pgConnection;
}

class _OpenProjectDialog extends StatefulWidget {
  const _OpenProjectDialog({Key? key, this.path, this.conn}) : super(key: key);

  final String? path;
  final String? conn;

  @override
  __OpenProjectDialogState createState() => __OpenProjectDialogState();
}

class __OpenProjectDialogState extends State<_OpenProjectDialog> {
  late TextEditingController _pathTextController;
  late TextEditingController _connTextController;

  @override
  void initState() {
    _pathTextController = TextEditingController(text: widget.path);
    _connTextController = TextEditingController(text: widget.conn ?? DefaultPgConnection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(8.0),
      title: const Text('Open project'),
      children: [
        const SizedBox(height: 30),
        TextField(
          controller: _pathTextController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Path',
            helperText: 'Absolute path to .mfd file',
          ),
        ),
        const SizedBox(height: 30),
        TextField(
          controller: _connTextController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Connection',
            helperText: 'Connection string to PostgreSQL',
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: SizedBox(
                height: 36,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_OpenProjectDialogResult(
                    _pathTextController.text,
                    _connTextController.text,
                  )),
                  child: const Text('Open'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NewEntityDialog extends StatefulWidget {
  const _NewEntityDialog({Key? key, this.namespaceName = '', required this.projectBloc, required this.apiClient}) : super(key: key);

  final String namespaceName;
  final ProjectBloc projectBloc;
  final api.ApiClient apiClient;

  @override
  __NewEntityDialogState createState() => __NewEntityDialogState();
}

class __NewEntityDialogState extends State<_NewEntityDialog> {
  late String resultNamespace;
  String tableName = '';

  @override
  void initState() {
    resultNamespace = widget.namespaceName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.projectBloc,
      child: Unfocuser(
        child: SimpleDialog(
          contentPadding: const EdgeInsets.all(8.0),
          title: const Text('New entity'),
          children: [
            const SizedBox(height: 30),
            ListTile(
              title: NamespaceAutocomplete(
                initialValue: resultNamespace,
                onSubmitted: (value) => resultNamespace = value,
              ),
            ),
            ListTile(
              title: TableAutocomplete(
                tableName: tableName,
                projectBloc: widget.projectBloc,
                apiClient: widget.apiClient,
                onSubmitted: (value) => tableName = value,
              ),
            ),
            const SizedBox(height: 90),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(_AddEntityDialogResult(resultNamespace, tableName)),
                      child: const Text('Add entity'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddEntityDialogResult {
  _AddEntityDialogResult(this.namespace, this.tableName);

  final String namespace;
  final String tableName;
}
