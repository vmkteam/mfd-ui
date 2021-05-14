import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/scaffold.dart';
import 'package:mfdui/editor/xmlvtpage/editor_bloc.dart';
import 'package:mfdui/editor/xmlvtpage/editor_widget.dart';
import 'package:mfdui/editor/xmlvtpage/menu.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart';

class XMLVTPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditorBloc(
        RepositoryProvider.of<ApiClient>(context),
        BlocProvider.of<ProjectBloc>(context),
      ),
      lazy: false,
      child: MFDScaffold(
        body: Row(
          children: [
            XMLVTMenu(),
            Expanded(child: XMLVTEditorWidget()),
          ],
        ),
      ),
    );
  }
}
