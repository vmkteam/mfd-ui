import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/services/api/api_client.dart' as api;
import 'package:mfdui/ui/autocomplete/autocomplete.dart';

class GoTypeAutocomplete extends StatefulWidget {
  const GoTypeAutocomplete({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String value;
  final ValueChanged<String> onChanged;

  @override
  _GoTypeAutocompleteState createState() => _GoTypeAutocompleteState();
}

class _GoTypeAutocompleteState extends State<GoTypeAutocomplete> {
  List<String>? cachedResp;

  @override
  Widget build(BuildContext context) {
    return MFDAutocomplete(
      initialValue: widget.value,
      loadOnTap: true,
      optionsLoader: (query) async {
        if (cachedResp != null) {
          return Future(() => cachedResp!.where((element) => element.contains(query)));
        }
        final resp = RepositoryProvider.of<api.ApiClient>(context).public.types(api.PublicTypesArgs());
        return resp.then((value) => value!.map((e) => e!)).then((value) {
          cachedResp = value.toList();
          return value.where((element) => element.contains(query));
        });
        //Future(() => ['int4', 'timestamptz', 'text', 'varchar', 'date'].where((element) => element.contains(query)));
      },
      onSubmitted: widget.onChanged,
    );
  }
}
