import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/editor/attributes/attributes_table.dart';
import 'package:mfdui/editor/editor_bloc.dart';
import 'package:mfdui/editor/searches/searches_table.dart';
import 'package:mfdui/editor/table_autocomplete.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart';
import 'package:mfdui/ui/unfocuser.dart';

class EditorWidget extends StatefulWidget {
  @override
  _EditorWidgetState createState() => _EditorWidgetState();
}

class _EditorWidgetState extends State<EditorWidget> {
  @override
  Widget build(BuildContext context) {
    return Unfocuser(
      child: BlocBuilder<EditorBloc, EditorState>(
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
      ),
    );
  }

  Widget buildEntityLoader(BuildContext context, EditorEntityLoadInProgress state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(state.entityName),
          centerTitle: false,
          primary: false,
          automaticallyImplyLeading: false,
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.blueGrey.shade600,
        ),
        const SliverToBoxAdapter(child: LinearProgressIndicator()),
      ],
    );
  }

  Widget buildEntityLoadFailed(BuildContext context, EditorEntityLoadFailed state) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(state.entityName),
          centerTitle: false,
          primary: false,
          automaticallyImplyLeading: false,
          elevation: 0,
          pinned: true,
          backgroundColor: Colors.blueGrey.shade600,
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
          _EditorToolbar(title: state.entity.name),
          _MainParameters(editorBloc: editorBloc, state: state),
          AttributesTable(editorBloc: editorBloc),
          const SliverToBoxAdapter(child: SizedBox(height: 56)),
          SearchesTable(editorBloc: editorBloc),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
              width: 125,
              child: TableAutocomplete(
                tableName: state.entity.table,
                projectBloc: BlocProvider.of<ProjectBloc>(context),
                apiClient: RepositoryProvider.of<ApiClient>(context),
                onSubmitted: (value) => editorBloc.add(EntityTableChanged(value)),
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
  const _EditorToolbar({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title),
      centerTitle: false,
      primary: false,
      automaticallyImplyLeading: false,
      elevation: 0,
      pinned: true,
      backgroundColor: Colors.blueGrey.shade600,
    );
  }
}
