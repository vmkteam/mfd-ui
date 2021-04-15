import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/project/project.dart';

part 'work_area_event.dart';
part 'work_area_state.dart';

class WorkAreaBloc extends Bloc<WorkAreaEvent, WorkAreaState> {
  WorkAreaBloc(this.projectBloc) : super(WorkAreaInitial()) {
    projectBlocSub = projectBloc.stream.listen((event) {
      if (event is ProjectLoadSuccess) {
        project = event.project;
      }
    });
  }

  final ProjectBloc projectBloc;
  late StreamSubscription<ProjectState> projectBlocSub;

  void dispose() {
    projectBlocSub.cancel();
  }

  Project? project;

  @override
  Stream<WorkAreaState> mapEventToState(
    WorkAreaEvent event,
  ) async* {
    if (event is EntitySelected) {
      final namespace = project!.namespaces?.firstWhere((element) => element?.name == event.namespaceName);
      final entity = namespace?.entities?.firstWhere((element) => element?.name == event.entityName);
      yield WorkAreaSelectSuccess(namespace!, entity!);
      return;
    }
  }
}
