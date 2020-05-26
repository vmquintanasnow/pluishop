import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pluis/bloc/category/index.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  static final CategoryBloc _categoryBlocSingleton =
      new CategoryBloc._internal();
  factory CategoryBloc() {
    return _categoryBlocSingleton;
  }
  CategoryBloc._internal();

  CategoryState get initialState => new UnCategoryState();

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }
  }
}
