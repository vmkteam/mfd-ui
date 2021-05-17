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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: _controller,
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
          maxLines: null,
          readOnly: true,
        ),
      ],
    );
  }
}
