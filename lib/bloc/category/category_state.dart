import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryState extends Equatable {
  CategoryState();

  /// Copy object for use in action
  CategoryState copyWith();
}

/// UnInitialized
class UnCategoryState extends CategoryState {
  @override
  String toString() => 'UnCategoryState';

  @override
  CategoryState copyWith() {
    return UnCategoryState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InCategoryState extends CategoryState {
 
  @override
  String toString() => 'InCategoryState';

  @override
  CategoryState copyWith() {
    return InCategoryState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// On Error
class ErrorCategoryState extends CategoryState {
  final String errorMessage;

  ErrorCategoryState(this.errorMessage);

  @override
  String toString() => 'ErrorCategoryState';

  @override
  CategoryState copyWith() {
    return ErrorCategoryState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// No Data
class NoDataCategoryState extends CategoryState {
  @override
  String toString() => 'NoDataCategoryState';

  @override
  CategoryState copyWith() {
    return this;
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
