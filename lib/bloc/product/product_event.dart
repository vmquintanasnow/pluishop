import 'dart:async';
import 'package:meta/meta.dart';
import 'index.dart';

@immutable
abstract class ProductEvent {
  Future<ProductState> applyAsync({ProductState currentState, ProductBloc bloc});

  final ProductRepository _productProvider = new ProductRepository();
}

class LoadProductEvent extends ProductEvent {
  @override
  String toString() => 'LoadProductEvent';

  @override
  Future<ProductState> applyAsync({ProductState currentState, ProductBloc bloc}) async {
    try {
      return InProductState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorProductState(_?.toString());
    }
  }
}
