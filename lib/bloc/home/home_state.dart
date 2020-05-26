import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pluis/models/api_models/category.dart';
import 'package:pluis/models/api_models/product.dart';

@immutable
abstract class HomeState extends Equatable {
  HomeState();

  /// Copy object for use in action
  HomeState copyWith();
}

/// UnInitialized
class UnHomeState extends HomeState {
  @override
  String toString() => 'UnHomeState';

  @override
  HomeState copyWith() {
    return UnHomeState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InHomeState extends HomeState {
  List<Product> products;
  List<Category> categories;
  InHomeState({@required this.products, @required this.categories});

  @override
  String toString() => 'InHomeState';

  @override
  HomeState copyWith() {
    return InHomeState(products: products, categories: categories);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// On Error
class ErrorHomeState extends HomeState {
  final String errorMessage;

  ErrorHomeState(this.errorMessage);

  @override
  String toString() => 'ErrorHomeState';

  @override
  HomeState copyWith() {
    return ErrorHomeState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// No Data
class NoDataHomeState extends HomeState {
  @override
  String toString() => 'NoDataHomeState';

  @override
  HomeState copyWith() {
    return this;
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
