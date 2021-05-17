import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/checkbox.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/editor/xmlpage/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/public_repo.dart';
import 'package:mfdui/ui/go_code.dart';
import 'package:mfdui/ui/ui.dart';

part 'dbtype_autocomplete.dart';
part 'gotype_autocomplete.dart';

class AttributesTable extends StatelessWidget {
  AttributesTable({Key? key, required this.editorBloc}) : super(key: key);

  final EditorBloc editorBloc;

  List<TableColumn<Attribute>> get columns {
    return [
      TableColumn(
        header: Header(
          tooltip: 'Primary key',
          child: Builder(
            builder: (context) => Icon(Icons.vpn_key, color: Theme.of(context).accentColor),
          ),
        ),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.primaryKey,
              onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(primaryKey: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Name'),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.name,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(name: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'DB column'),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.dbName,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(dbName: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(),
        builder: (context, rowIndex, row) => const SizedBox(width: 45),
      ),
      TableColumn(
        header: const Header(label: 'DB type'),
        builder: (context, index, row) {
          return DBTypeAutocomplete(
            value: row.dbType,
            onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(dbType: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Is array'),
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
        header: const Header(label: 'Nullable'),
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
        header: const Header(),
        builder: (context, rowIndex, row) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.arrow_forward, color: Colors.black26),
        ),
      ),
      TableColumn(
        header: const Header(label: 'go type'),
        builder: (context, index, row) {
          return GoTypeAutocomplete(
            value: row.goType,
            onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(goType: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(),
        builder: (context, rowIndex, row) => const SizedBox(width: 45),
      ),
      TableColumn(
        header: const Header(label: 'Addable'),
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
        header: const Header(label: 'Updatable'),
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
        header: const Header(),
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
                child: Row(
                  children: [
                    BlocBuilder<EditorBloc, EditorState>(
                      builder: (context, state) {
                        if (state is EditorEntityLoadSuccess) {
                          return CustomTable(columns: columns, rows: state.entity.attributes);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    // todo: add on click and regenerate?
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                      child: Icon(Icons.double_arrow, color: Colors.black26),
                    ),
                    const SizedBox(
                      width: 400,
                      child: GoCodeField(
                        code: _gocodeex,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _gocodeex = '''
type Model struct {
  Field1 string `json:"field1"`
}''';
