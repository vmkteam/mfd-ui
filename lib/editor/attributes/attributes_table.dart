import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/checkbox.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/editor/xmlpage/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart' as api;
import 'package:mfdui/services/public_repo.dart';
import 'package:mfdui/ui/go_code.dart';
import 'package:mfdui/ui/ui.dart';

part 'dbtype_autocomplete.dart';
part 'gotype_autocomplete.dart';

class AttributesTable extends StatefulWidget {
  const AttributesTable({
    Key? key,
    required this.editorBloc,
    this.entityName,
  }) : super(key: key);

  final EditorBloc editorBloc;
  final String? entityName;

  @override
  _AttributesTableState createState() => _AttributesTableState();
}

class _AttributesTableState extends State<AttributesTable> with AutomaticKeepAliveClientMixin {
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
              onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(primaryKey: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Name'),
        builder: (context, index, row) {
          return MFDTextEdit<MFDLoadResult>(
            controller: TextEditingController(text: row.name),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode', fontWeight: FontWeight.bold),
            decorationOptions: const TextEditDecorationOptions(hideUnfocusedBorder: true),
            onSubmitted: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(name: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'DB column'),
        builder: (context, index, row) {
          return MFDTextEdit<MFDLoadResult>(
            controller: TextEditingController(text: row.dbName),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
            decorationOptions: const TextEditDecorationOptions(hideUnfocusedBorder: true),
            onSubmitted: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(dbName: value))),
          );
        },
      ),
      TableColumn(
        header: Header(child: Container(width: 1, color: Colors.grey.shade300)),
        builder: (context, rowIndex, row) => Container(width: 1, color: Colors.grey.shade300),
      ),
      TableColumn(
        header: const Header(label: 'DB type'),
        builder: (context, index, row) {
          return DBTypeAutocomplete(
            value: row.dbType,
            onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(dbType: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Is array'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.isArray,
              onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(isArray: value))),
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
              onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(nullable: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(),
        builder: (context, rowIndex, row) => const Icon(Icons.arrow_forward, color: Colors.black26, size: 14),
      ),
      TableColumn(
        header: const Header(label: 'go type'),
        builder: (context, index, row) {
          return GoTypeAutocomplete(
            value: row.goType,
            attribute: row,
            entityName: widget.entityName ?? '',
            onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(goType: value))),
          );
        },
      ),
      TableColumn(
        header: Header(child: Container(width: 1, color: Colors.grey.shade300)),
        builder: (context, rowIndex, row) => Container(width: 1, color: Colors.grey.shade300),
      ),
      TableColumn(
        header: const Header(label: 'Addable'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.addable,
              onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(addable: value))),
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
              onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(updatable: value))),
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
                onPressed: () => widget.editorBloc.add(EntityAttributeDeleted(index)),
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
                onPressed: () => widget.editorBloc.add(EntityAttributeAdded()),
                splashRadius: 19,
              )
            ],
          );
        },
      ),
    ];
  }

  final ScrollController scrollController1 = ScrollController();
  bool previewCode = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: TextButton.icon(
              icon: const Icon(Icons.preview),
              label: const Text('Preview code'),
              onPressed: () {
                setState(() {
                  previewCode = true;
                });
              },
            ),
          ),
          if (previewCode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 400,
                child: BlocBuilder<EditorBloc, EditorState>(
                  builder: (context, state) {
                    if (state is! EditorEntityLoadSuccess) {
                      return const SizedBox.shrink();
                    }
                    return FutureBuilder<String>(
                      initialData: '',
                      future: RepositoryProvider.of<api.ApiClient>(context)
                          .xml
                          .generateModelCode(api.XmlGenerateModelCodeArgs(
                            entity: state.entity.toApi(),
                          ))
                          .then((value) => value ?? ''),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()));
                        }
                        return GoCodeField(
                          code: snapshot.data!,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
