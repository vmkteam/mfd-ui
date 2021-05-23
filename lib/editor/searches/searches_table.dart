import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/editor/searches/searchtype_autocomplete.dart';
import 'package:mfdui/editor/xmlpage/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart';
import 'package:mfdui/ui/go_code.dart';
import 'package:mfdui/ui/ui.dart';

class SearchesTable extends StatefulWidget {
  const SearchesTable({Key? key, required this.editorBloc, this.attributes}) : super(key: key);

  final EditorBloc editorBloc;
  final List<Attribute>? attributes;

  @override
  _SearchesTableState createState() => _SearchesTableState();
}

class _SearchesTableState extends State<SearchesTable> {
  List<TableColumn<Search>> get columns {
    return [
      TableColumn(
        header: const Header(label: 'Name'),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.name,
            optionsLoader: null,
            onSubmitted: (value) => widget.editorBloc.add(EntitySearchChanged(index, row.copyWith(name: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Attribute'),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.attrName,
            optionsLoader: (query) {
              return Future.value(widget.attributes?.map((e) => e.name) ?? []);
            },
            onSubmitted: (value) => widget.editorBloc.add(EntitySearchChanged(index, row.copyWith(attrName: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Type'),
        builder: (context, index, row) {
          final state = widget.editorBloc.state;
          late final String columnName;
          if (state is EditorEntityLoadSuccess) {
            try {
              columnName = state.entity.attributes.firstWhere((element) => element.name == row.attrName).dbName;
            } on StateError catch (e) {
              columnName = '';
            }
          } else {
            columnName = row.attrName;
          }
          return SearchTypeAutocomplete(
            value: row.searchType,
            columnName: columnName,
            onSubmitted: (value) => widget.editorBloc.add(EntitySearchChanged(index, row.copyWith(searchType: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(
          label: 'Go type',
          tooltip: 'Type search that is used for search. Available only with JSONB_PATH search.',
        ),
        builder: (context, rowIndex, row) {
          return MFDAutocomplete(
            // decoration: InputDecoration(),
            initialValue: row.goType,
            optionsLoader: (query) {
              return Future.value(_searchAvailableGoTypes);
            },
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
                tooltip: 'Remove search',
                onPressed: () => widget.editorBloc.add(EntitySearchDeleted(index)),
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
                tooltip: 'Add search',
                onPressed: () => widget.editorBloc.add(EntitySearchAdded()),
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
                child: Row(
                  children: [
                    BlocBuilder<EditorBloc, EditorState>(
                      builder: (context, state) {
                        if (state is EditorEntityLoadSuccess) {
                          return CustomTable(columns: columns, rows: state.entity.searches);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    // todo: add on click and regenerate?
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                      child: Icon(Icons.double_arrow, color: Colors.black26),
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
                      future: RepositoryProvider.of<ApiClient>(context)
                          .xml
                          .generateSearchModelCode(XmlGenerateSearchModelCodeArgs(
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
}

final _searchAvailableGoTypes = [
  'string',
  'int',
  'bool',
  'float64',
  'uint',
  'int64',
  'uint64',
  'float32',
].expand((element) => [element, '[]$element']);

const _attributeHelper = '''
Attribute - applies to attribute
FKEntity.Attribute - applies to foreign entity attribute
AttributeJson->path->to->json->field - uses search for jsonb field''';

final _attributesHelperLines = '\n'.allMatches(_attributeHelper).length + 1;
