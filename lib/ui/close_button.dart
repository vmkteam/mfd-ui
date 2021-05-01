part of 'ui.dart';

@immutable
class MFDCloseButton extends StatelessWidget {
  const MFDCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      splashRadius: 22,
      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: () {
        Navigator.maybePop(context);
      },
    );
  }
}
