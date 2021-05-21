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
          cells: List.generate(
              columns.length,
              (columnIdx) => DataCell(columns[columnIdx].builder(
                    context,
                    lineNumber,
                    rows[lineNumber],
                  )))),
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
class Header extends StatelessWidget {
  const Header({this.label, this.tooltip, this.child, this.alignment});

  final String? label;
  final String? tooltip;
  final Widget? child;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (child != null) {
      result = child!;
    } else if (label != null) {
      result = Text(label!);
    } else {
      result = const SizedBox.shrink();
    }
    if (tooltip != null) {
      result = Tooltip(message: tooltip!, child: result);
    }
    if (alignment != null) {
      result = Align(alignment: alignment!, child: result);
    }
    return result;
  }
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

class MFDTable<RowType> extends StatelessWidget {
  const MFDTable({Key? key, required this.columns, required this.rows}) : super(key: key);

  final List<TableColumn<RowType>> columns;
  final List<RowType> rows;

  @override
  Widget build(BuildContext context) {
    // rows + header
    int rowsCount = rows.length + 1;
    final hasFooter = this.hasFooter;
    if (hasFooter) {
      rowsCount += 1;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rowsCount,
        (tableRowIndex) {
          if (tableRowIndex == 0) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                columns.length,
                (columnIndex) => Flexible(
                  flex: columns[columnIndex].flex ?? 1,
                  fit: columns[columnIndex].flexFit ?? FlexFit.tight,
                  child: columns[columnIndex].header,
                ),
              ),
            );
          }
          final rowIndex = tableRowIndex - 1;
          if (tableRowIndex == rowsCount - 1 && hasFooter) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                columns.length,
                (columnIndex) {
                  if (columns[columnIndex].footerBuilder == null) {
                    return Flexible(
                      flex: columns[columnIndex].flex ?? 1,
                      fit: columns[columnIndex].flexFit ?? FlexFit.tight,
                      child: const SizedBox(),
                    );
                  }
                  return Flexible(
                    flex: columns[columnIndex].flex ?? 1,
                    fit: columns[columnIndex].flexFit ?? FlexFit.tight,
                    child: columns[columnIndex].footerBuilder!(context),
                  );
                },
              ),
            );
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              columns.length,
              (columnIndex) => Flexible(
                flex: columns[columnIndex].flex ?? 1,
                fit: columns[columnIndex].flexFit ?? FlexFit.tight,
                child: columns[columnIndex].builder(context, rowIndex, rows[rowIndex]),
              ),
            ),
          );
        },
      ),
    );
  }

  bool get hasFooter => columns.any((element) => element.footerBuilder != null);
}
