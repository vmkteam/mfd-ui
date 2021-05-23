part of 'ui.dart';

class MFDTextEdit extends StatefulWidget {
  const MFDTextEdit({
    Key? key,
    this.controller,
    this.decoration,
    this.focusNode,
    this.items,
    this.maxItemsShow = 5,
    this.itemHeight = 56,
  }) : super(key: key);

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final FocusNode? focusNode;

  final List<DropdownMenuItem<String>>? items;
  final int? maxItemsShow;
  final double? itemHeight;

  @override
  _MFDTextEditState createState() => _MFDTextEditState();
}

class _MFDTextEditState extends State<MFDTextEdit> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: widget.decoration ?? const InputDecoration(),
      controller: _controller,
      onTap: _onTap,
      focusNode: _focusNode,
    );
  }

  void _onTap() {
    final navigator = Navigator.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = navigator.overlay!.context.findRenderObject()! as RenderBox;
    final buttonRect = Rect.fromPoints(
      button.localToGlobal(Offset.zero, ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
    );
    navigator
        .push(
      _MFDTextEditRoute(
        delegate: _MFDTextEditDelegate(
          initialValue: _controller.value,
          decoration: widget.decoration ?? const InputDecoration(),
          staticItems: widget.items,
        ),
        buttonRect: buttonRect,
        themes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
        itemsSize: widget.itemHeight == null || widget.maxItemsShow == null ? null : widget.itemHeight! * widget.maxItemsShow!,
      ),
    )
        .then(
      (value) {
        if (value == null) {
          return;
        }
        if (value.value != null) {
          _controller.text = value.value!;
        }
      },
    );
    _focusNode.unfocus();
  }
}

class _MFDTextEditRoute extends PopupRoute<MFDTextEditPopupResult> {
  _MFDTextEditRoute({
    required this.delegate,
    required this.buttonRect,
    required this.themes,
    this.itemsSize,
  });

  final _MFDTextEditDelegate delegate;
  final Rect buttonRect;
  final CapturedThemes themes;
  final double? itemsSize;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return SafeArea(
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _MFDTextEditRouteLayout(
              buttonRect,
              itemsSize,
            ),
            child: themes.wrap(delegate),
          );
        },
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration();
}

class MFDTextEditPopupResult {
  MFDTextEditPopupResult(this.value);

  final String? value;
}

class _MFDTextEditDelegate extends StatefulWidget {
  const _MFDTextEditDelegate({
    Key? key,
    this.initialValue,
    this.decoration,
    this.staticItems,
  }) : super(key: key);

  final TextEditingValue? initialValue;
  final InputDecoration? decoration;
  final List<DropdownMenuItem<String>>? staticItems;

  @override
  _MFDTextEditDelegateState createState() => _MFDTextEditDelegateState();
}

class _MFDTextEditDelegateState extends State<_MFDTextEditDelegate> {
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController.fromValue(widget.initialValue);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      focusNode: _focusNode,
      controller: _controller,
      decoration: widget.decoration,
      onSubmitted: (value) => Navigator.of(context).pop(MFDTextEditPopupResult(value)),
    );
    if (widget.staticItems?.isEmpty ?? true) {
      return Material(
        type: MaterialType.card,
        elevation: 10,
        child: textField,
      );
    }
    final children = [
      for (final item in widget.staticItems!)
        InkWell(
          child: item,
          onTap: () {
            if (item.onTap != null) {
              item.onTap!();
            }
            Navigator.of(context).pop(MFDTextEditPopupResult(item.value));
          },
        )
    ];
    return Material(
      type: MaterialType.card,
      elevation: 10,
      child: Column(
        children: [
          textField,
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: children,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MFDTextEditRouteLayout extends SingleChildLayoutDelegate {
  _MFDTextEditRouteLayout(this.editRect, this.itemsSize);

  final Rect editRect;
  final double? itemsSize;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final maxHeight = constraints.maxHeight - editRect.top - _textEditBottomGap - editRect.height;
    final itemsHeight = itemsSize ?? constraints.maxHeight;
    return BoxConstraints(
      minWidth: editRect.width,
      maxWidth: editRect.width,
      minHeight: editRect.height,
      maxHeight: editRect.height + math.min(maxHeight, itemsHeight + _textEditBottomGap),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return editRect.topLeft;
  }

  @override
  bool shouldRelayout(_MFDTextEditRouteLayout oldDelegate) {
    return editRect != oldDelegate.editRect || itemsSize != oldDelegate.itemsSize;
  }
}

const _textEditBottomGap = 8.0;
