import 'coupon.dart';

class User {
  String username;
  String authKey;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String address;
  String avatar;
  String phoneMobile;
  List<Coupon> coupons;

  User(
      {this.username,
      this.authKey,
      this.firstName,
      this.lastName,
      this.fullName,
      this.email,
      this.avatar,
      this.address,
      this.phoneMobile,
      this.coupons});

  User.fromJson(Map json)
      : username = json["username"],
        authKey = json["auth_key"],
        firstName = json["first_name"],
        lastName = json["last_name"],
        fullName = json["full_name"],
        email = json["email"],
        address = json["address"],
        avatar = json["avatar"],
        phoneMobile = json["phone_mobile"],
        coupons = (json["coupons"].map<Coupon>((item) => Coupon.fromJson(item)))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      "username": this.username,
      "auth_key": this.authKey,
      "first_name": this.firstName,
      "last_name": this.lastName,
      "full_name": this.fullName,
      "email": this.email,
      "address": this.address,
      "avatar": this.avatar,
      "phone_mobile": this.phoneMobile,
      "coupons": this.coupons,
    };
  }
}
