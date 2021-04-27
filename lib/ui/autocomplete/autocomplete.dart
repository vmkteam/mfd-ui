import 'dart:html';

import 'package:flutter/material.dart';

class MFDAutocomplete extends StatefulWidget {
  const MFDAutocomplete({
    Key? key,
    required this.initialValue,
    required this.optionsLoader,
    required this.onSubmitted,
    this.preload = false,
    this.loadOnTap = false,
  }) : super(key: key);

  final String initialValue;
  final bool preload;
  final bool loadOnTap;
  final OptionsLoader optionsLoader;
  final ValueChanged<String> onSubmitted;

  @override
  _MFDAutocompleteState createState() => _MFDAutocompleteState();
}

typedef OptionsLoader = Future<Iterable<String>> Function(String query);

class _MFDAutocompleteState extends State<MFDAutocomplete> {
  late TextEditingController _controller;
  final LayerLink _optionsLayerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  bool isLoading = false;
  OverlayEntry? _optionsOverlay;
  Iterable<String> _options = List.empty();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_onChangeText);
    _focusNode.addListener(_onChangeFocus);
    if (widget.preload) {
      _loadOptions();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onChangeFocus);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _optionsLayerLink,
      child: TextField(
        onTap: widget.loadOnTap ? _onTap : null,
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: _select,
        onEditingComplete: _onSubmitted,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(6),
          border: OutlineInputBorder(
            gapPadding: 1,
            borderSide: _focusNode.hasFocus ? const BorderSide() : const BorderSide(style: BorderStyle.none, width: 0),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() {
      isLoading = true;
    });
    final res = await widget.optionsLoader(_controller.text);
    _options = res;
    setState(() {
      isLoading = false;
    });
    _updateOverlay();
  }

  void _onChangeFocus() {
    _updateOverlay();
  }

  void _onChangeText() {
    _loadOptions();
    _updateOverlay();
  }

  void _updateOverlay() {
    if (_shouldShowOptions) {
      _optionsOverlay?.remove();
      _optionsOverlay = OverlayEntry(
        builder: (context) => CompositedTransformFollower(
          link: _optionsLayerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          child: _AutocompleteOptions(
            onSelected: _select,
            options: _options,
            isLoading: isLoading,
          ),
        ),
      );
      Overlay.of(context, rootOverlay: true)!.insert(_optionsOverlay!);
    } else if (_optionsOverlay != null) {
      _optionsOverlay!.remove();
      _optionsOverlay = null;
    }
  }

  bool get _shouldShowOptions {
    return _focusNode.hasFocus;
  }

  void _select(String newSelect) {
    _focusNode.unfocus();
    if (newSelect == _controller.text) {
      return;
    }
    setState(() {
      _controller.value = TextEditingValue(
        selection: TextSelection.collapsed(offset: newSelect.length),
        text: newSelect,
      );
    });
  }

  void _onSubmitted() {
    if (_options.isEmpty) {
      return;
    }
    _select(_options.first);
  }
}

class _AutocompleteOptions extends StatelessWidget {
  const _AutocompleteOptions({
    Key? key,
    required this.onSelected,
    required this.options,
    required this.isLoading,
  }) : super(key: key);

  final void Function(String) onSelected;

  final Iterable<String> options;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 100, maxWidth: 200),
          child: isLoading
              ? const LinearProgressIndicator()
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final option = options.elementAt(index);
                    return ListTile(
                      dense: true,
                      selected: index == 0,
                      onTap: () {
                        onSelected(option);
                      },
                      title: Text(option),
                    );
                  },
                ),
        ),
      ),
    );
  }
}