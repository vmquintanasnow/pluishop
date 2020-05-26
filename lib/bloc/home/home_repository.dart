import 'package:pluis/models/api_models/category.dart';
import 'package:pluis/models/api_models/dio_helper.dart';
import 'package:pluis/models/api_models/product.dart';

class HomeRepository {
  Future<List<Product>> findAll() async {
    try {
      List<Product> products = List();
      var response = await DioHelper.get(
        cachedPetition: true,
        url: "https://calzadopluis.com/admin/v1/product-settings/",
      );
      if (response.statusCode == 200) {
        var answer = response.data["items"];
        for (var i = 0; i < answer.length; i++) {
          products.add(Product.fromMap(answer[i]));
        }
      }
      return products;
    } catch (e) {
      return List();
    }
  }

  Future<List<Category>> findAllCategory() async {
    try {
      List<Category> products = List();
      var response = await DioHelper.get(
          cachedPetition: true, url: "https://calzadopluis.com/admin/v1/category");
      if (response.statusCode == 200) {
        var answer = response.data["items"];
        for (var i = 0; i < answer.length; i++) {
          products.add(Category.fromJson(answer[i]));
        }
      }
      return products;
    } catch (e) {
      return List();
    }
  }
}
