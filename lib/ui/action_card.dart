part of 'ui.dart';

class MFDActionCard extends StatelessWidget {
  const MFDActionCard({
    Key? key,
    this.title,
    this.actions,
    this.children,
    this.contentPadding,
  }) : super(key: key);

  final Widget? title;
  final List<Widget>? children;
  final List<Widget>? actions;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    Widget? titleWidget;
    if (title != null) {
      titleWidget = ListTile(
        title: DefaultTextStyle(
          style: Theme.of(context).textTheme.headline6!,
          child: title!,
        ),
        trailing: Navigator.of(context).canPop() ? const MFDCloseButton() : null,
      );
    }

    Widget? contentWidget;
    if (children != null) {
      contentWidget = Padding(
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: children!,
        ),
      );
    }
    Widget? actionsWidget;
    if (actions != null) {
      actionsWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions!,
      );
    }
    Widget dialogChild = IntrinsicWidth(
      stepWidth: 56.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (titleWidget != null) titleWidget,
            if (contentWidget != null) contentWidget,
            if (actionsWidget != null) actionsWidget,
          ],
        ),
      ),
    );

    return Card(
      child: dialogChild,
    );
  }
}
