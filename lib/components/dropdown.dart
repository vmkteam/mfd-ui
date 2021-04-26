import 'package:flutter/material.dart';

class MFDDropdown<T> extends StatefulWidget {
  const MFDDropdown({
    Key? key,
    required this.loadFunc,
    required this.itemBuilder,
    this.onChanged,
    this.value,
  }) : super(key: key);

  final T? value;
  final MFDDropdownLoadFunc<T> loadFunc;
  final MFDDropdownItemBuilder<T> itemBuilder;
  final ValueChanged<T?>? onChanged;

  @override
  _MFDDropdownState<T> createState() => _MFDDropdownState<T>();
}

typedef MFDDropdownLoadFunc<ResultType> = Future<List<ResultType>> Function();
typedef MFDDropdownItemBuilder<ResultType> = DropdownMenuItem<ResultType> Function(BuildContext context, ResultType value);

class _MFDDropdownState<T> extends State<MFDDropdown<T>> {
  bool isLoading = false;
  List<T>? items;

  @override
  void initState() {
    super.initState();
    loadOptions();
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<T>> vv = items
            ?.map(
              (e) => widget.itemBuilder(context, e),
            )
            .toList() ??
        List<DropdownMenuItem<T>>.empty();
    return DropdownButton<T>(
      items: vv,
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }

  Future loadOptions() async {
    setState(() {
      isLoading = true;
    });
    try {
      items = await widget.loadFunc();
    } catch (e) {
      // todo
      print(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }
}
