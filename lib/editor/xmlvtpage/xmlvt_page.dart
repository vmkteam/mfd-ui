import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/scaffold.dart';
import 'package:mfdui/editor/navigator.dart';
import 'package:mfdui/editor/xmlvtpage/editor_bloc.dart';
import 'package:mfdui/editor/xmlvtpage/editor_widget.dart';
import 'package:mfdui/editor/xmlvtpage/menu.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart';

class XMLVTPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    return BlocProvider(
      create: (context) {
        final bloc = EditorBloc(
          RepositoryProvider.of<ApiClient>(context),
          BlocProvider.of<ProjectBloc>(context),
        );
        if (args is MFDRouteSettings) {
          if (args.namespaceName != null && args.entityName != null) {
            bloc.add(EditorEntitySelected(args.namespaceName!, args.entityName!));
          }
        }
        return bloc;
      },
      lazy: false,
      child: MFDScaffold(
        body: Row(
          children: [
            Flexible(flex: 1, child: XMLVTMenu()),
            Expanded(flex: 5, child: XMLVTEditorWidget()),
          ],
        ),
      ),
    );
  }
}
