import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/checkbox.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/editor/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/public_repo.dart';
import 'package:mfdui/ui/autocomplete/autocomplete.dart';

part 'dbtype_autocomplete.dart';
part 'gotype_autocomplete.dart';

class AttributesTable extends StatelessWidget {
  AttributesTable({Key? key, required this.editorBloc}) : super(key: key);

  final EditorBloc editorBloc;

  List<TableColumn<Attribute>> get columns {
    return [
      TableColumn(
        header: const Header('Name'),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.name,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(name: value))),
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
          return MFDAutocomplete(
            initialValue: row.dbName,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(dbName: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('DB type'),
        builder: (context, index, row) {
          return DBTypeAutocomplete(
            value: row.dbType,
            onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(dbType: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('Is array'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.isArray,
              onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(isArray: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header('go type'),
        builder: (context, index, row) {
          return GoTypeAutocomplete(
            value: row.goType,
            onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(goType: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('Nullable'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.nullable,
              onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(nullable: value))),
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
              onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(addable: value))),
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
              onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(updatable: value))),
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
                onPressed: () => editorBloc.add(EntityAttributeDeleted(index)),
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
                onPressed: () => editorBloc.add(EntityAttributeAdded()),
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
                child: BlocBuilder<EditorBloc, EditorState>(
                  builder: (context, state) {
                    if (state is EditorEntityLoadSuccess) {
                      return CustomTable(columns: columns, rows: state.entity.attributes);
                    }
                    return const SizedBox.shrink();
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
