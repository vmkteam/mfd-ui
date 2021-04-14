import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mfdui/services/api/api_client.dart';

part 'menu_list_event.dart';
part 'menu_list_state.dart';

class MenuListBloc extends Bloc<MenuListEvent, MenuListState> {
  MenuListBloc(this.allNamespaces) : super(MenuListInitial(allNamespaces));

  final List<Namespace> allNamespaces;

  @override
  Stream<MenuListState> mapEventToState(
    MenuListEvent event,
  ) async* {
    if (event is MenuListSearchCleared) {
      yield MenuListInitial(allNamespaces);
      return;
    }
    if (event is MenuListSearched) {
      final filtered = allNamespaces
          .map((namespace) {
            final entities = namespace.entities?.where(
              (entity) => entity?.name?.toLowerCase().contains(event.query.toLowerCase()) ?? false,
            );
            if (entities == null) {
              return null;
            }
            return Namespace(
              name: namespace.name,
              entities: entities.toList(),
            );
          })
          .where((element) => element != null)
          .map((e) => e!) // wtf - because type checker does not understands `where((element) => element != null)`.
          .toList();
      yield MenuListSearchSuccess(filtered, query: event.query);
      return;
    }
  }
}
