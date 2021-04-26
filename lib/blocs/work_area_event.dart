part of 'work_area_bloc.dart';

@immutable
abstract class WorkAreaEvent {}

class EntitySelected extends WorkAreaEvent {
  EntitySelected(this.entityName, this.namespaceName);

  final String namespaceName;
  final String entityName;
}

class EntityAdded extends WorkAreaEvent {
  EntityAdded(this.namespaceName, this.entityName);

  final String namespaceName;
  final String entityName;
}

class EntityTableChanged extends WorkAreaEvent {
  EntityTableChanged(this.newTable);

  final String newTable;
}

class EntityAttributeChanged extends WorkAreaEvent {
  EntityAttributeChanged(this.attributeIndex, this.newAttribute);

  final int attributeIndex;
  final Attribute newAttribute;
}

class EntityAttributeAdded extends WorkAreaEvent {}

class EntityAttributeDeleted extends WorkAreaEvent {
  EntityAttributeDeleted(this.attributeIndex);

  final int attributeIndex;
}

class EntitySearchChanged extends WorkAreaEvent {
  EntitySearchChanged(this.searchIndex, this.newSearch);

  final int searchIndex;
  final Search newSearch;
}

class EntitySearchDeleted extends WorkAreaEvent {
  EntitySearchDeleted(this.searchIndex);

  final int searchIndex;
}

class EntitySearchAdded extends WorkAreaEvent {}
