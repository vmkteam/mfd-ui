import 'package:flutter/material.dart';
import 'package:mfdui/ui/autocomplete/autocomplete.dart';

class DBTypeAutocomplete extends StatelessWidget {
  const DBTypeAutocomplete({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return MFDAutocomplete(
      initialValue: value,
      loadOnTap: true,
      optionsLoader: (query) {
        return Future(() => ['int4', 'timestamptz', 'text', 'varchar', 'date'].where((element) => element.contains(query)));
      },
      onSubmitted: onChanged,
    );
  }
}
