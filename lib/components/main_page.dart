import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/project_bloc.dart';
import 'package:mfdui/blocs/work_area_bloc.dart';
import 'package:mfdui/components/menu.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/components/work_area.dart';
import 'package:mfdui/services/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ProjectBloc(RepositoryProvider.of<ApiClient>(context));
        SharedPreferences.getInstance().then((prefs) {
          String? filepath = prefs.getString('filepath');
          if (filepath != null) {
            bloc.add(ProjectLoadStarted(filepath));
          }
        });
        return bloc;
      },
      child: BlocProvider(
        create: (context) => WorkAreaBloc(BlocProvider.of<ProjectBloc>(context)),
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                String projectName = '';
                if (state is ProjectLoadSuccess) {
                  projectName = state.project.name ?? '';
                }
                return Text('MFDUI $projectName');
              },
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.settings),
                  tooltip: 'Settings',
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => Settings(),
                    );
                    final bloc = BlocProvider.of<ProjectBloc>(context);
                    final state = bloc.state;
                    if (state is ProjectLoadSuccess) {
                      bloc.add(ProjectLoadStarted(state.filename));
                    }
                  },
                ),
              ),
            ],
          ),
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
                    color: Colors.red.shade100,
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

              return Column(children: [
                if (loader != null) loader,
                if (notification != null) notification,
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Menu(),
                      Expanded(child: WorkArea()),
                    ],
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}
