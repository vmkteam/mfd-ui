import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/project_bloc.dart';
import 'package:mfdui/blocs/work_area_bloc.dart';
import 'package:mfdui/components/menu.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/services/api/api_client.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectBloc(RepositoryProvider.of<ApiClient>(context)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Menu(),
              Expanded(child: WorkArea()),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkArea extends StatelessWidget {
  List<TableColumn<Attribute>> get columns {
    return [
      TableColumn(
        header: const Header('Name'),
        builder: (context, row) {
          return Text(row.name!);
        },
      ),
      TableColumn(
        header: const Header('DB column'),
        builder: (context, row) {
          return Text(row.dbName!);
        },
      ),
      TableColumn(
        header: const Header('DB type'),
        builder: (context, row) {
          return Text(row.dbType!);
        },
      ),
      TableColumn(
        header: const Header('go type'),
        builder: (context, row) {
          return Text(row.goType!);
        },
      ),
      TableColumn(
        header: const Header('Primary key'),
        builder: (context, row) {
          if (row.primaryKey!) {
            return Checkbox(value: row.primaryKey!, onChanged: null);
          }
          return const SizedBox();
        },
      ),
      TableColumn(
        header: const Header('Nullable'),
        builder: (context, row) {
          if (row.nullable!) {
            return Checkbox(value: row.nullable!, onChanged: null);
          }
          return const SizedBox();
        },
      ),
      TableColumn(
        header: const Header('Addable'),
        builder: (context, row) {
          if (row.addable!) {
            return Checkbox(value: row.addable!, onChanged: null);
          }
          return const SizedBox();
        },
      ),
      TableColumn(
        header: const Header('Updatable'),
        builder: (context, row) {
          if (row.updatable!) {
            return Checkbox(value: row.updatable!, onChanged: null);
          }
          return const SizedBox();
        },
      ),
    ];
  }

  final ScrollController scrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkAreaBloc, WorkAreaState>(
      builder: (context, state) {
        if (state is WorkAreaSelectSuccess) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(state.entity.name!),
                primary: false,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blueGrey.shade300,
                elevation: 0,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ListTile(title: Text('Attributes', style: Theme.of(context).textTheme.headline5)),
                    Center(
                      child: Scrollbar(
                        controller: scrollController1,
                        child: SingleChildScrollView(
                          controller: scrollController1,
                          scrollDirection: Axis.horizontal,
                          child: CustomTable(columns: columns, rows: state.entity.attributes?.map((e) => e!).toList() ?? List<Attribute>.empty()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(title: Text('Searches', style: Theme.of(context).textTheme.headline5)),
                  ],
                ),
              )
            ],
          );
        }
        return Container();
      },
    );
  }
}
