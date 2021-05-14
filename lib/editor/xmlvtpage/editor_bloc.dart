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

  VTEntity? _entity;

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

    _entity = VTEntity.fromApi(resp!);

    yield EditorEntityLoadSuccess(_entity!);
  }

  Stream<EditorState> _mapEntityEntityAttributesEventToState(EntityAttributesEvent event) async* {
    if (event is EntityAttributeChanged) {
      yield* _mapEntityAttributeChangedToState(event);
    } else if (event is EntityAttributeDeleted) {
      yield* _mapEntityAttributeDeletedToState(event);
    } else if (event is EntityAttributeAdded) {
      yield* _mapEntityAttributeAddedToState(event);
    }
    yield EditorEntityLoadSuccess(_entity!);
  }

  Stream<EditorState> _mapEntityAttributeChangedToState(EntityAttributeChanged event) async* {
    if (_entity == null) {
      return;
    }

    final newAttrs = List<VTAttribute>.from(_entity!.attributes);
    newAttrs[event.index] = event.attribute;
    final newEntity = _entity!.copyWith(attributes: newAttrs);

    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityAttributeDeletedToState(EntityAttributeDeleted event) async* {
    if (_entity == null) {
      return;
    }
    final newAttrs = List<VTAttribute>.from(_entity!.attributes);
    newAttrs.removeAt(event.index);
    final newEntity = _entity!.copyWith(attributes: newAttrs);

    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityAttributeAddedToState(EntityAttributeAdded event) async* {
    if (_entity == null) {
      return;
    }
    final newAttrs = List<VTAttribute>.from(_entity!.attributes);
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
    final newEntity = _entity!.copyWith(attributes: newAttrs);

    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityEntityTemplateEventToState(EntityTemplateEvent event) async* {
    if (event is EntityTemplateChanged) {
      yield* _mapEntityTemplateChangedToState(event);
    } else if (event is EntityTemplateDeleted) {
      yield* _mapEntityTemplateDeletedToState(event);
    } else if (event is EntityTemplateAdded) {
      yield* _mapEntityTemplateAddedToState(event);
    }
    yield EditorEntityLoadSuccess(_entity!);
  }

  Stream<EditorState> _mapEntityTemplateChangedToState(EntityTemplateChanged event) async* {
    if (_entity == null) {
      return;
    }

    final newTemplates = List<VTTemplateAttribute>.from(_entity!.templates);
    newTemplates[event.index] = event.template;
    final newEntity = _entity!.copyWith(templates: newTemplates);

    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityTemplateDeletedToState(EntityTemplateDeleted event) async* {
    if (_entity == null) {
      return;
    }
    final newTemplates = List<VTTemplateAttribute>.from(_entity!.templates);
    newTemplates.removeAt(event.index);
    final newEntity = _entity!.copyWith(templates: newTemplates);

    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityTemplateAddedToState(EntityTemplateAdded event) async* {
    if (_entity == null) {
      return;
    }
    final newTemplates = List<VTTemplateAttribute>.from(_entity!.templates);
    const newTemplate = VTTemplateAttribute(
      name: 'NewTemplate',
      fkOpts: '',
      form: '',
      list: false,
      search: '',
      vtAttrName: '',
    );
    newTemplates.add(newTemplate);
    final newEntity = _entity!.copyWith(templates: newTemplates);

    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityModeChangedToState(EntityModeChanged event) async* {
    if (_entity == null) {
      return;
    }

    final newEntity = _entity!.copyWith(mode: event.mode);

    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;

    yield EditorEntityLoadSuccess(_entity!);
  }

  Stream<EditorState> _mapEntityTerminalPathChangedToState(EntityTerminalPathChanged event) async* {
    if (_entity == null) {
      return;
    }

    final newEntity = _entity!.copyWith(terminalPath: event.terminalPath);

    await _apiClient.xmlvt.updateEntity(api.XmlvtUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;

    yield EditorEntityLoadSuccess(_entity!);
  }
}
