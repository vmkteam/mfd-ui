part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class SettingsUpdated extends SettingsEvent {
  SettingsUpdated(this.url);

  final String url;
}
