import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/ui/ui.dart';

class OpenProjectDialog extends StatelessWidget {
  const OpenProjectDialog({
    Key? key,
    this.path,
    this.conn,
    required this.projectBloc,
  }) : super(key: key);

  final String? path;
  final String? conn;
  final ProjectBloc projectBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: projectBloc,
      child: Dialog(
        child: Unfocuser(
          child: OpenProjectCard(
            path: path,
            conn: conn,
          ),
        ),
      ),
    );
  }
}

class OpenProjectCard extends StatefulWidget {
  const OpenProjectCard({Key? key, this.path, this.conn}) : super(key: key);

  final String? path;
  final String? conn;

  @override
  _OpenProjectCardState createState() => _OpenProjectCardState();
}

class _OpenProjectCardState extends State<OpenProjectCard> {
  late TextEditingController _pathTextController;
  late TextEditingController _connTextController;

  @override
  void initState() {
    _pathTextController = TextEditingController(text: widget.path);
    _connTextController = TextEditingController(text: widget.conn ?? DefaultPgConnection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MFDActionCard(
      title: const Text('Open project'),
      children: [
        BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, state) {
            if (state is ProjectLoadFailed) {
              return Card(
                margin: EdgeInsets.only(bottom: 30),
                color: Theme.of(context).errorColor,
                child: ListTile(
                  title: Text(state.err),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        TextField(
          controller: _pathTextController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Path',
            helperText: 'Absolute path to .mfd file',
          ),
        ),
        const SizedBox(height: 30),
        _ConnectionString(
          controller: _connTextController,
        ),
      ],
      actions: [
        const Spacer(flex: 2),
        Expanded(
          child: SizedBox(
            height: 42,
            child: BlocConsumer<ProjectBloc, ProjectState>(
              listener: (context, state) {
                if (state is ProjectLoadSuccess) {
                  Navigator.of(context).pop(OpenProjectResult(
                    _pathTextController.text,
                    _connTextController.text,
                  ));
                }
              },
              builder: (context, state) {
                if (state is ProjectLoadInProgress) {
                  return const ElevatedButton(
                    onPressed: null,
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<ProjectBloc>(context).add(ProjectLoadStarted(
                      _pathTextController.text,
                      _connTextController.text,
                    ));
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class OpenProjectResult {
  OpenProjectResult(this.filepath, this.pgConnection);

  final String filepath;
  final String pgConnection;
}

class _ConnectionString extends StatelessWidget {
  _ConnectionString({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  final _hostController = TextEditingController(text: 'localhost');
  final _portController = TextEditingController(text: '5432');
  final _userController = TextEditingController(text: 'postgres');
  final _passwordController = TextEditingController(text: 'postgres');
  final _databaseController = TextEditingController(text: 'postgres');

  @override
  Widget build(BuildContext context) {
    final hostWidget = TextFormField(
      controller: _hostController,
      onChanged: (value) => _updateResultUrl(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Host',
      ),
    );
    final portWidget = TextFormField(
      controller: _portController,
      onChanged: (value) => _updateResultUrl(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Port',
      ),
    );
    final userWidget = TextFormField(
      controller: _userController,
      onChanged: (value) => _updateResultUrl(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'User',
      ),
    );
    final passwordWidget = TextFormField(
      controller: _passwordController,
      onChanged: (value) => _updateResultUrl(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
      ),
    );
    final databaseWidget = TextFormField(
      controller: _databaseController,
      onChanged: (value) => _updateResultUrl(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Database',
      ),
    );
    final urlWidget = TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'URL',
      ),
    );
    const linesPadding = EdgeInsets.symmetric(vertical: 7);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 550),
      child: Column(
        children: [
          const ListTile(title: Text('Database connection')),
          Row(
            children: [
              Expanded(
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.only(bottom: linesPadding.bottom, top: linesPadding.top),
                  child: hostWidget,
                ),
              ),
              Expanded(child: Text(':', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline5)),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: linesPadding,
                  child: portWidget,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: userWidget,
                  padding: linesPadding,
                ),
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: passwordWidget,
                  padding: linesPadding,
                ),
              ),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  child: databaseWidget,
                  padding: linesPadding,
                ),
              ),
              const Spacer(),
            ],
          ),
          Padding(
            child: urlWidget,
            padding: linesPadding,
          ),
        ],
      ),
    );
  }

  void _updateResultUrl() {
    final host = _hostController.text;
    final port = _portController.text;
    final user = _userController.text;
    final password = _passwordController.text;
    final database = _databaseController.text;
    controller.text = 'postgres://$user:$password@$host:$port/$database?sslmode=disable';
  }
}
