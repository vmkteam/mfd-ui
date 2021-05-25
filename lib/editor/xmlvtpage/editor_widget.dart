import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/checkbox.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/editor/navigator.dart';
import 'package:mfdui/editor/xmlvtpage/editor_bloc.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/public_repo.dart';
import 'package:mfdui/ui/ui.dart';

class XMLVTEditorWidget extends StatefulWidget {
  @override
  _XMLVTEditorWidgetState createState() => _XMLVTEditorWidgetState();
}

class _XMLVTEditorWidgetState extends State<XMLVTEditorWidget> {
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
            title: state.vtentity.name,
            entityName: state.vtentity.name,
            namespaceName: state.vtentity.namespace,
          ),
          _MainParameters(editorBloc: editorBloc, state: state),
          AttributesTable(editorBloc: editorBloc, state: state),
          const SliverToBoxAdapter(child: SizedBox(height: 56)),
          VTTemplateTable(editorBloc: editorBloc, state: state),
          const SliverFillRemaining(),
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
                Card(
                  child: SizedBox(
                    width: 225,
                    child: VTModeDropdown(
                      currentValue: state.vtentity.mode,
                      onSubmitted: (value) => editorBloc.add(EntityModeChanged(value!)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.zero, //const EdgeInsets.only(left: 20, right: 4, top: 20, bottom: 38),
            child: SizedBox(
              width: 250,
              child: MFDAutocomplete(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Terminal path',
                  helperText: 'e.g. path/to/entity',
                ),
                initialValue: state.vtentity.terminalPath,
                optionsLoader: null,
                onSubmitted: (value) => editorBloc.add(EntityTerminalPathChanged(value)),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'^/')),
                ],
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
                  title: Text('Open Entity $title'),
                  trailing: const Icon(Icons.forward),
                  onTap: () => Navigator.of(context).pushReplacementNamed('/xml',
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
        selectedItemBuilder: (context) {
          return VTEntityMode.values.map<Widget>((VTEntityMode item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(child: Text(describeEnum(item))),
            );
          }).toList();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> menuItems(BuildContext context) {
    return [
      oneItem(context, VTEntityMode.None),
      oneItem(context, VTEntityMode.ReadOnly),
      oneItem(context, VTEntityMode.ReadOnlyWithTemplates),
      oneItem(context, VTEntityMode.Full),
    ];
  }

  DropdownMenuItem<String> oneItem(BuildContext context, VTEntityMode mode) {
    final mainText = describeEnum(mode);
    final helpText = helpByMode(mode) ?? '';
    final subtitleStyle = Theme.of(context).textTheme.caption;
    return DropdownMenuItem(
      value: describeEnum(mode),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mainText),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Text(
                helpText,
                style: subtitleStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? helpByMode(VTEntityMode mode) {
    switch (mode) {
      case VTEntityMode.None:
        return 'Do not generate any files';
      case VTEntityMode.ReadOnly:
        return 'Generates backend files only for read-only operations';
      case VTEntityMode.ReadOnlyWithTemplates:
        return 'Allows to show lists of entities, but disallow add or update';
      case VTEntityMode.Full:
        return 'Generate files for all CRUD operations';
    }
    return null;
  }
}

enum VTEntityMode { None, ReadOnly, ReadOnlyWithTemplates, Full }

class AttributesTable extends StatelessWidget {
  AttributesTable({Key? key, required this.editorBloc, required this.state}) : super(key: key);

  final EditorBloc editorBloc;
  final EditorEntityLoadSuccess state;

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
        header: const Header(
          label: 'AttrName',
          tooltip: 'One of model attributes',
        ),
        builder: (context, index, row) {
          final name = MFDAutocomplete(
            initialValue: row.attrName,
            optionsLoader: (query) {
              return Future.value(state.entity.attributes.map((e) => e.name));
            },
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(attrName: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(
          label: 'Required',
          tooltip: 'Indicates that this parameter should not be null in add or update methods.',
        ),
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
        header: const Header(
          label: 'Summary',
          tooltip: 'Parameter would be represented in Summary model, that is used in lists.',
        ),
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
        header: const Header(
          label: 'Search',
          tooltip: 'Parameter would be represented in Search model.',
        ),
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
        header: const Header(
          label: 'Search Name',
          tooltip: 'Linked Search from xml model.',
        ),
        builder: (context, index, row) {
          return MFDAutocomplete(
            initialValue: row.searchName,
            optionsLoader: (query) {
              final attrs = state.entity.attributes.map((e) => e.name);
              final searches = state.entity.searches.map((e) => e.name);
              return Future.value([...attrs, ...searches]);
            },
            onSubmitted: (value) => editorBloc.add(EntityAttributeChanged(index, row.copyWith(searchName: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Validate rule'),
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
          ListTile(
            title: Text('VT Attributes', style: Theme.of(context).textTheme.headline5),
          ),
          Center(
            child: Scrollbar(
              controller: scrollController1,
              child: SingleChildScrollView(
                controller: scrollController1,
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<EditorBloc, EditorState>(
                  builder: (context, state) {
                    if (state is EditorEntityLoadSuccess) {
                      return CustomTable(columns: columns, rows: state.vtentity.attributes);
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
  VTTemplateTable({Key? key, required this.editorBloc, required this.state}) : super(key: key);

  final EditorBloc editorBloc;
  final EditorEntityLoadSuccess state;

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
            optionsLoader: (query) => Future.value(state.vtentity.attributes.map((e) => e.name)),
            onSubmitted: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(vtAttrName: value))),
          );
          return name;
        },
      ),
      TableColumn(
        header: const Header(label: 'Search'),
        builder: (context, index, row) {
          return HTMLTypeAutocomplete(
            value: row.search,
            onSubmitted: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(search: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Form'),
        builder: (context, index, row) {
          return HTMLTypeAutocomplete(
            value: row.form,
            onSubmitted: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(form: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'List'),
        builder: (context, index, row) {
          bool hasSummary = false;
          try {
            final connectedAttr = state.vtentity.attributes.firstWhere((element) => element.name == row.vtAttrName);
            hasSummary = connectedAttr.summary;
          } on StateError {
            // ignore
          }
          Widget checkbox = CheckboxStateful(
            value: row.list,
            activeColor: !hasSummary && row.list ? Colors.orange : null,
            onChanged: (value) => editorBloc.add(EntityTemplateChanged(index, row.copyWith(list: value))),
          );
          if (!hasSummary && row.list) {
            checkbox = Tooltip(message: 'Attribute not in Summary model', child: checkbox);
          }
          return Center(
            child: checkbox,
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
                      return CustomTable(columns: columns, rows: state.vtentity.templates);
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

class HTMLTypeAutocomplete extends StatelessWidget {
  const HTMLTypeAutocomplete({
    Key? key,
    required this.value,
    required this.onSubmitted,
  }) : super(key: key);

  final String value;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.caption!.copyWith(fontFamily: 'FiraCode');
    return _DropdownBuilder<String>(
      value: value,
      onChanged: (value) => onSubmitted(value!),
      itemsLoader: () async {
        return RepositoryProvider.of<PublicRepo>(context).htmlTypes('').then((value) => value.toList());
      },
      itemBuilder: (value) {
        final enumVal = HTMLType.values.firstWhere((element) => describeEnum(element) == value, orElse: () => HTMLType.HTML_UNKNOWN);
        final enumText = _htmlTypeDisplayText(enumVal);
        String mainText = value;
        if (mainText.startsWith('HTML_')) {
          mainText = mainText.substring('HTML_'.length);
        }
        final helpText = enumText ?? '$value (unknown)';
        return DropdownMenuItem<String>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mainText),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Text(helpText, style: subtitleStyle),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _htmlTypeDisplayText(HTMLType enumVal) {
    switch (enumVal) {
      case HTMLType.HTML_UNKNOWN:
        return '';
      case HTMLType.HTML_NONE:
        return 'hidden';
      case HTMLType.HTML_INPUT:
        return '<v-text-field>';
      case HTMLType.HTML_TEXT:
        return '<v-textarea>';
      case HTMLType.HTML_PASSWORD:
        return '<v-text-field type="password">';
      case HTMLType.HTML_EDITOR:
        return '<vt-tinymce-editor>';
      case HTMLType.HTML_CHECKBOX:
        return '<v-checkbox>';
      case HTMLType.HTML_DATETIME:
        return '<vt-datetime-picker>';
      case HTMLType.HTML_DATE:
        return '<vt-date-picker>';
      case HTMLType.HTML_TIME:
        return '<vt-time-picker>';
      case HTMLType.HTML_FILE:
        return '<vt-vfs-file-input>';
      case HTMLType.HTML_IMAGE:
        return '<vt-vfs-image-input>';
      case HTMLType.HTML_SELECT:
        // TODO: Handle this case.
        break;
    }
  }
}

enum HTMLType {
  HTML_UNKNOWN,
  HTML_NONE,
  HTML_INPUT,
  HTML_TEXT,
  HTML_PASSWORD,
  HTML_EDITOR,
  HTML_CHECKBOX,
  HTML_DATETIME,
  HTML_DATE,
  HTML_TIME,
  HTML_FILE,
  HTML_IMAGE,
  HTML_SELECT,
}

class _DropdownBuilder<T> extends StatefulWidget {
  const _DropdownBuilder({Key? key, required this.itemsLoader, this.onChanged, this.value, required this.itemBuilder}) : super(key: key);

  final _ItemsLoader<T> itemsLoader;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final _ItemBuilder<T> itemBuilder;

  @override
  __DropdownBuilderState<T> createState() => __DropdownBuilderState<T>();
}

class __DropdownBuilderState<T> extends State<_DropdownBuilder<T>> {
  List<T>? items;

  @override
  void initState() {
    if (widget.value != null) {
      items = [widget.value!];
    }
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: widget.value,
      items: items?.map(widget.itemBuilder).toList(growable: false),
      onChanged: widget.onChanged,
    );
  }

  Future<void> loadItems() async {
    final result = await widget.itemsLoader();
    setState(() {
      items = result;
    });
  }
}

typedef _ItemsLoader<T> = Future<List<T>?> Function();
typedef _ItemBuilder<T> = DropdownMenuItem<T> Function(T);
