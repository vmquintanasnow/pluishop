import 'package:pluis/models/api_models/coupon.dart';
import 'package:pluis/models/api_models/dio_helper.dart';
import 'package:pluis/models/api_models/payment.dart';
import 'package:pluis/models/send_models/shipping_create.dart';

class ShoppingCartRepository {
  Future<List<Coupon>> findAllCoupons() async {
    try {
      List<Coupon> products = List();
      var response = await DioHelper.get(
          cachedPetition: true,
          url: "https://calzadopluis.com/admin/v1/coupon/");
      if (response.statusCode == 200) {
        var answer = response.data["items"];
        for (var i = 0; i < answer.length; i++) {
          products.add(Coupon.fromJson(answer[i]));
        }
      }
      return products;
    } catch (e) {
      return List();
    }
  }

  Future<List<Payment>> findAllPayments() async {
    try {
      List<Payment> products = List();
      var response = await DioHelper.get(
          cachedPetition: true,
          url: "https://calzadopluis.com/admin/v1/payment-way");
      if (response.statusCode == 200) {
        var answer = response.data["items"];
        for (var i = 0; i < answer.length; i++) {
          products.add(Payment.fromJson(answer[i]));
        }
      }
      return products;
    } catch (e) {
      return List();
    }
  }

  Future<Map<dynamic, dynamic>> processShipping(ShippingCreate shipping) async {
    try {
      var cosa=shipping.toMap();
      var response = await DioHelper.post(
          cachedPetition: true,
          url: "https://calzadopluis.com/admin/v1/shipping/create",
          data: shipping.toMap());
      if (response.statusCode == 200) {
        bool success = response.data["success"];
        if (success) {
          return {
            "response": true,
            "message":
                "Se ha realizado la compra satisfactoriamente.\nPuede realizar el seguimiento en la sección \"Seguimiento\""
          };
        } else {
          Map error = response.data["errors"];
          return {"response": false, "message": error.values.first[0]};
        }
      }
      return {"response": false, "message": "Ha ocurrido un error"};
    } catch (e) {
      return {"response": false, "message": "Ha ocurrido un error"};
    }
  }
}
