import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/project_bloc.dart';
import 'package:mfdui/blocs/work_area_bloc.dart';
import 'package:mfdui/services/api/api_client.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                return BlocBuilder<WorkAreaBloc, WorkAreaState>(
                  builder: (context, workAreaState) {
                    String? selectedEntityName;
                    String? selectedNamespaceName;
                    if (workAreaState is WorkAreaSelectSuccess) {
                      selectedEntityName = workAreaState.entity.name;
                      selectedNamespaceName = workAreaState.namespace.name;
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
                        final namespace = namespaces[itemIndex]!;
                        final Iterable<Widget> tiles = namespace.entities!.map(
                          (e) => ListTile(
                            selected: namespace.name == selectedNamespaceName && e?.name == selectedEntityName,
                            selectedTileColor: Colors.blueGrey.shade50,
                            title: Text(e!.name!),
                            onTap: () => BlocProvider.of<WorkAreaBloc>(context).add(EntitySelected(e.name!, namespace.name!)),
                          ),
                        );
                        return Column(
                          children: [
                            ListTile(title: Text(namespace.name!, style: Theme.of(context).textTheme.headline6)),
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
    );
  }
}
