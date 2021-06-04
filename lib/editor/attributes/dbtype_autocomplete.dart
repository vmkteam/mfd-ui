part of 'attributes_table.dart';

class DBTypeAutocomplete extends StatelessWidget {
  const DBTypeAutocomplete({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return MFDTextEdit<MFDLoadResult>(
      controller: TextEditingController(text: value),
      style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
      decorationOptions: const TextEditDecorationOptions(hideUnfocusedBorder: true),
      itemsLoader: (query) async {
        if (query == null) {
          return [];
        }
        final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
        return RepositoryProvider.of<PublicRepo>(context).dbTypes(precursor).then((collection) => collection.map(
              (e) => MFDLoadResult(e),
            ));
      },
      preload: true,
      onSubmitted: onChanged,
    );
  }
}
