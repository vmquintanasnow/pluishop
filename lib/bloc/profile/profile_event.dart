import 'dart:async';
import 'package:meta/meta.dart';
import 'index.dart';

@immutable
abstract class ProfileEvent {
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc});

  final ProfileRepository _profileProvider = new ProfileRepository();
}

class LoadProfileEvent extends ProfileEvent {
  @override
  String toString() => 'LoadProfileEvent';

  @override
  Future<ProfileState> applyAsync(
      {ProfileState currentState, ProfileBloc bloc}) async {
    try {
      var user = await _profileProvider.getUserProfile();

      return InProfileState(
          address: user.address,
          avatar: user.avatar,
          username: user.username,
          email: user.email,
          phone: user.phoneMobile,
          fullname: user.fullName,
          coupons: user.coupons);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorProfileState(_?.toString());
    }
  }
}
