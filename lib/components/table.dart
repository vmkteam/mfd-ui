import 'package:flutter/material.dart';

class CustomTable<RowType> extends StatelessWidget {
  const CustomTable({Key? key, required this.columns, required this.rows}) : super(key: key);

  final List<TableColumn<RowType>> columns;
  final List<RowType> rows;

  @override
  Widget build(BuildContext context) {
    final lines = List.generate(
        rows.length,
        (lineNumber) => DataRow(
            cells: columns
                .map((column) => DataCell(column.builder(
                      context,
                      lineNumber,
                      rows[lineNumber],
                    )))
                .toList()));
    if (hasFooter) {
      lines.add(DataRow(
        cells: columns
            .map(
              (column) => column.footerBuilder != null ? DataCell(column.footerBuilder!(context)) : DataCell.empty,
            )
            .toList(),
      ));
    }
    return DataTable(
      columnSpacing: 10,
      dataRowHeight: 48,
      columns: columns
          .map(
            (column) => DataColumn(
              label: column.header.child ?? Text(column.header.label ?? ''),
              tooltip: column.header.tooltip,
            ),
          )
          .toList(growable: false),
      rows: lines,
    );
  }

  bool get hasFooter => columns.any((element) => element.footerBuilder != null);
}

@immutable
class Header {
  const Header({this.label, this.tooltip, this.child, this.help});

  final String? label;
  final String? tooltip;
  final Widget? child;
  final String? help;
}

@immutable
class TableColumn<RowType> {
  const TableColumn({required this.header, required this.builder, this.footerBuilder});

  final Header header;
  final CellBuilder<RowType> builder;
  final WidgetBuilder? footerBuilder;
}

typedef CellBuilder<RowType> = Widget Function(BuildContext context, int rowIndex, RowType row);
