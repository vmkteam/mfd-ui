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

  Namespace? _namespace;
  Entity? _entity;

  @override
  Stream<EditorState> mapEventToState(
    EditorEvent event,
  ) async* {
    if (event is EditorEntitySelected) {
      yield* _mapEntitySelectedToState(event);
    } else if (event is EntityAttributesEvent) {
      yield* _mapEntityEntityAttributesEventToState(event);
    } else if (event is EntitySearchEvent) {
      yield* _mapEntityEntitySearchEventToState(event);
    } else if (event is EditorEntityAdded) {
      yield* _mapEditorEntityAddedToState(event);
    } else if (event is EntityTableChanged) {
      yield* _mapEditorEntityTableChangedToState(event);
    } else if (event is EntityNamespaceChanged) {
      yield* _mapEditorEntityNamespaceChangedToState(event);
    }
  }

  Stream<EditorState> _mapEntitySelectedToState(EditorEntitySelected event) async* {
    yield EditorEntityLoadInProgress(event.entityName);
    if (_projectBloc.state is! ProjectLoadSuccess) {
      yield EditorEntityLoadFailed(event.entityName, 'project is not opened');
      return;
    }
    _namespace = (_projectBloc.state as ProjectLoadSuccess).project.namespaces.firstWhere(
          (namespace) => namespace.name == event.namespaceName,
        );

    final resp = await _apiClient.xml.loadEntity(api.XmlLoadEntityArgs(
      entity: event.entityName,
      namespace: event.namespaceName,
    ));

    _entity = Entity.fromApi(resp!);

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

    final newAttrs = List<Attribute>.from(_entity!.attributes);
    newAttrs[event.index] = event.attribute;
    final newEntity = _entity!.copyWith(attributes: newAttrs);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityAttributeDeletedToState(EntityAttributeDeleted event) async* {
    if (_entity == null) {
      return;
    }
    final newAttrs = List<Attribute>.from(_entity!.attributes);
    newAttrs.removeAt(event.index);
    final newEntity = _entity!.copyWith(attributes: newAttrs);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityAttributeAddedToState(EntityAttributeAdded event) async* {
    if (_entity == null) {
      return;
    }
    final newAttrs = List<Attribute>.from(_entity!.attributes);
    const newAttr = Attribute(
      name: 'Name',
      dbName: 'Column',
      primaryKey: false,
      addable: true,
      dbType: '',
      defaultValue: '',
      foreignKey: '',
      goType: '',
      isArray: false,
      max: 0,
      min: 0,
      nullable: true,
      updatable: true,
    );
    newAttrs.add(newAttr);
    final newEntity = _entity!.copyWith(attributes: newAttrs);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntityEntitySearchEventToState(EntitySearchEvent event) async* {
    if (event is EntitySearchChanged) {
      yield* _mapEntitySearchChangedToState(event);
    } else if (event is EntitySearchDeleted) {
      yield* _mapEntitySearchDeletedToState(event);
    } else if (event is EntitySearchAdded) {
      yield* _mapEntitySearchAddedToState(event);
    }
    yield EditorEntityLoadSuccess(_entity!);
  }

  Stream<EditorState> _mapEntitySearchChangedToState(EntitySearchChanged event) async* {
    if (_entity == null) {
      return;
    }

    final newSearches = List<Search>.from(_entity!.searches);
    newSearches[event.index] = event.search;
    final newEntity = _entity!.copyWith(searches: newSearches);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntitySearchDeletedToState(EntitySearchDeleted event) async* {
    if (_entity == null) {
      return;
    }
    final newSearches = List<Search>.from(_entity!.searches);
    newSearches.removeAt(event.index);
    final newEntity = _entity!.copyWith(searches: newSearches);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEntitySearchAddedToState(EntitySearchAdded event) async* {
    if (_entity == null) {
      return;
    }
    final newSearches = List<Search>.from(_entity!.searches);
    const newSearch = Search(
      name: 'NewSearch',
      attrName: '',
      searchType: '',
    );
    newSearches.add(newSearch);
    final newEntity = _entity!.copyWith(searches: newSearches);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;
  }

  Stream<EditorState> _mapEditorEntityAddedToState(EditorEntityAdded event) async* {
    yield EditorEntityLoadInProgress(event.tableName);

    final newEntity = await _apiClient.xml.generateEntity(api.XmlGenerateEntityArgs(
      namespace: event.namespaceName,
      table: event.tableName,
    ));

    _entity = Entity.fromApi(newEntity!);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: _entity!.toApi()));

    _projectBloc.add(ProjectLoadCurrent()); // reload menu
    yield EditorEntityLoadSuccess(_entity!);
  }

  Stream<EditorState> _mapEditorEntityTableChangedToState(EntityTableChanged event) async* {
    if (_entity == null) {
      return;
    }

    final newEntity = _entity!.copyWith(table: event.tableName);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;

    yield EditorEntityLoadSuccess(_entity!);
  }

  Stream<EditorState> _mapEditorEntityNamespaceChangedToState(EntityNamespaceChanged event) async* {
    if (_entity == null) {
      return;
    }

    final newEntity = _entity!.copyWith(namespace: event.newNamespace);

    await _apiClient.xml.updateEntity(api.XmlUpdateEntityArgs(entity: newEntity.toApi()));
    _entity = newEntity;

    _projectBloc.add(ProjectLoadCurrent()); // reload menu
    yield EditorEntityLoadSuccess(_entity!);
  }
}
