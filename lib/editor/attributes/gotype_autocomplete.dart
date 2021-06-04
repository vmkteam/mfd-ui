part of 'attributes_table.dart';

class GoTypeAutocomplete extends StatelessWidget {
  const GoTypeAutocomplete({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.attribute,
    required this.entityName,
  }) : super(key: key);

  final String value;
  final ValueChanged<String?> onChanged;
  final Attribute attribute;
  final String entityName;

  @override
  Widget build(BuildContext context) {
    return MFDTextEdit<_LoadGoType>(
      controller: TextEditingController(text: value),
      style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
      decorationOptions: const TextEditDecorationOptions(
        horizontalItemPadding: 0,
        hideUnfocusedBorder: true,
      ),
      preload: true,
      itemsLoader: (query) {
        if (query == null) {
          return Future.value();
        }
        final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
        return RepositoryProvider.of<PublicRepo>(context).goTypes(precursor).then((collection) {
          final list = collection.map((e) => _LoadGoType(e)).toList();
          final favor = _recommendType();
          return [if (favor != null) favor, ...list];
        });
      },
      itemBuilder: (context, query, value) {
        return MFDSelectItem<String>(
          value: value.value!,
          child: ListTile(
            title: Text(value.value ?? '', softWrap: false),
            trailing: value.isRecommended
                ? Tooltip(
                    message: 'Recommended',
                    child: Icon(Icons.star, size: 18, color: Colors.yellow.shade700),
                  )
                : null,
          ),
        );
      },
      onSubmitted: onChanged,
    );
  }

  _LoadGoType? _recommendType() {
    String? value = _baseGoType();
    if (value == null) {
      return null;
    }
    if (attribute.dbType.toLowerCase() == 'jsonb') {
      value = entityName + attribute.name;
    }
    if (attribute.nullable && !attribute.primaryKey && !attribute.isArray) {
      value = '*' + value;
    }
    if (attribute.isArray) {
      value = '[]' + value;
    }
    return _LoadGoType(value, true);
  }

  String? _baseGoType() {
    switch (attribute.dbType.toLowerCase()) {
      case 'jsonb':
        return attribute.name + 'Params';
      case 'varchar':
      case 'text':
        return 'string';
      case 'timestamptz':
        return 'time.Time';
      case 'int4':
        return 'int';
      case 'bool':
        return 'bool';
    }
    return null;
  }
}

class _LoadGoType extends MFDLoadResult {
  _LoadGoType(String? value, [this.isRecommended = false]) : super(value);

  final bool isRecommended;
}
