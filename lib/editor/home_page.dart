import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/editor/open_project.dart';
import 'package:mfdui/project/project.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                    const btnChild = Text('Open project');

                    if (BlocProvider.of<ProjectBloc>(context).state is ProjectLoadSuccess) {
                      return OutlinedButton(onPressed: onPressed, child: btnChild);
                    }
                    return ElevatedButton(onPressed: onPressed, child: btnChild);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
