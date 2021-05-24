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
        key: ValueKey(rows[lineNumber]),
        cells: List.generate(columns.length, (columnIdx) {
          return DataCell(columns[columnIdx].builder(
            context,
            lineNumber,
            rows[lineNumber],
          ));
        }),
      ),
    );
    if (hasFooter) {
      lines.add(DataRow(
        cells: List.generate(
          columns.length,
          (columnIdx) => columns[columnIdx].footerBuilder != null
              ? DataCell(
                  columns[columnIdx].footerBuilder!(context),
                )
              : DataCell.empty,
        ),
      ));
    }
    return DataTable(
      columnSpacing: 10,
      dataRowHeight: 48,
      columns: List.generate(
        columns.length,
        (columnIdx) => DataColumn(
          label: columns[columnIdx].header.child ?? Text(columns[columnIdx].header.label ?? ''),
          tooltip: columns[columnIdx].header.tooltip,
        ),
      ),
      rows: lines,
    );
  }

  bool get hasFooter => columns.any((element) => element.footerBuilder != null);
}

@immutable
class Header {
  const Header({this.label, this.tooltip, this.child, this.alignment});

  final String? label;
  final String? tooltip;
  final Widget? child;
  final Alignment? alignment;
}

@immutable
class TableColumn<RowType> {
  const TableColumn({
    required this.header,
    required this.builder,
    this.footerBuilder,
    this.flex,
    this.flexFit,
  });

  final Header header;
  final CellBuilder<RowType> builder;
  final WidgetBuilder? footerBuilder;
  final int? flex;
  final FlexFit? flexFit;
}

typedef CellBuilder<RowType> = Widget Function(BuildContext context, int rowIndex, RowType row);
