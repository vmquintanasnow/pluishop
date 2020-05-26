import 'package:pluis/models/api_models/dio_helper.dart';

class ChangePassRepository {
  Future<Map<String, dynamic>> changePass({String old, String newPass}) async {
    var data = {
      "password": old,
      "repeat_password": newPass,
      "current_password": newPass
    };

    var response = await DioHelper.post(
        url: "https://calzadopluis.com/admin/v1/user-profile/change-own-password",
        cachedPetition: false,
        data: data);
    if (response.statusCode == 200) {
      if (response.data["status"] == "200" ||
          response.data["status"] == "201") {
        return {"success": true, "message": ""};
      } else {
        return {"success": false, "message": response.data["message"]};
      }
    }
    return {
      "response": false,
      "message": "Ha ocurrido un error con la conexión."
    };
  }
}
