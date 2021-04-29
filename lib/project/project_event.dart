part of 'project.dart';

@immutable
abstract class ProjectEvent {}

class ProjectLoadCurrent extends ProjectEvent {}

class ProjectLoadStarted extends ProjectEvent {
  ProjectLoadStarted(this.filepath);

  final String filepath;
}

class ProjectSaveStarted extends ProjectEvent {}
