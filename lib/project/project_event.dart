part of 'project.dart';

@immutable
abstract class ProjectEvent {}

class ProjectLoadCurrent extends ProjectEvent {}

class ProjectLoadStarted extends ProjectEvent {
  ProjectLoadStarted(this.filepath, this.pgConnection);

  final String filepath;
  final String pgConnection;
}

class ProjectSaveStarted extends ProjectEvent {}
