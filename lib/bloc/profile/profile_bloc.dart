import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pluis/bloc/profile/index.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  static final ProfileBloc _profileBlocSingleton =
      new ProfileBloc._internal();
  factory ProfileBloc() {
    return _profileBlocSingleton;
  }
  ProfileBloc._internal();

  ProfileState get initialState => new UnProfileState();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    try {
      yield await event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      yield state;
    }
  }
}
