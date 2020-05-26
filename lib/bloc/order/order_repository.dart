import 'package:pluis/models/api_models/dio_helper.dart';
import 'package:pluis/models/api_models/shipping.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';

class OrderRepository {
  Future<List<Shipping>> findAll() async {
    try {
      var token = await SharedPreferencesController.getPrefAuthKey();
      var header = {"access_token": token};
      var response = await DioHelper.post(
          cachedPetition: false,
          url: "https://calzadopluis.com/admin/v1/shipping",
          data: {},
          headers: header);
      if (response.statusCode == 200) {
        List<dynamic> answer = response.data["items"];
        List<Shipping> products =
            answer.map<Shipping>((item) => Shipping.fromJson(item)).toList();
        return products;
      }
      return <Shipping>[];
    } catch (e) {
      return null;
    }
  }
}
