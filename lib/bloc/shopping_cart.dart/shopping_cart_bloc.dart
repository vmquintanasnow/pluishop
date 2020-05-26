import 'dart:async';

import 'package:bloc/bloc.dart';

import 'index.dart';


class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  static final ShoppingCartBloc _shoppingCartBlocSingleton =
      new ShoppingCartBloc._internal();
  factory ShoppingCartBloc() {
    return _shoppingCartBlocSingleton;
  }
  ShoppingCartBloc._internal();

  ShoppingCartState get initialState => new UnShoppingCartState();

  @override
  Stream<ShoppingCartState> mapEventToState(
    ShoppingCartEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }
  }
}
