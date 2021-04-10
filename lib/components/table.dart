import 'package:flutter/material.dart';

class CustomTable<RowType> extends StatelessWidget {
  const CustomTable({Key? key, required this.columns, required this.rows}) : super(key: key);

  final List<TableColumn<RowType>> columns;
  final List<RowType> rows;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: columns.map((column) => DataColumn(label: Text(column.header.text))).toList(),
      rows: rows
          .map(
            (row) => DataRow(
              cells: columns
                  .map(
                    (column) => DataCell(column.builder(context, row)),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}

@immutable
class Header {
  const Header(this.text);

  final String text;
}

@immutable
class TableColumn<RowType> {
  const TableColumn({required this.header, required this.builder});

  final Header header;
  final CellBuilder<RowType> builder;
}

typedef CellBuilder<RowType> = Widget Function(BuildContext context, RowType row);
