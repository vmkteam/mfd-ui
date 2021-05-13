import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/menu.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/editor/editor_bloc.dart';
import 'package:mfdui/editor/editor_widget.dart';
import 'package:mfdui/editor/home_page.dart';
import 'package:mfdui/editor/open_project.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ProjectBloc(RepositoryProvider.of<ApiClient>(context))..add(ProjectLoadCurrent());
          },
        ),
        BlocProvider(
          create: (context) => EditorBloc(
            RepositoryProvider.of<ApiClient>(context),
            BlocProvider.of<ProjectBloc>(context),
          ),
        ),
      ],
      child: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is! ProjectLoadSuccess) {
            return ClosedProjectHomePage();
          }
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: buildAppBar(context),
              body: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  Widget? loader;
                  if (state is ProjectLoadInProgress) {
                    loader = const LinearProgressIndicator();
                  }
                  Widget? notification;
                  if (state is ProjectLoadFailed) {
                    notification = SizedBox(
                      width: double.infinity,
                      child: Material(
                        elevation: 3,
                        color: Theme.of(context).errorColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              state.err,
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  Widget view;
                  if (state is ProjectInitial) {
                    view = ClosedProjectHomePage();
                  } else {
                    view = TabBarView(
                      children: [
                        HomePage(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Menu(),
                            Expanded(child: EditorWidget()),
                          ],
                        ),
                        Container(),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      if (loader != null) loader,
                      if (notification != null) notification,
                      Expanded(
                        child: view,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoadSuccess) {
            Widget text = Text(state.project.name);
            if (state.filename != null) {
              text = Tooltip(message: state.filename!, child: text);
            }
            return Row(
              children: [
                text,
                const SizedBox(width: 16),
                SaveButton(),
              ],
            );
          }
          return const Text('MFD UI');
        },
      ),
      bottom: const TabBar(
        tabs: [
          Tab(text: 'HOME'),
          Tab(text: 'XML'),
          Tab(text: 'XML-VT'),
        ],
      ),
      centerTitle: false,
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
    );
  }
}

class SaveButton extends StatefulWidget {
  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectSaveInProgress) {
            return const ElevatedButton(
              onPressed: null,
              child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator()),
            );
          }
          if (state is ProjectLoadSuccess) {
            return ElevatedButton.icon(
              label: const Text('Save'),
              icon: const Icon(Icons.save),
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () => BlocProvider.of<ProjectBloc>(context).add(ProjectSaveStarted()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ClosedProjectHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MFD UI'),
        centerTitle: false,
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 38,
                                child: OutlinedButton.icon(
                                  label: const Text('Create New Project'),
                                  icon: const Icon(Icons.add),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(
                                height: 38,
                                child: Builder(builder: (context) {
                                  final projectBloc = BlocProvider.of<ProjectBloc>(context);
                                  final onPressed = () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    String? filepath = prefs.getString('filepath');
                                    String? pgConnection = prefs.getString('pg-conn');
                                    await showDialog(
                                        context: context,
                                        builder: (context) => OpenProjectDialog(
                                              path: filepath,
                                              conn: pgConnection,
                                              projectBloc: projectBloc,
                                            ));
                                  };
                                  const btnChild = Text('Open Project');

                                  if (BlocProvider.of<ProjectBloc>(context).state is ProjectLoadSuccess) {
                                    return OutlinedButton.icon(
                                      onPressed: onPressed,
                                      label: btnChild,
                                      icon: const Icon(Icons.folder_open),
                                    );
                                  }
                                  return ElevatedButton.icon(
                                    onPressed: onPressed,
                                    label: btnChild,
                                    icon: const Icon(Icons.folder_open),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 38,
                          child: IconButton(
                            icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
                            splashRadius: 20,
                            tooltip: 'Settings',
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
