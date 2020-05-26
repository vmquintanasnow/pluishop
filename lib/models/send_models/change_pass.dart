import 'dart:convert';

class ChangePass {
  String password;
  String repeat_password;
  String current_password;

  ChangePass({this.password, this.current_password, this.repeat_password});

  Map<String, dynamic> toMap() {
    return {
      "password": password,
      "repeat_password": repeat_password,
      "current_password": current_password,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
