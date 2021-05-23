import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/editor/open_project.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/ui/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Column(
                children: [
                  MFDActionCard(
                    title: Row(
                      children: [
                        const Text('Welcome to MFD Edit'),
                        const Spacer(),
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
                    disallowCloseButton: true,
                  ),
                  const MFDActionCard(
                    title: Text('Shortcuts'),
                    children: [Text('TODO: add shortcuts')],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
