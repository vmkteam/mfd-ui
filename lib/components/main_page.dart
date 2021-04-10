import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/project_bloc.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/services/api/api_client.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectBloc(RepositoryProvider.of<ApiClient>(context)),
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
                tooltip: 'Настройки',
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => Settings(),
                  );
                  BlocProvider.of<ProjectBloc>(context).add(ProjectLoadStarted('vtsrv'));
                },
              ),
            ),
          ],
        ),
        body: Row(
          children: [
            Drawer(
              child: CustomScrollView(
                slivers: [
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
                                  child: Text('Create project'),
                                ),
                              ),
                              SizedBox(
                                height: 38,
                                child: Builder(
                                  builder: (context) => ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<ProjectBloc>(context).add(ProjectLoadStarted('vtsrv'));
                                    },
                                    child: Text('Open project'),
                                  ),
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
                        final namespaces = state.project.namespaces ?? List<Namespace?>.empty();
                        return SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final int itemIndex = index ~/ 2;
                            if (namespaces.length <= itemIndex) {
                              return null;
                            }
                            if (index.isOdd) {
                              return const Divider();
                            }
                            final Iterable<Widget> tiles = namespaces[itemIndex]!.entities!.map(
                                  (e) => ListTile(
                                    title: Text(e!.name!),
                                  ),
                                );
                            return Column(
                              children: [
                                ListTile(title: Text(namespaces[itemIndex]!.name!, style: Theme.of(context).textTheme.headline6)),
                                ...ListTile.divideTiles(
                                  context: context,
                                  tiles: tiles,
                                ),
                              ],
                            );
                          }),
                        );
                        return ListView.builder(
                          itemCount: namespaces.length * 2,
                          itemBuilder: (context, index) {
                            if (index.isOdd) {
                              return const Divider();
                            }
                            final Iterable<Widget> tiles = namespaces[index]!.entities!.map(
                                  (e) => ListTile(
                                    title: Text(e!.name!),
                                  ),
                                );
                            return Text('', style: Theme.of(context).textTheme.subtitle1);
                            return Column(
                              children: [
                                Text('', style: Theme.of(context).textTheme.subtitle1),
                                ...ListTile.divideTiles(
                                  tiles: tiles,
                                ),
                              ],
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
          ],
        ),
      ),
    );
  }
}
