part of 'work_area_bloc.dart';

@immutable
abstract class WorkAreaEvent {}

class EntitySelected extends WorkAreaEvent {
  EntitySelected(this.entityName, this.namespaceName);

  final String namespaceName;
  final String entityName;
}
