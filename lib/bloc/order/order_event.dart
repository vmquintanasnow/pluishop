import 'dart:async';
import 'package:meta/meta.dart';
import 'index.dart';

@immutable
abstract class OrderEvent {
  Future<OrderState> applyAsync({OrderState currentState, OrderBloc bloc});

  final OrderRepository _orderProvider = new OrderRepository();
}

class LoadOrderEvent extends OrderEvent {
  @override
  String toString() => 'LoadOrderEvent';

  @override
  Future<OrderState> applyAsync(
      {OrderState currentState, OrderBloc bloc}) async {
    try {
      var shipping = await _orderProvider.findAll();
      if (shipping == null || shipping.length == 0) {
        return NoDataOrderState();
      }
      return InOrderState(shipping: shipping);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorOrderState(_?.toString());
    }
  }
}

class PreLoadOrderEvent extends OrderEvent {
  @override
  String toString() => 'LoadOrderEvent';

  @override
  Future<OrderState> applyAsync(
      {OrderState currentState, OrderBloc bloc}) async {
    try {
      return UnOrderState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorOrderState(_?.toString());
    }
  }
}
