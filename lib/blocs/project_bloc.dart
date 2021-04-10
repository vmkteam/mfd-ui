import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/services/api/api_client.dart' as api;

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc(this.apiClient) : super(ProjectInitial());

  final api.ApiClient apiClient;

  @override
  Stream<ProjectState> mapEventToState(
    ProjectEvent event,
  ) async* {
    if (event is ProjectLoadStarted) {
      try {
        final resp = await apiClient.api.project(api.ApiProjectArgs(name: event.name));
        yield ProjectLoadSuccess(resp!);
      } catch (e) {
        yield ProjectLoadFailed(e.toString());
      }
    }
  }
}
