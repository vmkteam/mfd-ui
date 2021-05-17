import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/checkbox.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/editor/xmlvtpage/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/ui/ui.dart';

class XMLVTEditorWidget extends StatefulWidget {
  @override
  _XMLVTEditorWidgetState createState() => _XMLVTEditorWidgetState();
}

class _XMLVTEditorWidgetState extends State<XMLVTEditorWidget> {
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
          VTTemplateTable(editorBloc: editorBloc),
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
            child: Row(
              children: [
                Text('VT Mode:', style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(width: 12),
                SizedBox(
                  width: 100,
                  child: VTModeDropdown(
                    currentValue: state.entity.mode,
                    onSubmitted: (value) => editorBloc.add(EntityModeChanged(value!)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 4, top: 20, bottom: 38),
            child: SizedBox(
              width: 250,
              child: MFDAutocomplete(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Terminal path',
                ),
                initialValue: state.entity.terminalPath,
                optionsLoader: null,
                onSubmitted: (value) => editorBloc.add(EntityTerminalPathChanged(value)),
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

class VTModeDropdown extends StatelessWidget {
  const VTModeDropdown({Key? key, required this.onSubmitted, this.currentValue}) : super(key: key);

  final ValueChanged<String?> onSubmitted;
  final String? currentValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentValue,
        onChanged: onSubmitted,
        items: menuItems(context),
      ),
    );
  }

  List<DropdownMenuItem<String>> menuItems(BuildContext context) {
    return [
      oneItem(context, VTEntityMode.None),
      oneItem(context, VTEntityMode.Read),
      oneItem(context, VTEntityMode.ReadOnly),
      oneItem(context, VTEntityMode.Full),
    ];
  }

  DropdownMenuItem<String> oneItem(BuildContext context, VTEntityMode mode) {
    return DropdownMenuItem(
      value: describeEnum(mode),
      child: Text(describeEnum(mode)),
    );
  }
}

enum VTEntityMode { None, Read, ReadOnly, Full }

class AttributesTable extends StatelessWidget {
  AttributesTable({Key? key, required this.editorBloc}) : super(key: key);

  final EditorBloc editorBloc;

  List<TableColumn<VTAttribute>> get columns {
    return [
      TableColumn(
        header: const Header(label: 'Name'),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.name,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(name: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(label: 'AttrName'),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.attrName,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(attrName: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(label: 'Required'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.required,
              onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(required: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Summary'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.summary,
              onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(summary: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Search'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.search,
              onChanged: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(search: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Search Name'),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.searchName,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(searchName: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Validate'),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.validate,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(validate: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(),
        builder: (context, index, row) {
          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).errorColor),
                tooltip: 'Remove attribute',
                onPressed: () => editorBloc.add(EntityAttributeDeleted(index)),
                splashRadius: 19,
              )
            ],
          );
        },
        footerBuilder: (context) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                tooltip: 'Add attribute',
                onPressed: () => editorBloc.add(EntityAttributeAdded()),
                splashRadius: 19,
              )
            ],
          );
        },
      ),
    ];
  }

  final ScrollController scrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ListTile(title: Text('Attributes', style: Theme.of(context).textTheme.headline5)),
          Center(
            child: Scrollbar(
              controller: scrollController1,
              child: SingleChildScrollView(
                controller: scrollController1,
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<EditorBloc, EditorState>(
                  builder: (context, state) {
                    if (state is EditorEntityLoadSuccess) {
                      return CustomTable(columns: columns, rows: state.entity.attributes);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VTTemplateTable extends StatelessWidget {
  VTTemplateTable({Key? key, required this.editorBloc}) : super(key: key);

  final EditorBloc editorBloc;

  List<TableColumn<VTTemplateAttribute>> get columns {
    return [
      TableColumn(
        header: const Header(label: 'Name'),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.name,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(name: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(label: 'AttrName'),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.vtAttrName,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(vtAttrName: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(label: 'Search'),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.search,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(search: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(label: 'Form'),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.form,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(form: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(label: 'List'),
        builder: (context, index, row) {
          return Center(
            child: CheckboxStateful(
              value: row.list,
              onChanged: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(list: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'FK Opts'),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.fkOpts,
            optionsLoader: null,
            onSubmitted: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(fkOpts: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(),
        builder: (context, index, row) {
          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).errorColor),
                tooltip: 'Remove template',
                onPressed: () => editorBloc.add(EntityTemplateDeleted(index)),
                splashRadius: 19,
              )
            ],
          );
        },
        footerBuilder: (context) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                tooltip: 'Add template',
                onPressed: () => editorBloc.add(EntityTemplateAdded()),
                splashRadius: 19,
              )
            ],
          );
        },
      ),
    ];
  }

  final ScrollController scrollController1 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          ListTile(title: Text('Template Attributes', style: Theme.of(context).textTheme.headline5)),
          Center(
            child: Scrollbar(
              controller: scrollController1,
              child: SingleChildScrollView(
                controller: scrollController1,
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<EditorBloc, EditorState>(
                  builder: (context, state) {
                    if (state is EditorEntityLoadSuccess) {
                      return CustomTable(columns: columns, rows: state.entity.templates);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
