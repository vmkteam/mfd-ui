import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/main_page.dart';
import 'package:mfdui/components/settings.dart';
import 'package:mfdui/project/project.dart';

class MFDScaffold extends StatelessWidget {
  const MFDScaffold({Key? key, required this.body}) : super(key: key);

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          Widget? loader;
          if (state is ProjectLoadInProgress) {
            loader = const LinearProgressIndicator();
          }
          Widget? notification;
          if (state is ProjectLoadFailed) {
            notification = SizedBox(
              width: double.infinity,
              child: Material(
                elevation: 3,
                color: Theme.of(context).errorColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      state.err,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            );
          }
          return Column(
            children: [
              if (loader != null) loader,
              if (notification != null) notification,
              Expanded(
                child: body,
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoadSuccess) {
            Widget text = Text(state.project.name);
            if (state.filename != null) {
              text = Tooltip(message: state.filename!, child: text);
            }
            return Row(
              children: [
                text,
                const SizedBox(width: 16),
                SaveButton(),
                ScaffoldMenu(),
              ],
            );
          }
          return const Text('MFD UI');
        },
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      toolbarHeight: mfdToolbarHeight,
      actions: [
        Builder(
          builder: (context) => TextButton(
            child: const Icon(Icons.settings, color: Colors.white),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => Settings(),
              );
              final bloc = BlocProvider.of<ProjectBloc>(context);
              final state = bloc.state;
              if (state is ProjectLoadSuccess) {
                bloc.add(ProjectLoadCurrent());
              }
            },
          ),
        ),
      ],
    );
  }
}

class ScaffoldMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          _MenuButton(text: 'HOME', routeName: '/'),
          _MenuButton(text: 'Entities', routeName: '/xml'),
          _MenuButton(text: 'VT Entities', routeName: '/xmlvt'),
        ],
      ),
    );
  }
}

const mfdToolbarHeight = 56.0;

class _MenuButton extends StatelessWidget {
  const _MenuButton({Key? key, required this.text, required this.routeName}) : super(key: key);

  final String text;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: mfdToolbarHeight, minWidth: 80),
      child: TextButton(
        onPressed: () => Navigator.of(context).pushReplacementNamed(routeName),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class MFDDrawer extends StatelessWidget {
  const MFDDrawer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: child,
    );
  }
}
