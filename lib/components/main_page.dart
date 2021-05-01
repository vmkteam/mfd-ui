import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/menu.dart';
import 'package:mfdui/editor/editor_bloc.dart';
import 'package:mfdui/editor/editor_widget.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart';

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
      child: Scaffold(
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

            return Column(children: [
              if (loader != null) loader,
              if (notification != null) notification,
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Menu(),
                    Expanded(child: EditorWidget()),
                  ],
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
