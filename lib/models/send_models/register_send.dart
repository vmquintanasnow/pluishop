import 'dart:convert';

class RegisterSend {
  String username;
  String password;
  String repeatPassword;
  String firstName;
  String lastName;
  String email;
  String phoneMobile;
  String phoneFixed;
  String address;
  RegisterSend(
      {this.password,
      this.username,
      this.repeatPassword,
      this.address,
      this.email,
      this.firstName,
      this.lastName,
      this.phoneFixed,
      this.phoneMobile});

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "password": password,
      "repeat_password":repeatPassword,
      "first_name":firstName,
      "last_name":lastName,
      "email":email,
      "phone_mobile":phoneMobile,
      "phone_fixed":phoneFixed,
      "address":address
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
