import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/services/api/api_client.dart' as api;
import 'package:mfdui/ui/autocomplete/autocomplete.dart';

class SearchTypeAutocomplete extends StatefulWidget {
  const SearchTypeAutocomplete({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String value;
  final ValueChanged<String> onChanged;

  @override
  _SearchTypeAutocompleteState createState() => _SearchTypeAutocompleteState();
}

class _SearchTypeAutocompleteState extends State<SearchTypeAutocomplete> {
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
        final resp = RepositoryProvider.of<api.ApiClient>(context).public.searchTypes(api.PublicSearchTypesArgs());
        return resp.then((value) => value.map((e) => e!)).then((value) {
          cachedResp = value.toList();
          return value.where((element) => element.contains(query));
        });
      },
      onSubmitted: widget.onChanged,
    );
  }
}
