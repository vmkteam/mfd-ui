import 'package:flutter/material.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart' as api;
import 'package:mfdui/ui/autocomplete/autocomplete.dart';

class TableAutocomplete extends StatefulWidget {
  const TableAutocomplete({
    Key? key,
    this.tableName = '',
    required this.projectBloc,
    required this.apiClient,
    this.onSubmitted,
  }) : super(key: key);

  final String tableName;
  final ProjectBloc projectBloc;
  final api.ApiClient apiClient;
  final ValueChanged<String>? onSubmitted;

  @override
  _TableAutocompleteState createState() => _TableAutocompleteState();
}

class _TableAutocompleteState extends State<TableAutocomplete> {
  List<String>? _cachedTables;
  String tableName = '';

  @override
  void initState() {
    tableName = widget.tableName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MFDAutocomplete(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Table',
      ),
      initialValue: tableName,
      optionsLoader: (query) async {
        final projectState = widget.projectBloc.state;
        if (projectState is! ProjectLoadSuccess) {
          return List.empty();
        }

        final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
        if (_cachedTables != null) {
          return _cachedTables!.where((element) => element.contains(precursor));
        }

        final result = await widget.apiClient.project.tables(api.ProjectTablesArgs()).then(
              (list) => list!.map((element) => element!),
            );
        _cachedTables = result.toList();

        // start cache invalidation
        Future.delayed(const Duration(seconds: 10)).then((value) => _cachedTables = null);

        return result.where((element) => element.contains(precursor));
      },
      onSubmitted: widget.onSubmitted,
    );
  }
}
