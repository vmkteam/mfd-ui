import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/editor/attributes/attributes_table.dart';
import 'package:mfdui/editor/editor_bloc.dart';
import 'package:mfdui/editor/searches/searches_table.dart';

class EditorWidget extends StatefulWidget {
  @override
  _EditorWidgetState createState() => _EditorWidgetState();
}

class _EditorWidgetState extends State<EditorWidget> {
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
          title: Text(state.entityName),
          primary: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey.shade300,
          elevation: 1,
          pinned: true,
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
          primary: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey.shade300,
          elevation: 1,
          pinned: true,
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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(state.entity.name),
          primary: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey.shade300,
          elevation: 1,
          pinned: true,
        ),
        AttributesTable(editorBloc: editorBloc),
        const SliverToBoxAdapter(child: SizedBox(height: 56)),
        SearchesTable(editorBloc: editorBloc),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
