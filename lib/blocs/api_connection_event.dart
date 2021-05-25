part of 'api_connection_bloc.dart';

@immutable
abstract class ApiConnectionEvent {}

class CheckConnection extends ApiConnectionEvent {
  CheckConnection(this.url);

  final String url;
}
