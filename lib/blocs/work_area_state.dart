part of 'work_area_bloc.dart';

@immutable
abstract class WorkAreaState {}

class WorkAreaInitial extends WorkAreaState {}

class WorkAreaSelectInProgress extends WorkAreaState {}

class WorkAreaSelectSuccess extends WorkAreaState {
  WorkAreaSelectSuccess(this.namespace, this.entity);

  final Namespace namespace;
  final Entity entity;
}
