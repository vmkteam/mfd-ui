part of 'attributes_table.dart';

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
        final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
        return RepositoryProvider.of<PublicRepo>(context).dbTypes(precursor);
      },
      onSubmitted: onChanged,
    );
  }
}
