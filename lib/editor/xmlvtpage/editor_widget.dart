import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mfdui/components/checkbox.dart';
import 'package:mfdui/components/table.dart';
import 'package:mfdui/editor/navigator.dart';
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
      child: ListView(
        children: [
          _EditorToolbar(
            title: state.vtentity.name,
            entityName: state.vtentity.name,
            namespaceName: state.vtentity.namespace,
          ),
          _MainParameters(editorBloc: editorBloc, state: state),
          AttributesTable(editorBloc: editorBloc, state: state),
          const SizedBox(height: 56),
          VTTemplateTable(editorBloc: editorBloc, state: state),
          const SizedBox(height: 400),
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
      return const SizedBox.shrink();
    }
    return Row(
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
            child: MFDTextEdit(
              decoration: const InputDecoration(
                labelText: 'Terminal path',
                helperText: 'e.g. path/to/entity',
              ),
              decorationOptions: const TextEditDecorationOptions(showEditButton: true),
              style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
              controller: TextEditingController(text: state.vtentity.terminalPath),
              onSubmitted: (value) {
                if (value != null) {
                  editorBloc.add(EntityTerminalPathChanged(value));
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'^/')),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
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
    return AppBar(
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

class AttributesTable extends StatefulWidget {
  const AttributesTable({Key? key, required this.editorBloc, required this.state}) : super(key: key);

  final EditorBloc editorBloc;
  final EditorEntityLoadSuccess state;

  @override
  _AttributesTableState createState() => _AttributesTableState();
}

class _AttributesTableState extends State<AttributesTable> with AutomaticKeepAliveClientMixin {
  List<TableColumn<VTAttribute>> get columns {
    return [
      TableColumn(
        header: const Header(label: 'Name'),
        builder: (context, index, row) {
          return MFDTextEdit(
            controller: TextEditingController(text: row.name),
            decorationOptions: const TextEditDecorationOptions(hideUnfocusedBorder: true),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode', fontWeight: FontWeight.bold),
            onSubmitted: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(name: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(child: SizedBox()),
        builder: (context, rowIndex, row) => const VerticalDivider(),
      ),
      TableColumn(
        header: const Header(
          label: 'Entity Attribute',
          tooltip: 'One of entity attributes',
        ),
        builder: (context, index, row) {
          return MFDTextEdit<MFDLoadResult>(
            controller: TextEditingController(text: row.attrName),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
            decorationOptions: const TextEditDecorationOptions(hideUnfocusedBorder: true),
            itemsLoader: (query) {
              final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
              final arr = widget.state.entity.attributes.map((e) => e.name).toList();
              arr.sort(_sortByPrefix(precursor.toLowerCase()));
              return Future.value(arr.map((e) => MFDLoadResult(e)).toList());
            },
            itemBuilder: (context, query, option) => MFDSelectItem(value: option.value, child: Text(option.value ?? '')),
            preload: true,
            onSubmitted: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(attrName: value))),
          );
        },
      ),
      TableColumn(
        header: Header(
          child: RotatedBox(
            quarterTurns: -1,
            child: Text('Filters', style: Theme.of(context).textTheme.caption),
          ),
        ),
        builder: (context, rowIndex, row) => const VerticalDivider(),
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
              onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(search: value))),
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
          return MFDTextEdit<_SearchAutocompleteValue>(
            controller: TextEditingController(text: row.searchName),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
            decorationOptions: const TextEditDecorationOptions(
              hideUnfocusedBorder: true,
              showClearButton: true,
              minWidth: 260,
            ),
            itemsLoader: (query) {
              var precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
              precursor = precursor.toLowerCase();

              final attributesList = widget.state.entity.attributes.map((e) => e.name).toList();
              attributesList.sort(_sortByPrefix(precursor));
              final searchesList = widget.state.entity.searches.map((e) => e.name).toList();
              searchesList.sort(_sortByPrefix(precursor));

              final attrs = attributesList.map(
                (e) => _SearchAutocompleteValue(e, _SearchAutocompleteValueType.Attribute),
              );
              final searches = searchesList.map(
                (e) => _SearchAutocompleteValue(e, _SearchAutocompleteValueType.Search),
              );
              return Future.value([...attrs, ...searches]);
            },
            itemBuilder: (context, query, option) => MFDSelectItem(
              value: option.value,
              child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  horizontalTitleGap: 0,
                  title: Text(option.value ?? ''),
                  trailing: option.type == _SearchAutocompleteValueType.Search
                      ? const Icon(
                          Icons.search,
                          size: 15,
                        )
                      : null),
            ),
            preload: true,
            onSubmitted: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(searchName: value))),
          );
        },
      ),
      TableColumn(
        header: Header(
          child: RotatedBox(
            quarterTurns: -1,
            child: Text('List', style: Theme.of(context).textTheme.caption),
          ),
        ),
        builder: (context, rowIndex, row) => const VerticalDivider(),
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
              onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(summary: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: Header(
          child: RotatedBox(
            quarterTurns: -1,
            child: Text('Form', style: Theme.of(context).textTheme.caption),
          ),
        ),
        builder: (context, rowIndex, row) => const VerticalDivider(),
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
              onChanged: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(required: value))),
            ),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'Validate rule'),
        builder: (context, index, row) {
          return MFDTextEdit(
            controller: TextEditingController(text: row.validate),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
            decorationOptions: const TextEditDecorationOptions(hideUnfocusedBorder: true),
            onSubmitted: (value) => widget.editorBloc.add(EntityAttributeChanged(index, row.copyWith(validate: value))),
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
                onPressed: () => widget.editorBloc.add(EntityAttributeDeleted(index)),
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
                onPressed: () => widget.editorBloc.add(EntityAttributeAdded()),
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
    super.build(context);
    return Column(
      children: [
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SearchAutocompleteValue extends MFDLoadResult {
  _SearchAutocompleteValue(String? value, this.type) : super(value);
  final _SearchAutocompleteValueType type;
}

enum _SearchAutocompleteValueType {
  Attribute,
  Search,
}

class VTTemplateTable extends StatefulWidget {
  const VTTemplateTable({Key? key, required this.editorBloc, required this.state}) : super(key: key);

  final EditorBloc editorBloc;
  final EditorEntityLoadSuccess state;

  @override
  _VTTemplateTableState createState() => _VTTemplateTableState();
}

class _VTTemplateTableState extends State<VTTemplateTable> with AutomaticKeepAliveClientMixin {
  List<TableColumn<VTTemplateAttribute>> get columns {
    return [
      TableColumn(
        header: const Header(label: 'Name'),
        builder: (context, index, row) {
          return MFDTextEdit(
            controller: TextEditingController(text: row.name),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode', fontWeight: FontWeight.bold),
            decorationOptions: const TextEditDecorationOptions(hideUnfocusedBorder: true),
            onSubmitted: (value) => widget.editorBloc.add(EntityTemplateChanged(index, row.copyWith(name: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'VT Attribute'),
        builder: (context, index, row) {
          return MFDTextEdit<MFDLoadResult>(
            controller: TextEditingController(text: row.vtAttrName),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
            decorationOptions: const TextEditDecorationOptions(
              hideUnfocusedBorder: true,
              showClearButton: true,
            ),
            itemsLoader: (query) {
              final precursor = query.selection.isValid ? query.text.substring(0, query.selection.end) : '';
              final arr = widget.state.vtentity.attributes.map((e) => e.name).toList();
              arr.sort(_sortByPrefix(precursor.toLowerCase()));
              return Future.value(arr.map((e) => MFDLoadResult(e)));
            },
            itemBuilder: (context, query, option) => MFDSelectItem(value: option.value, child: Text(option.value ?? '')),
            preload: true,
            onSubmitted: (value) => widget.editorBloc.add(EntityTemplateChanged(index, row.copyWith(vtAttrName: value))),
          );
        },
      ),
      TableColumn(
        header: Header(
          child: RotatedBox(
            quarterTurns: -1,
            child: Text('Filter', style: Theme.of(context).textTheme.caption),
          ),
        ),
        builder: (context, rowIndex, row) => const VerticalDivider(),
      ),
      TableColumn(
        header: const Header(label: 'Filter'),
        builder: (context, index, row) {
          return HTMLTypeAutocomplete(
            value: row.search,
            onSubmitted: (value) => widget.editorBloc.add(EntityTemplateChanged(index, row.copyWith(search: value))),
          );
        },
      ),
      TableColumn(
        header: Header(
          child: RotatedBox(
            quarterTurns: -1,
            child: Text('List', style: Theme.of(context).textTheme.caption),
          ),
        ),
        builder: (context, rowIndex, row) => const VerticalDivider(),
      ),
      TableColumn(
        header: const Header(label: 'List'),
        builder: (context, index, row) {
          bool hasSummary = false;
          try {
            final connectedAttr = widget.state.vtentity.attributes.firstWhere((element) => element.name == row.vtAttrName);
            hasSummary = connectedAttr.summary;
          } on StateError {
            // ignore
          }
          Widget checkbox = CheckboxStateful(
            value: row.list,
            activeColor: !hasSummary && row.list ? Colors.orange : null,
            onChanged: (value) => widget.editorBloc.add(EntityTemplateChanged(index, row.copyWith(list: value))),
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
        header: Header(
          child: RotatedBox(
            quarterTurns: -1,
            child: Text('Form', style: Theme.of(context).textTheme.caption),
          ),
        ),
        builder: (context, rowIndex, row) => const VerticalDivider(),
      ),
      TableColumn(
        header: const Header(label: 'Form'),
        builder: (context, index, row) {
          return HTMLTypeAutocomplete(
            value: row.form,
            onSubmitted: (value) => widget.editorBloc.add(EntityTemplateChanged(index, row.copyWith(form: value))),
          );
        },
      ),
      TableColumn(
        header: const Header(label: 'FK Opts', tooltip: 'IDK what it is'),
        builder: (context, index, row) {
          return MFDTextEdit(
            controller: TextEditingController(text: row.fkOpts),
            style: const TextStyle(fontSize: 14, fontFamily: 'FiraCode'),
            decorationOptions: const TextEditDecorationOptions(hideUnfocusedBorder: true),
            onSubmitted: (value) => widget.editorBloc.add(EntityTemplateChanged(index, row.copyWith(fkOpts: value))),
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
                tooltip: 'Remove template',
                onPressed: () => widget.editorBloc.add(EntityTemplateDeleted(index)),
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
                onPressed: () => widget.editorBloc.add(EntityTemplateAdded()),
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
    super.build(context);
    return Column(
      children: [
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
    );
  }

  @override
  bool get wantKeepAlive => true;
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
    return DropdownButton<String>(
      value: value,
      items: _buildItems(context),
      onChanged: (value) => onSubmitted(value!),
    );
    // Previous code for downloading list of html types.
    //
    // final subtitleStyle = Theme.of(context).textTheme.caption!.copyWith(fontFamily: 'FiraCode');
    // return _DropdownBuilder<String>(
    //   value: value,
    //   onChanged: (value) => onSubmitted(value!),
    //   itemsLoader: () async {
    //     return RepositoryProvider.of<PublicRepo>(context).htmlTypes('').then((value) => value.toList());
    //   },
    //   itemBuilder: (value) {
    //     final enumVal = HTMLType.values.firstWhere((element) => describeEnum(element) == value, orElse: () => HTMLType.HTML_UNKNOWN);
    //     final enumText = _htmlTypeDisplayText(enumVal);
    //     String mainText = value;
    //     if (mainText.startsWith('HTML_')) {
    //       mainText = mainText.substring('HTML_'.length);
    //     }
    //     final helpText = enumText ?? '$value (unknown)';
    //     return DropdownMenuItem<String>(
    //       value: value,
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 4),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(mainText),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(vertical: 3.0),
    //               child: Text(helpText, style: subtitleStyle),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  static String? _htmlTypeDisplayText(HTMLType enumVal) {
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

  List<DropdownMenuItem<String>> _buildItems(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.caption!.copyWith(fontFamily: 'FiraCode');
    return [
      _buildItem('', subtitleStyle),
      _buildItem('HTML_UNKNOWN', subtitleStyle),
      _buildItem('HTML_NONE', subtitleStyle),
      _buildItem('HTML_INPUT', subtitleStyle),
      _buildItem('HTML_TEXT', subtitleStyle),
      _buildItem('HTML_PASSWORD', subtitleStyle),
      _buildItem('HTML_EDITOR', subtitleStyle),
      _buildItem('HTML_CHECKBOX', subtitleStyle),
      _buildItem('HTML_DATETIME', subtitleStyle),
      _buildItem('HTML_DATE', subtitleStyle),
      _buildItem('HTML_TIME', subtitleStyle),
      _buildItem('HTML_FILE', subtitleStyle),
      _buildItem('HTML_IMAGE', subtitleStyle),
      _buildItem('HTML_SELECT', subtitleStyle),
    ];
  }

  DropdownMenuItem<String> _buildItem(String value, TextStyle subtitleStyle) {
    final enumVal = HTMLType.values.firstWhere((element) => describeEnum(element) == value, orElse: () => HTMLType.HTML_UNKNOWN);
    final enumText = _htmlTypeDisplayText(enumVal);
    String mainText = describeEnum(enumVal);
    if (mainText.startsWith('HTML_')) {
      mainText = mainText.substring('HTML_'.length);
    }
    final helpText = enumText ?? '$mainText (unknown)';
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

Comparator<String> _sortByPrefix(String prefix) {
  return (String a, String b) {
    final containsA = a.toLowerCase().contains(prefix);
    final containsB = b.toLowerCase().contains(prefix);
    if (containsA && containsB) {
      final result = a.toLowerCase().compareTo(b.toLowerCase());
      return result;
    }
    if (containsA) {
      return -1;
    }
    if (containsB) {
      return 1;
    }
    final result = a.toLowerCase().compareTo(b.toLowerCase());
    return result;
  };
}
