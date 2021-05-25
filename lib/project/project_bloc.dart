part of 'project.dart';

const DefaultPgConnection = 'postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable';

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
      // fixme: in Dart SDK version: 2.12.2 (stable) (Wed Mar 17 10:30:20 2021 +0100) on "macos_x64"
      //        Flutter 2.0.4
      //        Framework • revision b1395592de
      //        Engine • revision 2dce47073a
      //        If we do not yield any new state, stream and/or event loop breaks, and this function never returns;
      yield state;
    } catch (e) {
      yield ProjectInitial();
      rethrow;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? filepath = prefs.getString('filepath');
    if (filepath == null) {
      yield ProjectInitial();
      return;
    }
    final String conn = prefs.getString('pg-conn') ?? DefaultPgConnection;
    yield* _mapProjectLoadStartedToState(ProjectLoadStarted(filepath, conn));
  }

  Stream<ProjectState> _mapProjectLoadStartedToState(ProjectLoadStarted event) async* {
    yield ProjectLoadInProgress();
    try {
      final resp = await apiClient.project.open(api.ProjectOpenArgs(
        filePath: event.filepath,
        connection: event.pgConnection,
      ));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('filepath', event.filepath);
      await prefs.setString('pg-conn', event.pgConnection);

      yield ProjectLoadSuccess(Project.fromApi(resp!), filename: event.filepath);
    } catch (e) {
      yield ProjectLoadFailed(e.toString());
    }
  }

  Stream<ProjectState> _mapProjectSaveStartedToState(ProjectSaveStarted event) async* {
    final current = state;
    if (current is ProjectLoadSuccess) {
      yield ProjectSaveInProgress(current);
      await apiClient.project.save(api.ProjectSaveArgs());
      yield ProjectSaveSuccess(current);
    }
  }
}
