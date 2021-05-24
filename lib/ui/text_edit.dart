part of 'ui.dart';

class MFDTextEdit extends StatefulWidget {
  const MFDTextEdit({
    Key? key,
    this.controller,
    this.decoration,
    this.focusNode,
    this.items,
    this.itemsLoader,
    this.itemBuilder,
    this.preload = false,
    this.decorationOptions = const TextEditDecorationOptions(),
  })  : assert(
          // xor
          (itemBuilder == null && itemsLoader == null) || (itemBuilder != null && itemsLoader != null),
          'when itemsLoader is provided itemBuilder is required and vice versa',
        ),
        assert(
          itemsLoader != null && items == null || itemsLoader == null,
          'when itemsLoader is provided, items should be null',
        ),
        super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final InputDecoration? decoration;
  final TextEditDecorationOptions decorationOptions;

  final List<DropdownMenuItem<String>>? items;

  final ItemsLoader<String>? itemsLoader;
  final MFDTextEditItemBuilder<String>? itemBuilder;
  final bool preload;

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
      decoration: _effectiveDecoration(context),
      controller: _controller,
      onTap: _onTap,
      focusNode: _focusNode,
    );
  }

  InputDecoration _effectiveDecoration(BuildContext context) {
    InputDecoration result = widget.decoration ?? const InputDecoration();
    if (widget.decorationOptions.showEditButton) {
      result = result.copyWith(suffixIcon: const Tooltip(message: 'Edit', child: Icon(Icons.edit)));
    }
    return result;
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
          decoration: widget.decoration,
          decorationOptions: widget.decorationOptions,
          staticItems: widget.items,
          itemBuilder: widget.itemBuilder,
          itemsLoader: widget.itemsLoader,
          preload: widget.preload,
        ),
        buttonRect: buttonRect,
        themes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
        itemsSize: widget.decorationOptions.itemHeight == null || widget.decorationOptions.maxItemsShow == null
            ? null
            : widget.decorationOptions.itemHeight! * widget.decorationOptions.maxItemsShow!,
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

typedef ItemsLoader<T> = Future<Iterable<T>?> Function(TextEditingValue? value);
typedef MFDTextEditItemBuilder<T> = DropdownMenuItem<T> Function(BuildContext context, T value);

class TextEditDecorationOptions {
  const TextEditDecorationOptions({
    this.showEditButton = false,
    this.showDoneButton = true,
    this.maxItemsShow = 5,
    this.itemHeight = 56,
    this.selectBehavior = MFDTextEditItemSelectBehavior.submit,
  });

  final bool showEditButton;
  final bool showDoneButton;
  final int? maxItemsShow;
  final double? itemHeight;
  // [selectBehavior] определяет поведение оверлея по нажатию на одну из опций.
  final MFDTextEditItemSelectBehavior selectBehavior;
}

enum MFDTextEditItemSelectBehavior {
  // Делает submit и закрывает оверлей.
  submit,
  // Изменяет текущее значение в поле ввода и фокусируется на вводе, но не закрывает оверлей.
  // Для закрытия нужно использовать кнопку Submit или Enter на клавиатуре.
  replace,
  // Добавляет выбранное значение в поле ввода и фокусируется на вводе, но не закрывает оверлей.
  // Для закрытия нужно использовать кнопку Submit или Enter на клавиатуре.
  complete,
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
    this.itemsLoader,
    this.itemBuilder,
    this.preload = false,
    this.decorationOptions = const TextEditDecorationOptions(),
  }) : super(key: key);

  final TextEditingValue? initialValue;
  final InputDecoration? decoration;
  final TextEditDecorationOptions decorationOptions;

  final List<DropdownMenuItem<String>>? staticItems;
  final ItemsLoader<String>? itemsLoader;
  final MFDTextEditItemBuilder<String>? itemBuilder;
  final bool preload;

  @override
  _MFDTextEditDelegateState createState() => _MFDTextEditDelegateState();
}

class _MFDTextEditDelegateState extends State<_MFDTextEditDelegate> {
  final FocusNode _focusNode = FocusNode(onKey: _handleNavigation);
  late final TextEditingController _controller;
  final ScrollController _scrollController = ScrollController();

  List<String> options = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController.fromValue(widget.initialValue);
    _focusNode.requestFocus();
    _controller.addListener(_onTextChanged);
    if (widget.preload) {
      _updateOptions(_controller.value);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textField = Material(
      type: MaterialType.card,
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        decoration: _effectivePopupDecoration(context),
        onSubmitted: (value) => _submitResult(context, value),
      ),
    );
    final itemWidgets = getItems(context);
    if (itemWidgets == null) {
      return textField;
    }
    Widget? optionsWidget;
    if (itemWidgets.isNotEmpty) {
      final children = [
        for (final item in itemWidgets)
          InkWell(
            child: item,
            onTap: () {
              if (item.onTap != null) {
                item.onTap!();
              }
              _selectResult(context, item.value);
            },
          )
      ];
      optionsWidget = Expanded(
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Material(
              type: MaterialType.card,
              elevation: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      );
    }
    return FocusScope(
      onKey: _handleNavigation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          textField,
          if (isLoading) const LinearProgressIndicator(),
          if (optionsWidget != null) optionsWidget,
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>>? getItems(BuildContext context) {
    if (widget.staticItems == null && widget.itemBuilder == null) {
      return null;
    }
    if (widget.staticItems?.isNotEmpty ?? false) {
      return widget.staticItems!;
    }
    return List<DropdownMenuItem<String>>.generate(options.length, (index) => widget.itemBuilder!(context, options[index]));
  }

  void _onTextChanged() {
    _updateOptions(_controller.value);
  }

  Future<void> _updateOptions(TextEditingValue? value) async {
    if (widget.itemsLoader != null) {
      setState(() {
        isLoading = true;
      });
      final result = await widget.itemsLoader!(value);
      setState(() {
        isLoading = false;
        options = result?.toList() ?? [];
      });
    }
  }

  InputDecoration _effectivePopupDecoration(BuildContext context) {
    InputDecoration result = widget.decoration ?? const InputDecoration();
    if (widget.decorationOptions.showDoneButton) {
      result = result.copyWith(
        suffixIcon: IconButton(
          focusNode: FocusNode(canRequestFocus: false, descendantsAreFocusable: false, skipTraversal: true),
          onPressed: () => _submitResult(context, _controller.text),
          icon: const Icon(Icons.done),
          tooltip: 'Submit',
          splashRadius: 20,
        ),
      );
    }
    return result;
  }

  void _submitResult(BuildContext context, String? value) {
    Navigator.of(context).pop(MFDTextEditPopupResult(value));
  }

  void _selectResult(BuildContext context, String? value) {
    switch (widget.decorationOptions.selectBehavior) {
      case MFDTextEditItemSelectBehavior.submit:
        Navigator.of(context).pop(MFDTextEditPopupResult(value));
        return;
      case MFDTextEditItemSelectBehavior.replace:
        _controller.text = value ?? '';
        _focusNode.requestFocus();
        return;
      case MFDTextEditItemSelectBehavior.complete:
        if (value != null) {
          _controller.text += value;
          _focusNode.requestFocus();
        }
        break;
    }
  }

  static dynamic _handleNavigation(FocusNode node, RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      node.previousFocus();
      return KeyEventResult.skipRemainingHandlers;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      node.nextFocus();
      return KeyEventResult.skipRemainingHandlers;
    }
    return KeyEventResult.ignored;
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
