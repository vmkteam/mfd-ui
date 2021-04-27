import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/blocs/work_area_bloc.dart';
import 'package:mfdui/components/searches/searchtype_autocomplete.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/project/project.dart';

class SearchesTable extends StatefulWidget {
  const SearchesTable({Key? key, required this.waBloc}) : super(key: key);

  final WorkAreaBloc waBloc;

  @override
  _SearchesTableState createState() => _SearchesTableState();
}

class _SearchesTableState extends State<SearchesTable> {
  List<TableColumn<Search>> get columns {
    return [
      TableColumn(
        header: const Header('Name'),
        builder: (context, index, row) {
          return TextField(
            controller: TextEditingController(text: row.name),
            onChanged: (value) => widget.waBloc.add(EntitySearchChanged(index, row.copyWith(name: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('Attribute'),
        builder: (context, index, row) {
          return TextField(
            controller: TextEditingController(text: row.attrName),
            onChanged: (value) => widget.waBloc.add(EntitySearchChanged(index, row.copyWith(attrName: value))),
          );
        },
      ),
      TableColumn(
        header: const Header('Type'),
        builder: (context, index, row) {
          return SearchTypeAutocomplete(
            value: row.searchType,
            onChanged: (value) => widget.waBloc.add(EntitySearchChanged(index, row.copyWith(searchType: value))),
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
                onPressed: () => setState(() {
                  widget.waBloc.add(EntitySearchDeleted(index));
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
                tooltip: 'Add search',
                onPressed: () => setState(() {
                  widget.waBloc.add(EntitySearchAdded());
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
                      return CustomTable(columns: columns, rows: state.entity.searches);
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
