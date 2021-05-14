part of 'editor_bloc.dart';

@immutable
abstract class EditorState {}

class EditorInitial extends EditorState {}

class EditorEntityLoadInProgress extends EditorState {
  EditorEntityLoadInProgress(this.entityName);

  final String entityName;
}

class EditorEntityLoadSuccess extends EditorState {
  EditorEntityLoadSuccess(this.entity);

  final Entity entity;
}

class EditorEntityLoadFailed extends EditorState {
  EditorEntityLoadFailed(this.entityName, this.error);

  final String entityName;
  final String error;
}
