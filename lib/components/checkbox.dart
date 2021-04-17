import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CheckboxStateful extends StatefulWidget {
  const CheckboxStateful({
    Key? key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
  })  : assert(tristate || value != null),
        super(key: key);

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  _CheckboxStatefulState createState() => _CheckboxStatefulState();
}

class _CheckboxStatefulState extends State<CheckboxStateful> {
  bool? value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      key: widget.key,
      value: value,
      tristate: widget.tristate,
      onChanged: (newValue) {
        value = newValue;
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
        setState(() {});
      },
      mouseCursor: widget.mouseCursor,
      activeColor: widget.activeColor,
      fillColor: widget.fillColor,
      checkColor: widget.checkColor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      overlayColor: widget.overlayColor,
      splashRadius: widget.splashRadius,
      materialTapTargetSize: widget.materialTapTargetSize,
      visualDensity: widget.visualDensity,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
    );
  }
}
