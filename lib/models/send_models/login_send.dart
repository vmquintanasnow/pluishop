import 'dart:convert';

class LoginSend {
  String username;
  String password;
  LoginSend({this.password, this.username});

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "password": password,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
