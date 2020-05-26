import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProductState extends Equatable {
  ProductState();

  /// Copy object for use in action
  ProductState copyWith();
}

/// UnInitialized
class UnProductState extends ProductState {
  @override
  String toString() => 'UnProductState';

  @override
  ProductState copyWith() {
    return UnProductState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InProductState extends ProductState {
 
  @override
  String toString() => 'InProductState';

  @override
  ProductState copyWith() {
    return InProductState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// On Error
class ErrorProductState extends ProductState {
  final String errorMessage;

  ErrorProductState(this.errorMessage);

  @override
  String toString() => 'ErrorProductState';

  @override
  ProductState copyWith() {
    return ErrorProductState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// No Data
class NoDataProductState extends ProductState {
  @override
  String toString() => 'NoDataProductState';

  @override
  ProductState copyWith() {
    return this;
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
