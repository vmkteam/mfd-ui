import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/services/public_repo.dart';
import 'package:mfdui/ui/autocomplete/autocomplete.dart';

class SearchTypeAutocomplete extends StatelessWidget {
  const SearchTypeAutocomplete({
    Key? key,
    required this.value,
    required this.onSubmitted,
  }) : super(key: key);

  final String value;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return MFDAutocomplete(
      initialValue: value,
      loadOnTap: true,
      optionsLoader: (query) async {
        final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
        return RepositoryProvider.of<PublicRepo>(context).searchTypes(precursor);
      },
      onSubmitted: onSubmitted,
    );
  }
}
