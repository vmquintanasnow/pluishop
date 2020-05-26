import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pluis/bloc/login/index.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static final LoginBloc _loginBlocSingleton =
      new LoginBloc._internal();
  factory LoginBloc() {
    return _loginBlocSingleton;
  }
  LoginBloc._internal();

  LoginState get initialState => new UnLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }
  }
}
