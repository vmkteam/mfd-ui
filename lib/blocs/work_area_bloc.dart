import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/project/project.dart';
import 'package:mfdui/services/api/api_client.dart' as api;

part 'work_area_event.dart';
part 'work_area_state.dart';

class WorkAreaBloc extends Bloc<WorkAreaEvent, WorkAreaState> {
  WorkAreaBloc(this.projectBloc, this._apiClient) : super(WorkAreaInitial()) {
    projectBlocSub = projectBloc.stream.listen((event) {
      if (event is ProjectLoadSuccess) {
        project = event.project;
      }
    });
  }

  final api.ApiClient _apiClient;
  final ProjectBloc projectBloc;
  late StreamSubscription<ProjectState> projectBlocSub;

  void dispose() {
    projectBlocSub.cancel();
  }

  Project? project;
  Namespace? namespace;
  Entity? entity;

  @override
  Stream<WorkAreaState> mapEventToState(
    WorkAreaEvent event,
  ) async* {
    if (event is EntitySelected) {
      yield WorkAreaSelectInProgress(event.entityName);
      namespace = project!.namespaces.firstWhere((element) => element.name == event.namespaceName);
      final resp = await _apiClient.xml.loadEntity(api.XmlLoadEntityArgs(entity: event.entityName, namespace: event.namespaceName));
      entity = Entity.fromApi(resp!);
      yield WorkAreaSelectSuccess(namespace!, entity!);
      return;
    }
    if (event is EntityAdded) {
      final resp = await _apiClient.xml.generateEntity(api.XmlGenerateEntityArgs(
        namespace: event.namespaceName,
        table: event.tableName,
      ));
      namespace = project!.namespaces.firstWhere((element) => element.name == event.namespaceName);
      namespace?.entities.add(event.tableName);
      entity = Entity.fromApi(resp!);
      yield WorkAreaSelectSuccess(namespace!, entity!);
      return;
    }
    if (event is EntityTableChanged) {
      entity = entity?.copyWith(table: event.newTable);
      return;
    }
    if (event is EntityAttributeChanged || event is EntityAttributeAdded || event is EntityAttributeDeleted) {
      yield* _mapAttributeEventToState(event);
    }
    if (event is EntitySearchChanged || event is EntitySearchAdded || event is EntitySearchDeleted) {
      yield* _mapSearchEventToState(event);
    }
  }

  Stream<WorkAreaState> _mapAttributeEventToState(WorkAreaEvent event) async* {
    if (event is EntityAttributeChanged) {
      final newAttributes = entity?.attributes;
      newAttributes?[event.attributeIndex] = event.newAttribute;
      entity = entity?.copyWith(attributes: newAttributes);
      return;
    }
    if (event is EntityAttributeDeleted) {
      final newAttributes = entity?.attributes;
      newAttributes?.removeAt(event.attributeIndex);
      entity = entity?.copyWith(attributes: newAttributes);
      return;
    }
    if (event is EntityAttributeAdded) {
      final newAttributes = entity?.attributes;
      newAttributes?.add(Attribute(
        addable: false,
        dbName: '...',
        dbType: '...',
        defaultValue: '...',
        foreignKey: '...',
        goType: '...',
        isArray: false,
        max: 0,
        min: 0,
        name: '...',
        nullable: false,
        primaryKey: false,
        updatable: false,
      ));
      entity = entity?.copyWith(attributes: newAttributes);
      return;
    }
  }

  Stream<WorkAreaState> _mapSearchEventToState(WorkAreaEvent event) async* {
    if (event is EntitySearchChanged) {
      final newSearches = entity?.searches;
      newSearches?[event.searchIndex] = event.newSearch;
      entity = entity?.copyWith(searches: newSearches);
      return;
    }
    if (event is EntitySearchDeleted) {
      final newSearches = entity?.searches;
      newSearches?.removeAt(event.searchIndex);
      entity = entity?.copyWith(searches: newSearches);
      return;
    }
    if (event is EntitySearchAdded) {
      final newSearches = entity?.searches;
      newSearches?.add(const Search(attrName: '', name: '', searchType: ''));
      entity = entity?.copyWith(searches: newSearches);
      return;
    }
  }
}
