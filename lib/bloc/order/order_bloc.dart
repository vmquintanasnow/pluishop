import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pluis/bloc/order/index.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  static final OrderBloc _orderBlocSingleton =
      new OrderBloc._internal();
  factory OrderBloc() {
    return _orderBlocSingleton;
  }
  OrderBloc._internal();

  OrderState get initialState => new UnOrderState();

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }
  }
}
