import 'dart:async';
import 'package:meta/meta.dart';
import 'index.dart';

@immutable
abstract class CategoryEvent {
  Future<CategoryState> applyAsync({CategoryState currentState, CategoryBloc bloc});

  final CategoryRepository _categoryProvider = new CategoryRepository();
}

class LoadCategoryEvent extends CategoryEvent {
  @override
  String toString() => 'LoadCategoryEvent';

  @override
  Future<CategoryState> applyAsync({CategoryState currentState, CategoryBloc bloc}) async {
    try {
      return InCategoryState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorCategoryState(_?.toString());
    }
  }
}
