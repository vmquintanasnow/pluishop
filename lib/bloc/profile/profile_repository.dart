import 'package:pluis/bloc/login/login_repository.dart';
import 'package:pluis/models/api_models/dio_helper.dart';
import 'package:pluis/models/api_models/login.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';

class ProfileRepository {
  Future<User> getUserProfile() async {
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
        await LoginRepository().storeUser(user);
        return user;
      }
    }
    return null;
  }
}
