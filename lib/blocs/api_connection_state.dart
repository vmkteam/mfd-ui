part of 'api_connection_bloc.dart';

@immutable
abstract class ApiConnectionState {}

class ApiConnectionInitial extends ApiConnectionState {}

class ApiConnectionInProgress extends ApiConnectionState {
  ApiConnectionInProgress(this.url);

  final String url;
}

class ApiConnectionFailed extends ApiConnectionState {
  ApiConnectionFailed(this.url, this.error);

  final Exception error;
  final String url;
}

class ApiConnectionSuccess extends ApiConnectionState {
  ApiConnectionSuccess(this.url);

  final String url;
}
