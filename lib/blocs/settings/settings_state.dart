part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {
  const SettingsState(this.url);

  final String url;
}

class SettingsInitial extends SettingsState {
  const SettingsInitial(String url) : super(url);
}

class SettingsUpdateInProgress extends SettingsState {
  const SettingsUpdateInProgress(String url) : super(url);
}

class SettingsUpdateSuccess extends SettingsState {
  const SettingsUpdateSuccess(String url) : super(url);
}

class SettingsUpdateFailed extends SettingsState {
  const SettingsUpdateFailed(String url, this.err) : super(url);
  final String err;
}
