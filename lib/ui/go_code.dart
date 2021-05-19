import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoCodeField extends StatefulWidget {
  const GoCodeField({Key? key, required this.code}) : super(key: key);

  final String code;

  @override
  _GoCodeEditState createState() => _GoCodeEditState();
}

class _GoCodeEditState extends State<GoCodeField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.code);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onTap: () => _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length),
      enableSuggestions: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Go',
        suffixIcon: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.copy),
          tooltip: 'Copy to clipboard',
          onPressed: () => Clipboard.setData(ClipboardData(text: _controller.text)),
        ),
      ),
      style: const TextStyle(fontFamily: 'FiraCode', fontSize: 13),
      maxLines: null,
      readOnly: true,
    );
  }
}
