import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/ui/ui.dart';

class NamespaceAutocomplete extends StatefulWidget {
  const NamespaceAutocomplete({Key? key, this.initialValue = '', this.onSubmitted}) : super(key: key);

  final String initialValue;
  final ValueChanged<String>? onSubmitted;

  @override
  _NamespaceAutocompleteState createState() => _NamespaceAutocompleteState();
}

class _NamespaceAutocompleteState extends State<NamespaceAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return MFDAutocomplete(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Namespace',
      ),
      initialValue: widget.initialValue,
      optionsLoader: (query) async {
        final projectState = BlocProvider.of<ProjectBloc>(context).state;
        if (projectState is! ProjectLoadSuccess) {
          return List.empty();
        }

        final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
        return projectState.project.namespaces.map((e) => e.name).where((element) => element.contains(precursor));
      },
      onSubmitted: widget.onSubmitted,
    );
  }
}
