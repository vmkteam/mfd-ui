part of 'project.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc(this.apiClient) : super(ProjectInitial());

  final api.ApiClient apiClient;

  @override
  Stream<ProjectState> mapEventToState(
    ProjectEvent event,
  ) async* {
    if (event is ProjectLoadStarted) {
      yield* _mapProjectLoadStartedToState(event);
    } else if (event is ProjectEntitySearchDeleted) {
      yield* _mapProjectSearchDeletedToState(event);
    } else if (event is ProjectEntitySearchAdded) {
      yield* _mapProjectSearchAddedToState(event);
    }
  }

  Stream<ProjectState> _mapProjectLoadStartedToState(ProjectLoadStarted event) async* {
    yield ProjectLoadInProgress();
    try {
      final resp = await apiClient.api.project(api.ApiProjectArgs(filepath: event.filepath));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('filepath', event.filepath);

      yield ProjectLoadSuccess(Project.fromApi(resp!), event.filepath);
    } catch (e) {
      yield ProjectLoadFailed(e.toString());
    }
  }

  Stream<ProjectState> _mapProjectSearchDeletedToState(ProjectEntitySearchDeleted event) async* {
    final localState = state;
    if (localState is ProjectLoadSuccess) {
      localState.project.namespaces
          .firstWhere((namespace) => namespace.name == event.namespaceName)
          .entities
          .firstWhere((entity) => entity.name == event.entityName)
          .searches
          .removeWhere((search) => search.name == event.searchName);
      yield ProjectLoadSuccess(localState.project, localState.filename);
    }
  }

  Stream<ProjectState> _mapProjectSearchAddedToState(ProjectEntitySearchAdded event) async* {}
}
