part of 'project.dart';

@immutable
abstract class ProjectEvent {}

class ProjectLoadCurrent extends ProjectEvent {}

class ProjectLoadStarted extends ProjectEvent {
  ProjectLoadStarted(this.filepath);

  final String filepath;
}

class ProjectSaveStarted extends ProjectEvent {}

class ProjectEntitySearchDeleted extends ProjectEvent {
  ProjectEntitySearchDeleted(this.namespaceName, this.entityName, this.searchName);

  final String namespaceName;
  final String entityName;
  final String searchName;
}

class ProjectEntitySearchAdded extends ProjectEvent {
  ProjectEntitySearchAdded(this.entityName, this.search);

  final String entityName;
  final api.MfdSearches search;
}
