import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/work_area_bloc.dart';
import 'package:mfdui/components/attributes/dbtype_autocomplete.dart';
import 'package:mfdui/components/attributes/gotype_autocomplete.dart';
import 'package:mfdui/components/checkbox.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/project/project.dart';

class AttributesTable extends StatefulWidget {
  const AttributesTable({Key? key, required this.waBloc}) : super(key: key);

  final WorkAreaBloc waBloc;

  @override
  _AttributesTableState createState() => _AttributesTableState();
}

class _AttributesTableState extends State<AttributesTable> {
  List<TableColumn<Attribute>> get columns {
    return [
      TableColumn(
        header: const Header('Name'),
        builder: (context, index, row) {
          final name = TextField(
            controller: TextEditingController(text: row.name),
            onChanged: (value) => widget.waBloc.add(EntityAttributeChanged(index, row.copyWith(name: value))),
          );
          if (row.primaryKey) {
            return Row(children: [
              Expanded(child: name),
              if (row.primaryKey) ...[
                Tooltip(message: 'Primary key', child: Icon(Icons.vpn_key, color: Theme.of(context).accentColor)),
              ],
            ]);
          }
          return name;
        },
      ),
      TableColumn(
        header: const Header('DBName'),
        builder: (context, index, row) {
          return TextField(
            controller: TextEditingController(text: row.dbName),
            onChanged: (value) => widget.waBloc.add(EntityAttributeChanged(index, row.copyWith(dbName: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('DB type'),
        builder: (context, index, row) {
          return DBTypeAutocomplete(
            value: row.dbType,
            onChanged: (value) => widget.waBloc.add(
              EntityAttributeChanged(index, row.copyWith(dbType: value)),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header('go type'),
        builder: (context, index, row) {
          return GoTypeAutocomplete(
            value: row.goType,
            onChanged: (value) => widget.waBloc.add(EntityAttributeChanged(index, row.copyWith(goType: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('Nullable'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.nullable,
              onChanged: (value) => widget.waBloc.add(EntityAttributeChanged(index, row.copyWith(nullable: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header('Addable'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.addable,
              onChanged: (value) => widget.waBloc.add(EntityAttributeChanged(index, row.copyWith(addable: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header('Updatable'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.updatable,
              onChanged: (value) => widget.waBloc.add(EntityAttributeChanged(index, row.copyWith(updatable: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(''),
        builder: (context, index, row) {
          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).errorColor),
                tooltip: 'Remove attribute',
                onPressed: () => setState(() {
                  widget.waBloc.add(EntityAttributeDeleted(index));
                }),
                splashRadius: 19,
              )
            ],
          );
        },
        footerBuilder: (context) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                tooltip: 'Add attribute',
                onPressed: () => setState(() {
                  widget.waBloc.add(EntityAttributeAdded());
                }),
                splashRadius: 19,
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
                      return CustomTable(columns: columns, rows: state.entity.attributes);
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
