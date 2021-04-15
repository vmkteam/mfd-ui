import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/work_area_bloc.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/services/api/api_client.dart';

import 'file:///C:/Users/Arog/AndroidStudioProjects/mfdui/lib/project/project_bloc.dart';

class WorkArea extends StatelessWidget {
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
              AttributesTable(),
              SearchesTable(),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class AttributesTable extends StatelessWidget {
  List<TableColumn<Attribute>> get columns {
    return [
      TableColumn(
        header: const Header('Name'),
        builder: (context, row) {
          return Row(children: [
            Text(row.name!),
            if (row.primaryKey ?? false) ...[
              const Spacer(),
              Tooltip(message: 'Primary key', child: Icon(Icons.vpn_key, color: Theme.of(context).accentColor)),
            ],
          ]);
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
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ListTile(title: Text('Attributes', style: Theme.of(context).textTheme.headline5)),
          Center(
            child: Scrollbar(
              controller: scrollController1,
              child: SingleChildScrollView(
                controller: scrollController1,
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<WorkAreaBloc, WorkAreaState>(
                  builder: (context, state) {
                    if (state is WorkAreaSelectSuccess) {
                      return CustomTable(columns: columns, rows: state.entity.attributes?.map((e) => e!).toList() ?? List<Attribute>.empty());
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchesTable extends StatelessWidget {
  List<TableColumn<Search>> get columns {
    return [
      TableColumn(
        header: const Header('Name'),
        builder: (context, row) {
          return Text(row.name!);
        },
      ),
      TableColumn(
        header: const Header('Attribute'),
        builder: (context, row) {
          return Text(row.attrName!);
        },
      ),
      TableColumn(
        header: const Header('Type'),
        builder: (context, row) {
          return Text(row.searchType!);
        },
      ),
      TableColumn(
        header: const Header('Actions'),
        builder: (context, row) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  BlocProvider.of<ProjectBloc>(context).add(ProjectEntitySearchDeleted(entityName, searchName));
                },
              )
            ],
          );
        },
      ),
    ];
  }

  final ScrollController scrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ListTile(title: Text('Searches', style: Theme.of(context).textTheme.headline5)),
          Center(
            child: Scrollbar(
              controller: scrollController1,
              child: SingleChildScrollView(
                controller: scrollController1,
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<WorkAreaBloc, WorkAreaState>(
                  builder: (context, state) {
                    if (state is WorkAreaSelectSuccess) {
                      return CustomTable(columns: columns, rows: state.entity.searches?.map((e) => e!).toList() ?? List<Search>.empty());
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
