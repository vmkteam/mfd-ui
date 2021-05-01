import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/editor/editor_bloc.dart';
import 'package:mfdui/editor/searches/searchtype_autocomplete.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/ui/ui.dart';

class SearchesTable extends StatelessWidget {
  SearchesTable({Key? key, required this.editorBloc}) : super(key: key);

  final EditorBloc editorBloc;

  List<TableColumn<Search>> get columns {
    return [
      TableColumn(
        header: const Header('Name'),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.name,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntitySearchChanged(index, row.copyWith(name: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('Attribute'),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.attrName,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntitySearchChanged(index, row.copyWith(attrName: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('Type'),
        builder: (context, index, row) {
          return SearchTypeAutocomplete(
            value: row.searchType,
            onSubmitted: (value) => editorBloc.add(EntitySearchChanged(index, row.copyWith(searchType: value))),
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
                tooltip: 'Remove search',
                onPressed: () => editorBloc.add(EntitySearchDeleted(index)),
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
                onPressed: () => editorBloc.add(EntitySearchAdded()),
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
          ListTile(title: Text('Searches', style: Theme.of(context).textTheme.headline5)),
          Center(
            child: Scrollbar(
              controller: scrollController1,
              child: SingleChildScrollView(
                controller: scrollController1,
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<EditorBloc, EditorState>(
                  builder: (context, state) {
                    if (state is EditorEntityLoadSuccess) {
                      return CustomTable(columns: columns, rows: state.entity.searches);
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
