import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/services/public_repo.dart';

class SearchTypeAutocomplete extends StatelessWidget {
  const SearchTypeAutocomplete({
    Key? key,
    required this.value,
    required this.onSubmitted,
    required this.columnName,
  }) : super(key: key);

  final String value;
  final String columnName;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.caption;
    return _DropdownBuilder<String>(
      value: value,
      onChanged: (value) => onSubmitted(value!),
      itemsLoader: () async {
        return RepositoryProvider.of<PublicRepo>(context).searchTypes('').then((value) => value.toList());
      },
      itemBuilder: (value) {
        final enumVal = SearchType.values.firstWhere((element) => describeEnum(element) == value, orElse: () => SearchType.SEARCHTYPE_UNKNOWN);
        final enumText = _searchTypeDisplayText(enumVal);
        final mainText = enumText != null ? 'WHERE $columnName $enumText' : '$value (unknown)';
        return DropdownMenuItem<String>(
          value: value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mainText),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(value, style: subtitleStyle),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _searchTypeDisplayText(SearchType enumVal) {
    switch (enumVal) {
      case SearchType.SEARCHTYPE_UNKNOWN:
        return null;
      case SearchType.SEARCHTYPE_EQUALS:
        return '= ?';
      case SearchType.SEARCHTYPE_NOT_EQUALS:
        return '!= ?';
      case SearchType.SEARCHTYPE_NULL:
        return 'is null';
      case SearchType.SEARCHTYPE_NOT_NULL:
        return 'is not null';
      case SearchType.SEARCHTYPE_GE:
        return '>= ?';
      case SearchType.SEARCHTYPE_LE:
        return '<= ?';
      case SearchType.SEARCHTYPE_G:
        return '> ?';
      case SearchType.SEARCHTYPE_L:
        return '< ?';
      case SearchType.SEARCHTYPE_LEFT_LIKE:
        return 'like %?';
      case SearchType.SEARCHTYPE_LEFT_ILIKE:
        return 'ilike %?';
      case SearchType.SEARCHTYPE_RIGHT_LIKE:
        return 'like ?%';
      case SearchType.SEARCHTYPE_RIGHT_ILIKE:
        return 'ilike ?%';
      case SearchType.SEARCHTYPE_LIKE:
        return 'like %?%';
      case SearchType.SEARCHTYPE_ILIKE:
        return 'ilike %?%';
      case SearchType.SEARCHTYPE_ARRAY:
        return 'in (?)';
      case SearchType.SEARCHTYPE_NOT_INARRAY:
        return 'not in (?)';
      case SearchType.SEARCHTYPE_ARRAY_CONTAINS:
        return '= any (?)';
      case SearchType.SEARCHTYPE_ARRAY_NOT_CONTAINS:
        return '!= any (?)';
      case SearchType.SEARCHTYPE_ARRAY_CONTAINED:
        return 'ARRAY[?] <@';
      case SearchType.SEARCHTYPE_ARRAY_INTERSECT:
        return 'ARRAY[?] &&';
      case SearchType.SEARCHTYPE_JSONB_PATH:
        return 'column @> ?';
    }
  }
}

enum SearchType {
  SEARCHTYPE_UNKNOWN,
  SEARCHTYPE_EQUALS,
  SEARCHTYPE_NOT_EQUALS,
  SEARCHTYPE_NULL,
  SEARCHTYPE_NOT_NULL,
  SEARCHTYPE_GE,
  SEARCHTYPE_LE,
  SEARCHTYPE_G,
  SEARCHTYPE_L,
  SEARCHTYPE_LEFT_LIKE,
  SEARCHTYPE_LEFT_ILIKE,
  SEARCHTYPE_RIGHT_LIKE,
  SEARCHTYPE_RIGHT_ILIKE,
  SEARCHTYPE_LIKE,
  SEARCHTYPE_ILIKE,
  SEARCHTYPE_ARRAY,
  SEARCHTYPE_NOT_INARRAY,
  SEARCHTYPE_ARRAY_CONTAINS,
  SEARCHTYPE_ARRAY_NOT_CONTAINS,
  SEARCHTYPE_ARRAY_CONTAINED,
  SEARCHTYPE_ARRAY_INTERSECT,
  SEARCHTYPE_JSONB_PATH,
}

class _DropdownBuilder<T> extends StatefulWidget {
  const _DropdownBuilder({Key? key, required this.itemsLoader, this.onChanged, this.value, required this.itemBuilder}) : super(key: key);

  final _ItemsLoader<T> itemsLoader;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final _ItemBuilder<T> itemBuilder;

  @override
  __DropdownBuilderState<T> createState() => __DropdownBuilderState<T>();
}

class __DropdownBuilderState<T> extends State<_DropdownBuilder<T>> {
  List<T>? items;

  @override
  void initState() {
    if (widget.value != null) {
      items = [widget.value!];
    }
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: widget.value,
      items: items?.map(widget.itemBuilder).toList(growable: false),
      onChanged: widget.onChanged,
    );
  }

  Future<void> loadItems() async {
    final result = await widget.itemsLoader();
    setState(() {
      items = result;
    });
  }
}

typedef _ItemsLoader<T> = Future<List<T>?> Function();
typedef _ItemBuilder<T> = DropdownMenuItem<T> Function(T);
