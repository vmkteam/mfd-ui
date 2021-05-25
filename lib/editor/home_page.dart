import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/editor/open_project.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/ui/ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            _MenuCard(),
            const MFDActionCard(
              title: Text('Shortcuts'),
              children: [Text('TODO: add shortcuts')],
              disallowCloseButton: true,
            ),
            _LinksCard(),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MFDActionCard(
      title: const Text('Main menu'),
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
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          width: double.infinity,
          child: OutlinedButton.icon(
            label: const Text('Settings'),
            icon: const Icon(Icons.settings),
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
      disallowCloseButton: true,
    );
  }
}

class _LinksCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MFDActionCard(
      title: const Text('Links'),
      disallowCloseButton: true,
      children: [
        ListTile(
          title: const Text('mfd-generator'),
          trailing: const Icon(Icons.open_in_new, size: 15),
          onTap: () => launch('https://github.com/vmkteam/mfd-generator'),
        ),
        ListTile(
          title: const Text('Source code'),
          trailing: const Icon(Icons.open_in_new, size: 15),
          onTap: () => launch('https://github.com/vmkteam/mfd-ui'),
        ),
      ],
    );
  }
}
