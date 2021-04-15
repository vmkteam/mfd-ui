part of 'project.dart';

@immutable
abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoadInProgress extends ProjectState {}

class ProjectLoadSuccess extends ProjectState {
  ProjectLoadSuccess(this.project, this.filename);

  final Project project;
  final String filename;
}

class ProjectLoadFailed extends ProjectState {
  ProjectLoadFailed(this.err);

  final String err;
}
