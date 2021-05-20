import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart' as api;

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc(this._apiClient, this._projectBloc) : super(EditorInitial());

  final api.ApiClient _apiClient;
  final ProjectBloc _projectBloc;

  VTEntity? _vtentity;
  Entity? _entity;

  @override
  Stream<EditorState> mapEventToState(
    EditorEvent event,
  ) async* {
    if (event is EditorEntitySelected) {
      yield* _mapEntitySelectedToState(event);
    } else if (event is EntityAttributesEvent) {
      yield* _mapEntityEntityAttributesEventToState(event);
    } else if (event is EntityTemplateEvent) {
      yield* _mapEntityEntityTemplateEventToState(event);
    } else if (event is EntityModeChanged) {
      yield* _mapEntityModeChangedToState(event);
    } else if (event is EntityTerminalPathChanged) {
      yield* _mapEntityTerminalPathChangedToState(event);
    }
  }

  Stream<EditorState> _mapEntitySelectedToState(EditorEntitySelected event) async* {
    yield EditorEntityLoadInProgress(event.entityName);
    if (_projectBloc.state is! ProjectLoadSuccess) {
      yield EditorEntityLoadFailed(event.entityName, 'project is not opened');
      return;
    }

    final resp = await _apiClient.xmlvt.loadEntity(api.XmlvtLoadEntityArgs(
      entity: event.entityName,
      namespace: event.namespaceName,
    ));

    _vtentity = VTEntity.fromApi(resp!, event.namespaceName);

    final entityResp = await _apiClient.xml.loadEntity(api.XmlLoadEntityArgs(
      entity: event.entityName,
      namespace: event.namespaceName,
    ));

    _entity = Entity.fromApi(entityResp!);

    yield EditorEntityLoadSuccess(_vtentity!, _entity!);
  }

  Stream<EditorState> _mapEntityEntityAttributesEventToState(EntityAttributesEvent event) async* {
    if (event is EntityAttributeChanged) {
      yield* _mapEntityAttributeChangedToState(event);
    } else if (event is EntityAttributeDeleted) {
      yield* _mapEntityAttributeDeletedToState(event);
    } else if (event is EntityAttributeAdded) {
      yield* _mapEntityAttributeAddedToState(event);
    }
    yield EditorEntityLoadSuccess(_vtentity!, _entity!);
  }

  Stream<EditorState> _mapEntityAttributeChangedToState(EntityAttributeChanged event) async* {
    if (_vtentity == null) {
      return;
    }

    final newAttrs = List<VTAttribute>.from(_vtentity!.attributes);
    newAttrs[event.index] = event.attribute;
    final newEntity = _vtentity!.copyWith(attributes: newAttrs);

    await updateEntity(newEntity);
    _vtentity = newEntity;
  }

  Stream<EditorState> _mapEntityAttributeDeletedToState(EntityAttributeDeleted event) async* {
    if (_vtentity == null) {
      return;
    }
    final newAttrs = List<VTAttribute>.from(_vtentity!.attributes);
    newAttrs.removeAt(event.index);
    final newEntity = _vtentity!.copyWith(attributes: newAttrs);

    await updateEntity(newEntity);
    _vtentity = newEntity;
  }

  Stream<EditorState> _mapEntityAttributeAddedToState(EntityAttributeAdded event) async* {
    if (_vtentity == null) {
      return;
    }
    final newAttrs = List<VTAttribute>.from(_vtentity!.attributes);
    const newAttr = VTAttribute(
      name: 'Attribute',
      attrName: '',
      required: false,
      summary: false,
      search: false,
      searchName: '',
      validate: '',
      max: null,
      min: null,
    );
    newAttrs.add(newAttr);
    final newEntity = _vtentity!.copyWith(attributes: newAttrs);

    await updateEntity(newEntity);
    _vtentity = newEntity;
  }

  Stream<EditorState> _mapEntityEntityTemplateEventToState(EntityTemplateEvent event) async* {
    if (event is EntityTemplateChanged) {
      yield* _mapEntityTemplateChangedToState(event);
    } else if (event is EntityTemplateDeleted) {
      yield* _mapEntityTemplateDeletedToState(event);
    } else if (event is EntityTemplateAdded) {
      yield* _mapEntityTemplateAddedToState(event);
    }
    yield EditorEntityLoadSuccess(_vtentity!, _entity!);
  }

  Stream<EditorState> _mapEntityTemplateChangedToState(EntityTemplateChanged event) async* {
    if (_vtentity == null) {
      return;
    }

    final newTemplates = List<VTTemplateAttribute>.from(_vtentity!.templates);
    newTemplates[event.index] = event.template;
    final newEntity = _vtentity!.copyWith(templates: newTemplates);

    await updateEntity(newEntity);
    _vtentity = newEntity;
  }

  Stream<EditorState> _mapEntityTemplateDeletedToState(EntityTemplateDeleted event) async* {
    if (_vtentity == null) {
      return;
    }
    final newTemplates = List<VTTemplateAttribute>.from(_vtentity!.templates);
    newTemplates.removeAt(event.index);
    final newEntity = _vtentity!.copyWith(templates: newTemplates);

    await updateEntity(newEntity);
    _vtentity = newEntity;
  }

  Stream<EditorState> _mapEntityTemplateAddedToState(EntityTemplateAdded event) async* {
    if (_vtentity == null) {
      return;
    }
    final newTemplates = List<VTTemplateAttribute>.from(_vtentity!.templates);
    const newTemplate = VTTemplateAttribute(
      name: 'NewTemplate',
      fkOpts: '',
      form: '',
      list: false,
      search: '',
      vtAttrName: '',
    );
    newTemplates.add(newTemplate);
    final newEntity = _vtentity!.copyWith(templates: newTemplates);

    await updateEntity(newEntity);
    _vtentity = newEntity;
  }

  Stream<EditorState> _mapEntityModeChangedToState(EntityModeChanged event) async* {
    if (_vtentity == null) {
      return;
    }

    final newEntity = _vtentity!.copyWith(mode: event.mode);

    await updateEntity(newEntity);
    _vtentity = newEntity;

    yield EditorEntityLoadSuccess(_vtentity!, _entity!);
  }

  Stream<EditorState> _mapEntityTerminalPathChangedToState(EntityTerminalPathChanged event) async* {
    if (_vtentity == null) {
      return;
    }

    final newEntity = _vtentity!.copyWith(terminalPath: event.terminalPath);

    await updateEntity(newEntity);
    _vtentity = newEntity;

    yield EditorEntityLoadSuccess(_vtentity!, _entity!);
  }

  Future<void> updateEntity(VTEntity newEntity) async {
    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(
      entity: newEntity.toApi(),
      namespace: newEntity.namespace,
    ));
  }
}
