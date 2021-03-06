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
          AttributesTable(editorBloc: editorBloc, entityName: state.entity.name),
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
                onSubmitted: (value) {
                  if (value != null) {
                    editorBloc.add(EntityTableChanged(value));
                  }
                },
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
                onSubmitted: (value) {
                  if (value != null) {
                    editorBloc.add(EntityNamespaceChanged(value));
                  }
                },
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
                  title: Text('Open VT Entity $title'),
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
