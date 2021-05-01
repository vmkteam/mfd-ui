part of 'ui.dart';

// Unfocuser resolves https://github.com/flutter/flutter/issues/32433
class Unfocuser extends StatelessWidget {
  const Unfocuser({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) {
        final rb = context.findRenderObject() as RenderBox;
        final result = BoxHitTestResult();
        rb.hitTest(result, position: e.position);

        for (final e in result.path) {
          if (e.target is RenderEditable) {
            return;
          }
        }

        final primaryFocus = FocusManager.instance.primaryFocus;

        if (primaryFocus?.context?.widget is EditableText) {
          primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
