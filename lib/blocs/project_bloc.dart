import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/services/api/api_client.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';

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
      yield ProjectLoadInProgress();
      try {
        final resp = await apiClient.api.project(api.ApiProjectArgs(filepath: event.filepath));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('filepath', event.filepath);

        yield ProjectLoadSuccess(resp!, event.filepath);
      } catch (e) {
        yield ProjectLoadFailed(e.toString());
      }
    }
  }
}
