import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pluis/bloc/profile/profile_repository.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';

import 'index.dart';

class ChangePassBloc extends Bloc<ChangePassEvent, ChangePassState> {
  static final ChangePassBloc _changePassBlocSingleton =
      new ChangePassBloc._internal();
  factory ChangePassBloc() {
    return _changePassBlocSingleton;
  }
  ChangePassBloc._internal();

  ChangePassState get initialState => new UnChangePassState();

  @override
  Stream<ChangePassState> mapEventToState(
    ChangePassEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }
  }
}

@immutable
abstract class ChangePassState extends Equatable {
  const ChangePassState();

  /// Copy object for use in action
  ChangePassState copyWith();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnChangePassState extends ChangePassState {
  @override
  String toString() => 'UnChangePassState';

  @override
  ChangePassState copyWith() {
    return UnChangePassState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// InInitialized
class InChangePassState extends ChangePassState {
  String userName;
  String avatar;
  String error;

  InChangePassState({this.userName, this.avatar, this.error});

  @override
  String toString() => 'InChangePassState';

  @override
  ChangePassState copyWith() {
    return InChangePassState();
  }

  @override
  // TODO: implement props
  List<Object> get props => [userName, avatar, error];
}

/// ErrorChangePassState
class ErrorChangePassState extends ChangePassState {
  String userName;
  String avatar;
  String pass;
  String newPass;
  String error;
  int timestamp;
  ErrorChangePassState(this.error,
      {this.avatar, this.userName, this.newPass, this.pass, this.timestamp});
  @override
  String toString() => 'ErrorChangePassState';

  @override
  ChangePassState copyWith() {
    return ErrorChangePassState(error);
  }

  @override
  // TODO: implement props
  List<Object> get props => [userName, avatar, error, pass, newPass, timestamp];
}

@immutable
abstract class ChangePassEvent {
  Future<ChangePassState> applyAsync(
      {ChangePassState currentState, ChangePassBloc bloc});

  final ChangePassRepository _changePassProvider = new ChangePassRepository();
}

class LoadChangePassEvent extends ChangePassEvent {
  @override
  String toString() => 'LoadChangePassEvent';

  @override
  Future<ChangePassState> applyAsync(
      {ChangePassState currentState, ChangePassBloc bloc}) async {
    try {
      var fullName = await SharedPreferencesController.getPrefFullname();
      var avatar = await SharedPreferencesController.getPrefAvatarUrl();
      return InChangePassState(userName: fullName, avatar: avatar);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorChangePassState(_?.toString());
    }
  }
}

class ProcessChangePassEvent extends ChangePassEvent {
  String pass;
  String newPass;
  BuildContext context;

  ProcessChangePassEvent({this.pass, this.newPass, this.context});

  @override
  String toString() => 'ProcessChangePassEvent';

  @override
  Future<ChangePassState> applyAsync(
      {ChangePassState currentState, ChangePassBloc bloc}) async {
    try {
      var response = await _changePassProvider.changePass();
      var fullName = await SharedPreferencesController.getPrefFullname();
      var avatar = await SharedPreferencesController.getPrefAvatarUrl();
      if (response['success']) {
        showDialog(
            context: context,
            builder: (context) {
              return Container(child: Text(response['message']));
            });
        return InChangePassState(userName: fullName, avatar: avatar);
      } else {
        return ErrorChangePassState(response['message'],
            userName: fullName,
            avatar: avatar,
            pass: pass,
            newPass: newPass,
            timestamp: DateTime.now().millisecondsSinceEpoch);
      }
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorChangePassState(_?.toString());
    }
  }
}
