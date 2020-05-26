import 'dart:async';
import 'package:meta/meta.dart';
import 'index.dart';

@immutable
abstract class HomeEvent {
  Future<HomeState> applyAsync({HomeState currentState, HomeBloc bloc});

  final HomeRepository _homeProvider = new HomeRepository();
}

class LoadHomeEvent extends HomeEvent {
  @override
  String toString() => 'LoadHomeEvent';

  @override
  Future<HomeState> applyAsync({HomeState currentState, HomeBloc bloc}) async {
    try {
      var products = await _homeProvider.findAll();
      var categories = (await _homeProvider.findAllCategory())
          .where((item) => item.parent == false)
          .toList();
      return InHomeState(products: products, categories: categories);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorHomeState(_?.toString());
    }
  }
}

class PreLoadHomeEvent extends HomeEvent {
  @override
  String toString() => 'PreLoadHomeEvent';

  @override
  Future<HomeState> applyAsync({HomeState currentState, HomeBloc bloc}) async {
    try {
      return UnHomeState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorHomeState(_?.toString());
    }
  }
}
