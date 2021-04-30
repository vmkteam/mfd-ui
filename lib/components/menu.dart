import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/editor/editor_bloc.dart';
import 'package:mfdui/editor/table_autocomplete.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart' as api;
import 'package:mfdui/ui/autocomplete/autocomplete.dart';
import 'package:mfdui/ui/unfocuser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  if (state is ProjectLoadSuccess) {
                    final text = Text(state.project.name);
                    if (state.filename == null) {
                      return text;
                    }
                    return Tooltip(message: state.filename!, child: text);
                  }
                  return const Text('MFD UI');
                },
              ),
              actions: [
                Builder(
                  builder: (context) => TextButton(
                    child: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => Settings(),
                      );
                      final bloc = BlocProvider.of<ProjectBloc>(context);
                      final state = bloc.state;
                      if (state is ProjectLoadSuccess) {
                        bloc.add(ProjectLoadCurrent());
                      }
                    },
                  ),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 38,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('Create project'),
                          ),
                        ),
                        SizedBox(
                          height: 38,
                          child: Builder(builder: (context) {
                            final onPressed = () async {
                              final prefs = await SharedPreferences.getInstance();
                              String? filepath = prefs.getString('filepath');
                              String? pgConnection = prefs.getString('pg-conn');
                              final result = await showDialog<_OpenProjectDialogResult?>(
                                  context: context, builder: (context) => _OpenProjectDialog(path: filepath, conn: pgConnection));
                              if (result != null) {
                                BlocProvider.of<ProjectBloc>(context).add(ProjectLoadStarted(
                                  result.filepath,
                                  result.pgConnection,
                                ));
                              }
                            };
                            const btnChild = Text('Open');

                            if (BlocProvider.of<ProjectBloc>(context).state is ProjectLoadSuccess) {
                              return OutlinedButton(onPressed: onPressed, child: btnChild);
                            }
                            return ElevatedButton(onPressed: onPressed, child: btnChild);
                          }),
                        ),
                        SizedBox(
                          height: 38,
                          child: BlocBuilder<ProjectBloc, ProjectState>(
                            builder: (context, state) {
                              if (state is ProjectSaveInProgress) {
                                return const ElevatedButton(
                                  onPressed: null,
                                  child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator()),
                                );
                              }
                              if (state is ProjectLoadSuccess) {
                                return ElevatedButton(
                                  onPressed: () => BlocProvider.of<ProjectBloc>(context).add(ProjectSaveStarted()),
                                  child: const Text('Save'),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                if (state is ProjectLoadSuccess) {
                  final namespaces = state.project.namespaces;
                  return BlocBuilder<EditorBloc, EditorState>(
                    builder: (context, editorState) {
                      String? selectedEntityName;
                      if (editorState is EditorEntityLoadSuccess) {
                        selectedEntityName = editorState.entity.name;
                      }
                      if (editorState is EditorEntityLoadInProgress) {
                        selectedEntityName = editorState.entityName;
                      }

                      return SliverList(
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
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                  tooltip: 'Add entity',
                                  onPressed: () async {
                                    final projectBloc = BlocProvider.of<ProjectBloc>(context);
                                    final apiClient = RepositoryProvider.of<api.ApiClient>(context);
                                    final result = await showDialog<_AddEntityDialogResult?>(
                                      context: context,
                                      builder: (context) => _NewEntityDialog(
                                        namespaceName: namespace.name,
                                        projectBloc: projectBloc,
                                        apiClient: apiClient,
                                      ),
                                    );
                                    if (result == null) {
                                      return;
                                    }

                                    BlocProvider.of<EditorBloc>(context).add(EditorEntityAdded(
                                      result.namespace,
                                      result.tableName,
                                    ));
                                    projectBloc.add(ProjectLoadCurrent());
                                  },
                                  splashRadius: 20,
                                ),
                              ),
                              ...ListTile.divideTiles(
                                context: context,
                                tiles: tiles,
                              ),
                            ],
                          );
                        }),
                      );
                    },
                  );
                }
                return const SliverFillRemaining();
              },
            ),
          ],
        ),
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
    return Unfocuser(
      child: SimpleDialog(
        contentPadding: const EdgeInsets.all(8.0),
        title: const Text('New entity'),
        children: [
          const SizedBox(height: 30),
          ListTile(
            title: MFDAutocomplete(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Namespace',
              ),
              initialValue: resultNamespace,
              optionsLoader: (query) async {
                final projectState = widget.projectBloc.state;
                if (projectState is! ProjectLoadSuccess) {
                  return List.empty();
                }

                final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
                return projectState.project.namespaces.map((e) => e.name).where((element) => element.contains(precursor));
              },
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
    );
  }
}

class _AddEntityDialogResult {
  _AddEntityDialogResult(this.namespace, this.tableName);

  final String namespace;
  final String tableName;
}
