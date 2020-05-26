import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pluis/models/send_models/login_send.dart';
import 'package:pluis/models/send_models/register_send.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  /// Copy object for use in action
  LoginState copyWith();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnLoginState extends LoginState {
  @override
  String toString() => 'UnLoginState';

  @override
  LoginState copyWith() {
    return UnLoginState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InLoginState extends LoginState {
  @override
  String toString() => 'InLoginState';

  @override
  LoginState copyWith() {
    return InLoginState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class AuthLoginState extends LoginState {
  @override
  String toString() => 'InLoginState';

  @override
  LoginState copyWith() {
    return InLoginState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// RegisterLoginState
class RegisterLoginState extends LoginState {
  @override
  String toString() => 'InLoginState';

  @override
  LoginState copyWith() {
    return InLoginState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// On Error
class ErrorLoginState extends LoginState {
  final String errorMessage;

  ErrorLoginState(this.errorMessage);

  @override
  String toString() => 'ErrorLoginState';

  @override
  LoginState copyWith() {
    return ErrorLoginState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// On Error
class ErrorInLoginState extends LoginState {
  final String errorMessage;
  final LoginSend loginSend;
  const ErrorInLoginState(this.errorMessage, this.loginSend);

  @override
  String toString() => 'ErrorInLoginState';

  @override
  LoginState copyWith({String newErrorMessage}) {
    return ErrorInLoginState(newErrorMessage, this.loginSend);
  }

  @override
  List<Object> get props => [errorMessage, loginSend];
}

class ErrorInRegisterLoginState extends LoginState {
  final String errorMessage;
  final RegisterSend registerSend;
  const ErrorInRegisterLoginState(this.errorMessage, this.registerSend);

  @override
  String toString() => 'ErrorInLoginState';

  @override
  LoginState copyWith({String newErrorMessage}) {
    return ErrorInRegisterLoginState(newErrorMessage, this.registerSend);
  }

  @override
  List<Object> get props => [errorMessage, registerSend];
}

/// No Data
class NoDataLoginState extends LoginState {
  @override
  String toString() => 'NoDataLoginState';

  @override
  LoginState copyWith() {
    return this;
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
