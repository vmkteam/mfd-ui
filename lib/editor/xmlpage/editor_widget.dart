import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/editor/attributes/attributes_table.dart';
import 'package:mfdui/editor/namespace_autocomplete.dart';
import 'package:mfdui/editor/navigator.dart';
import 'package:mfdui/editor/searches/searches_table.dart';
import 'package:mfdui/editor/table_autocomplete.dart';
import 'package:mfdui/editor/xmlpage/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart';
import 'package:mfdui/ui/ui.dart';

class XMLEditorWidget extends StatefulWidget {
  @override
  _XMLEditorWidgetState createState() => _XMLEditorWidgetState();
}

class _XMLEditorWidgetState extends State<XMLEditorWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        if (state is EditorInitial) {
          final rand = Random(DateTime.now().millisecondsSinceEpoch);
          return Column(
            children: [
              const SizedBox(width: 150, child: MFDTextEdit()),
              const MFDTextEdit(
                decorationOptions: TextEditDecorationOptions(maxItemsShow: 2),
                items: [
                  DropdownMenuItem(
                    value: 'aaa',
                    child: ListTile(
                      title: Text('aaa'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'bbb',
                    child: ListTile(
                      title: Text('bbb'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ccc',
                    child: ListTile(
                      title: Text('ccc'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: 250,
                  child: MFDTextEdit(
                    itemsLoader: (value) => Future.value(
                      List.generate(rand.nextInt(5), (index) => (rand.nextInt(100000) + 10000).toString()),
                    ),
                    itemBuilder: (context, value) => DropdownMenuItem(value: value, child: Text(value)),
                  )),
              SizedBox(
                  width: 250,
                  child: MFDTextEdit(
                    decorationOptions: const TextEditDecorationOptions(showDoneButton: true),
                    itemsLoader: (value) => Future.value(
                      List.generate(rand.nextInt(5), (index) => (rand.nextInt(100000) + 10000).toString()),
                    ),
                    itemBuilder: (context, value) => DropdownMenuItem(value: value, child: Text(value)),
                  )),
              SizedBox(
                  width: 245,
                  child: MFDTextEdit(
                    decoration: InputDecoration(labelText: 'default (submit)'),
                    decorationOptions: const TextEditDecorationOptions(showDoneButton: true),
                    itemsLoader: (value) => Future.value(
                      List.generate(10, (index) => (index * 10000).toString()),
                    ),
                    preload: true,
                    itemBuilder: (context, value) => DropdownMenuItem(value: value, child: Text(value)),
                  )),
              SizedBox(
                  width: 240,
                  child: MFDTextEdit(
                    decoration: InputDecoration(labelText: 'replate'),
                    decorationOptions: const TextEditDecorationOptions(
                      showDoneButton: true,
                      selectBehavior: MFDTextEditItemSelectBehavior.replace,
                    ),
                    itemsLoader: (value) => Future.value(
                      List.generate(10, (index) => (index * 10000).toString()),
                    ),
                    preload: true,
                    itemBuilder: (context, value) => DropdownMenuItem(value: value, child: Text(value)),
                  )),
              SizedBox(
                  width: 260,
                  child: MFDTextEdit(
                    decoration: InputDecoration(labelText: 'complete'),
                    decorationOptions: const TextEditDecorationOptions(
                      showDoneButton: true,
                      selectBehavior: MFDTextEditItemSelectBehavior.complete,
                    ),
                    itemsLoader: (value) => Future.value(
                      List.generate(10, (index) => (index * 10000).toString()),
                    ),
                    preload: true,
                    itemBuilder: (context, value) => DropdownMenuItem(value: value, child: Text(value)),
                  )),
            ],
          );
          return Container();
        }
        if (state is EditorEntityLoadInProgress) {
          return buildEntityLoader(context, state);
        }
        if (state is EditorEntityLoadFailed) {
          return buildEntityLoadFailed(context, state);
        }
        if (state is EditorEntityLoadSuccess) {
          return EntityView(
            state: state,
            editorBloc: BlocProvider.of<EditorBloc>(context),
          );
        }
        return Container();
      },
    );
  }

  Widget buildEntityLoader(BuildContext context, EditorEntityLoadInProgress state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(state.entityName, style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.black87)),
          centerTitle: false,
          primary: false,
          automaticallyImplyLeading: false,
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.blueGrey.shade100,
        ),
        const SliverToBoxAdapter(child: LinearProgressIndicator()),
      ],
    );
  }

  Widget buildEntityLoadFailed(BuildContext context, EditorEntityLoadFailed state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(state.entityName, style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.black87)),
          centerTitle: false,
          primary: false,
          automaticallyImplyLeading: false,
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.blueGrey.shade100,
        ),
        SliverFillRemaining(
          child: Center(child: Text(state.error)),
        ),
      ],
    );
  }
}

class EntityView extends StatelessWidget {
  const EntityView({Key? key, required this.state, required this.editorBloc}) : super(key: key);

  final EditorBloc editorBloc;
  final EditorEntityLoadSuccess state;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          _EditorToolbar(
            title: state.entity.name,
            entityName: state.entity.name,
            namespaceName: state.entity.namespace,
          ),
          _MainParameters(editorBloc: editorBloc, state: state),
          AttributesTable(editorBloc: editorBloc),
          const SliverToBoxAdapter(child: SizedBox(height: 56)),
          SearchesTable(editorBloc: editorBloc, attributes: state.entity.attributes),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: SizedBox(height: 250),
          ),
        ],
      ),
    );
  }
}

class _MainParameters extends StatelessWidget {
  const _MainParameters({Key? key, required this.state, required this.editorBloc}) : super(key: key);

  final EditorBloc editorBloc;
  final EditorEntityLoadSuccess state;

  @override
  Widget build(BuildContext context) {
    if (state is! EditorEntityLoadSuccess) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 4, top: 20, bottom: 38),
            child: SizedBox(
              width: 250,
              child: TableAutocomplete(
                tableName: state.entity.table,
                projectBloc: BlocProvider.of<ProjectBloc>(context),
                apiClient: RepositoryProvider.of<ApiClient>(context),
                onSubmitted: (value) => editorBloc.add(EntityTableChanged(value)),
              ),
            ),
          ),
          // when updating namespace mfd duplicates records
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 4, top: 20, bottom: 38),
            child: SizedBox(
              width: 250,
              child: NamespaceAutocomplete(
                initialValue: state.entity.namespace,
                onSubmitted: (value) => editorBloc.add(EntityNamespaceChanged(value)),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _EditorToolbar extends StatelessWidget {
  const _EditorToolbar({Key? key, this.title = '', this.entityName, this.namespaceName}) : super(key: key);

  final String title;
  final String? entityName;
  final String? namespaceName;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.black87)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
                width: 250,
                child: ListTile(
                  title: Text('XML-VT $title'),
                  trailing: const Icon(Icons.forward),
                  onTap: () => Navigator.of(context).pushReplacementNamed('/xmlvt',
                      arguments: MFDRouteSettings(
                        entityName: entityName,
                        namespaceName: namespaceName,
                      )),
                )),
          ),
        ],
      ),
      centerTitle: false,
      primary: false,
      automaticallyImplyLeading: false,
      elevation: 0,
      pinned: true,
      backgroundColor: Colors.blueGrey.shade100,
    );
  }
}
