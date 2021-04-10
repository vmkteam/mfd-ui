part of 'project_bloc.dart';

@immutable
abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoadSuccess extends ProjectState {
  ProjectLoadSuccess(this.project);

  final api.Project project;
}

class ProjectLoadFailed extends ProjectState {
  ProjectLoadFailed(this.err);

  final String err;
}
