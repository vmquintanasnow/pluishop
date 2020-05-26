import 'dart:async';
import 'package:meta/meta.dart';
import 'package:pluis/models/send_models/login_send.dart';
import 'package:pluis/models/send_models/register_send.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';
import 'index.dart';

@immutable
abstract class LoginEvent {
  Future<LoginState> applyAsync({LoginState currentState, LoginBloc bloc});

  final LoginRepository _loginProvider = new LoginRepository();
}

class LoadLoginEvent extends LoginEvent {
  @override
  String toString() => 'LoadLoginEvent';

  @override
  Future<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async {
    try {
      var logged = await SharedPreferencesController.getPrefLogged();
      if (logged) {
        await _loginProvider.getUserProfile();
        return AuthLoginState();
      } else {
        return InLoginState();
      }
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorLoginState(_?.toString());
    }
  }
}

class AuthenticateLoginEvent extends LoginEvent {
  final String pass;
  final String user;
  AuthenticateLoginEvent({this.user, this.pass});

  @override
  String toString() => 'AuthenticateLoginEvent';

  @override
  Future<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async {
    try {
      var loginSend = LoginSend(password: pass, username: user);
      var response = await LoginRepository().authenticate(loginSend);
      if (response["response"]) {
        await SharedPreferencesController.setPrefLogged(true);
        return AuthLoginState();
      } else {
        return ErrorInLoginState(response["message"], loginSend);
      }
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorLoginState(_?.toString());
    }
  }
}

class OpenRegisterLoginEvent extends LoginEvent {
  @override
  String toString() => 'OpenRegisterLoginEvent';

  @override
  Future<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async {
    try {
      return RegisterLoginState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorLoginState(_?.toString());
    }
  }
}

class RegisterLoginEvent extends LoginEvent {
  final RegisterSend registerSend;

  RegisterLoginEvent(this.registerSend);

  @override
  String toString() => 'RegisterLoginEvent';

  @override
  Future<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async {
    try {
      var response = await LoginRepository().register(registerSend);
      if (response["response"]) {
        await SharedPreferencesController.setPrefLogged(true);
        return AuthLoginState();
      } else {
        return ErrorInRegisterLoginState(response["message"], registerSend);
      }
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorLoginState(_?.toString());
    }
  }
}

class LogoutLoginEvent extends LoginEvent {
  @override
  String toString() => 'LogoutLoginEvent';

  @override
  Future<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async {
    try {
      await SharedPreferencesController.cleanAll();
      return InLoginState();
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorLoginState(_?.toString());
    }
  }
}
