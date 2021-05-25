import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/ui/ui.dart';

class NamespaceAutocomplete extends StatelessWidget {
  const NamespaceAutocomplete({Key? key, this.initialValue = '', this.onSubmitted}) : super(key: key);

  final String initialValue;
  final ValueChanged<String?>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return MFDTextEdit<MFDLoadResult>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Namespace',
      ),
      controller: TextEditingController(text: initialValue),
      itemsLoader: (query) async {
        if (query == null) {
          return List.empty();
        }
        final projectState = BlocProvider.of<ProjectBloc>(context).state;
        if (projectState is! ProjectLoadSuccess) {
          return List.empty();
        }

        final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
        return projectState.project.namespaces.map((e) => e.name).where((element) => element.contains(precursor)).map(
              (e) => MFDLoadResult(e),
            );
      },
      itemBuilder: (context, query, option) => MFDSelectItem(value: option.value, child: Text(option.value!)),
      onSubmitted: onSubmitted,
      preload: true,
    );
  }
}
