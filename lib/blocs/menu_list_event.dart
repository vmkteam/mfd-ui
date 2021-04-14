part of 'menu_list_bloc.dart';

@immutable
abstract class MenuListEvent {}

class MenuListSearched extends MenuListEvent {
  MenuListSearched(this.query);

  final String query;
}

class MenuListSearchCleared extends MenuListEvent {}
