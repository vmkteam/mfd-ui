part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class SettingsStarted extends SettingsEvent {}

class SettingsUpdated extends SettingsEvent {
  SettingsUpdated(this.url);

  final String url;
}
