import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pluis/models/api_models/coupon.dart';

@immutable
abstract class ProfileState extends Equatable {
  const ProfileState();

  /// Copy object for use in action
  ProfileState copyWith();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnProfileState extends ProfileState {
  @override
  String toString() => 'UnProfileState';

  @override
  ProfileState copyWith() {
    return UnProfileState();
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// Initialized
class InProfileState extends ProfileState {
  String username, fullname, email, address, phone, avatar;
  List<Coupon> coupons;
  InProfileState(
      {this.username,
      this.fullname,
      this.email,
      this.address,
      this.phone,
      this.avatar,
      this.coupons});

  @override
  String toString() => 'InProfileState';

  @override
  ProfileState copyWith() {
    return this;
  }

  @override
  // TODO: implement props
  List<Object> get props =>
      [coupons, username, fullname, email, address, phone, avatar];
}

/// On Error
class ErrorProfileState extends ProfileState {
  final String errorMessage;

  ErrorProfileState(this.errorMessage);

  @override
  String toString() => 'ErrorProfileState';

  @override
  ProfileState copyWith() {
    return ErrorProfileState(this.errorMessage);
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}

/// No Data
class NoDataProfileState extends ProfileState {
  @override
  String toString() => 'NoDataProfileState';

  @override
  ProfileState copyWith() {
    return this;
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
