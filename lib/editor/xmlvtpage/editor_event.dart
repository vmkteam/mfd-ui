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
  final VTAttribute attribute;
}

class EntityAttributeDeleted extends EntityAttributesEvent {
  EntityAttributeDeleted(this.index);

  final int index;
}

class EntityAttributeAdded extends EntityAttributesEvent {}

abstract class EntityTemplateEvent extends EditorEvent {}

class EntityTemplateAdded extends EntityTemplateEvent {}

class EntityTemplateDeleted extends EntityTemplateEvent {
  EntityTemplateDeleted(this.index);

  final int index;
}

class EntityTemplateChanged extends EntityTemplateEvent {
  EntityTemplateChanged(this.index, this.template);

  final int index;
  final VTTemplateAttribute template;
}

class EntityModeChanged extends EditorEvent {
  EntityModeChanged(this.mode);

  final String mode;
}

class EntityTerminalPathChanged extends EditorEvent {
  EntityTerminalPathChanged(this.terminalPath);

  final String terminalPath;
}
