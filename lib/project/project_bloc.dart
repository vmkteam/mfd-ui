part of 'project.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc(this.apiClient) : super(ProjectInitial());

  final api.ApiClient apiClient;

  @override
  Stream<ProjectState> mapEventToState(
    ProjectEvent event,
  ) async* {
    if (event is ProjectLoadCurrent) {
      yield* _mapProjectLoadCurrentToState(event);
    } else if (event is ProjectLoadStarted) {
      yield* _mapProjectLoadStartedToState(event);
    } else if (event is ProjectEntitySearchDeleted) {
      // yield* _mapProjectSearchDeletedToState(event);
    } else if (event is ProjectEntitySearchAdded) {
      yield* _mapProjectSearchAddedToState(event);
    } else if (event is ProjectSaveStarted) {
      yield* _mapProjectSaveStartedToState(event);
    }
  }

  Stream<ProjectState> _mapProjectLoadCurrentToState(ProjectLoadCurrent event) async* {
    try {
      final resp = await apiClient.project.current(api.ProjectCurrentArgs());
      yield ProjectLoadSuccess(Project.fromApi(resp!));
      return;
    } on ApiRpcError catch (e) {
      if (e.code != 400) {
        rethrow;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final String? filepath = prefs.getString('filepath');
    if (filepath == null) {
      return;
    }
    yield* _mapProjectLoadStartedToState(ProjectLoadStarted(filepath));
  }

  Stream<ProjectState> _mapProjectLoadStartedToState(ProjectLoadStarted event) async* {
    yield ProjectLoadInProgress();
    try {
      final resp = await apiClient.project.open(api.ProjectOpenArgs(
        filePath: event.filepath,
        connection: 'postgres://postgres:postgres@localhost:5432/uteka?sslmode=disable', //todo
      ));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('filepath', event.filepath);

      yield ProjectLoadSuccess(Project.fromApi(resp!), filename: event.filepath);
    } catch (e) {
      yield ProjectLoadFailed(e.toString());
    }
  }

  // Stream<ProjectState> _mapProjectSearchDeletedToState(ProjectEntitySearchDeleted event) async* {
  //   final localState = state;
  //   if (localState is ProjectLoadSuccess) {
  //     localState.project.namespaces
  //         .firstWhere((namespace) => namespace.name == event.namespaceName)
  //         .entities
  //         .firstWhere((entity) => entity.name == event.entityName)
  //         .searches
  //         .removeWhere((search) => search.name == event.searchName);
  //     yield ProjectLoadSuccess(localState.project, localState.filename);
  //   }
  // }

  Stream<ProjectState> _mapProjectSearchAddedToState(ProjectEntitySearchAdded event) async* {}

  Stream<ProjectState> _mapProjectSaveStartedToState(ProjectSaveStarted event) async* {
    final current = state;
    if (current is ProjectLoadSuccess) {
      yield ProjectSaveInProgress(current);
      await Future.delayed(Duration(seconds: 1));
      await apiClient.project.save(api.ProjectSaveArgs());
      yield ProjectSaveSuccess(current);
    }
  }
}
