part of 'project_bloc.dart';

@immutable
abstract class ProjectEvent {}

class ProjectLoadStarted extends ProjectEvent {
  ProjectLoadStarted(this.name);

  final String name;
}
