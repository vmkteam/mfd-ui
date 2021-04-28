import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/editor/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
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
                    child: Text(
                      'Settings',
                      style: Theme.of(context).textTheme.button?.copyWith(color: Colors.white),
                    ),
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
                const SizedBox(width: 15),
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
                              filepath = await showDialog<String?>(context: context, builder: (context) => _OpenProjectDialog(path: filepath));
                              if (filepath != null) {
                                BlocProvider.of<ProjectBloc>(context).add(ProjectLoadStarted(filepath));
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
                                  onPressed: () {
                                    //BlocProvider.of<WorkAreaBloc>(context).add(EntityAdded(namespace.name, 'NewEntity'));
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

class _OpenProjectDialog extends StatefulWidget {
  const _OpenProjectDialog({Key? key, this.path}) : super(key: key);

  final String? path;

  @override
  __OpenProjectDialogState createState() => __OpenProjectDialogState();
}

class __OpenProjectDialogState extends State<_OpenProjectDialog> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.path);
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
          controller: textEditingController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Path',
            helperText: 'Absolute path to .mfd file',
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
                  onPressed: () => Navigator.of(context).pop(textEditingController.text),
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
