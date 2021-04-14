part of 'menu_list_bloc.dart';

@immutable
abstract class MenuListState {
  const MenuListState(this.namespaces);

  final List<Namespace> namespaces;
}

class MenuListInitial extends MenuListState {
  const MenuListInitial(List<Namespace> namespaces) : super(namespaces);
}

class MenuListSearchSuccess extends MenuListState {
  const MenuListSearchSuccess(List<Namespace> namespaces, {required this.query}) : super(namespaces);

  final String query;
}
