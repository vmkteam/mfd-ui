import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/connection.dart';
import 'package:mfdui/components/scaffold.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/editor/home_page.dart';
import 'package:mfdui/editor/open_project.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/ui/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        if (state is! ProjectLoadSuccess) {
          return ClosedProjectHomePage();
        }
        Widget body;
        if (state is ProjectInitial) {
          body = ClosedProjectHomePage();
        } else {
          body = HomePage();
        }
        return MFDScaffold(body: body);
      },
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Column(
                  children: [
                    MFDActionCard(
                      title: Row(
                        children: [
                          const Text('Welcome to UI'),
                          const Spacer(),
                          ConnectionIcon(),
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
                      children: [
                        SizedBox(
                          height: 38,
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            label: const Text('Create New Project'),
                            icon: const Icon(Icons.add),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 38,
                          width: double.infinity,
                          child: Builder(builder: (context) {
                            final projectBloc = BlocProvider.of<ProjectBloc>(context);
                            final onPressed = () async {
                              final prefs = await SharedPreferences.getInstance();
                              final filepath = prefs.getString('filepath');
                              final pgConnection = prefs.getString('pg-conn');
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
