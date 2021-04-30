part of 'editor_bloc.dart';

@immutable
abstract class EditorEvent {}

class EditorEntitySelected extends EditorEvent {
  EditorEntitySelected(this.namespaceName, this.entityName);

  final String namespaceName;
  final String entityName;
}

abstract class EntityAttributesEvent extends EditorEvent {}

class EntityAttributeChanged extends EntityAttributesEvent {
  EntityAttributeChanged(this.index, this.attribute);

  final int index;
  final Attribute attribute;
}

class EntityAttributeDeleted extends EntityAttributesEvent {
  EntityAttributeDeleted(this.index);

  final int index;
}

class EntityAttributeAdded extends EntityAttributesEvent {}

abstract class EntitySearchEvent extends EditorEvent {}

class EntitySearchAdded extends EntitySearchEvent {}

class EntitySearchDeleted extends EntitySearchEvent {
  EntitySearchDeleted(this.index);

  final int index;
}

class EntitySearchChanged extends EntitySearchEvent {
  EntitySearchChanged(this.index, this.search);

  final int index;
  final Search search;
}

class EditorEntityAdded extends EditorEvent {
  EditorEntityAdded(this.namespaceName, this.tableName);

  final String namespaceName;
  final String tableName;
}

class EntityTableChanged extends EditorEvent {
  EntityTableChanged(this.tableName);

  final String tableName;
}
