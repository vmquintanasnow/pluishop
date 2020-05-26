import 'dart:convert';

import 'package:pluis/models/api_models/dio_helper.dart';
import 'package:pluis/models/api_models/login.dart';
import 'package:pluis/models/send_models/login_send.dart';
import 'package:pluis/models/send_models/register_send.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';

class LoginRepository {
  Future<Map<dynamic, dynamic>> authenticate(LoginSend loginSend) async {
    var response = await DioHelper.post(
        url: "https://calzadopluis.com/admin/v1/auth/login",
        cachedPetition: false,
        data: loginSend.toMap());
    if (response.statusCode == 200) {
      if (response.data["status"] == "200") {
        var user = User.fromJson(response.data["user"]);
        storeUser(user);
        return {"response": true, "message": ""};
      } else {
        return {"response": false, "message": response.data["message"]};
      }
    }
    return {
      "response": false,
      "message": "Ha ocurrido un error con la conexión."
    };
  }

  Future<Map<dynamic, dynamic>> register(RegisterSend registerSend) async {
    var response = await DioHelper.post(
        url: "https://calzadopluis.com/admin/v1/user-profile/register",
        cachedPetition: false,
        data: registerSend.toMap());
    if (response.statusCode == 200) {
      if (response.data["status"] == "200" ||
          response.data["status"] == "201") {
        var user = User.fromJson(response.data["user"]);
        storeUser(user);
        return {"response": true, "message": ""};
      } else {
        return {"response": false, "message": response.data["message"]};
      }
    }
    return {
      "response": false,
      "message": "Ha ocurrido un error con la conexión."
    };
  }

  Future<void> getUserProfile() async {
    var token = await SharedPreferencesController.getPrefAuthKey();
    var header = {"access_token": token};
    var response = await DioHelper.get(
        url: "https://calzadopluis.com/admin/v1/user-profile/profile",
        cachedPetition: true,
        headers: header);
    if (response.statusCode == 200) {
      if (response.data["status"] == "200" ||
          response.data["status"] == "201") {
        var user = User.fromJson(response.data["user"]);
        storeUser(user);
      }
    }
  }

  Future<void> storeUser(User user) async {
    await SharedPreferencesController.setPrefUsername(user.username);
    await SharedPreferencesController.setPrefAddress(user.address);
    await SharedPreferencesController.setPrefEmail(user.email);
    await SharedPreferencesController.setPrefAuthKey(user.authKey);
    await SharedPreferencesController.setPrefFullname(user.fullName);
    await SharedPreferencesController.setPrefAvatarUrl(user.avatar);
    await SharedPreferencesController.setPrefCellPhone(user.phoneMobile);
  }
}
