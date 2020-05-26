import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pluis/bloc/product/index.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  static final ProductBloc _productBlocSingleton =
      new ProductBloc._internal();
  factory ProductBloc() {
    return _productBlocSingleton;
  }
  ProductBloc._internal();

  ProductState get initialState => new UnProductState();

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }
  }
}
