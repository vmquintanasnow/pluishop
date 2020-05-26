import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pluis/models/api_models/coupon.dart';
import 'package:pluis/models/api_models/payment.dart';

@immutable
abstract class ShoppingCartState extends Equatable {
  ShoppingCartState();

  /// Copy object for use in action
  ShoppingCartState copyWith();
}

/// UnInitialized
class UnShoppingCartState extends ShoppingCartState {
  @override
  String toString() => 'UnShoppingCartState';

  @override
  ShoppingCartState copyWith() {
    return UnShoppingCartState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InShoppingCartState extends ShoppingCartState {
  InShoppingCartState({this.bonuses, this.payment});
  List<Coupon> bonuses;
  List<Payment> payment;

  @override
  String toString() => 'InShoppingCartState';

  @override
  ShoppingCartState copyWith() {
    return InShoppingCartState();
  }

  @override
  // TODO: implement props
  List<Object> get props => [bonuses, payment];
}

/// On Error
class ErrorShoppingCartState extends ShoppingCartState {
  final String errorMessage;

  ErrorShoppingCartState(this.errorMessage);

  @override
  String toString() => 'ErrorShoppingCartState';

  @override
  ShoppingCartState copyWith() {
    return ErrorShoppingCartState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// No Data
class NoDataShoppingCartState extends ShoppingCartState {
  @override
  String toString() => 'NoDataShoppingCartState';

  @override
  ShoppingCartState copyWith() {
    return this;
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
