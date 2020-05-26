import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pluis/bloc/home/home_bloc.dart';
import 'package:pluis/bloc/home/home_event.dart';
import 'package:pluis/bloc/home/home_page.dart';
import 'package:pluis/bloc/order/order_page.dart';
import 'package:pluis/models/send_models/shipping_create.dart';
import 'package:pluis/models/shop_iw.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';
import 'index.dart';

@immutable
abstract class ShoppingCartEvent {
  Future<ShoppingCartState> applyAsync(
      {ShoppingCartState currentState, ShoppingCartBloc bloc});

  final ShoppingCartRepository _shoppingCartProvider =
      new ShoppingCartRepository();
}

class LoadShoppingCartEvent extends ShoppingCartEvent {
  LoadShoppingCartEvent({@required this.context});
  BuildContext context;
  @override
  String toString() => 'LoadShoppingCartEvent';

  @override
  Future<ShoppingCartState> applyAsync(
      {ShoppingCartState currentState, ShoppingCartBloc bloc}) async {
    try {
      var bonuses = await _shoppingCartProvider.findAllCoupons();
      var payment = await _shoppingCartProvider.findAllPayments();
      var productsFromCart = ShoppingCartInfo.of(context).products;
      if (productsFromCart.length > 0) {
        setShoppingCartFromPreferences();
      }

      return InShoppingCartState(bonuses: bonuses, payment: payment);
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShoppingCartState(_?.toString());
    }
  }

  Future<bool> setShoppingCartFromPreferences() async {
    var products = ShoppingCartInfo.of(context).products;
    List<String> productJsons = List();
    products.forEach((item) => productJsons.add(item.toJson()));
    return await SharedPreferencesController.setPrefCart(productJsons);
  }

  Future<List<ShoppingCartItem>> getShoppingCartFromPreferences() async {
    List<ShoppingCartItem> products = List();
    List<String> productsJson = await SharedPreferencesController.getPrefCart();
    productsJson.forEach((item) {
      return products.add(ShoppingCartItem.fromJson(json.decode(item)));
    });
    return products;
  }
}

class ProcessShoppingCartEvent extends ShoppingCartEvent {
  ProcessShoppingCartEvent({@required this.context});
  BuildContext context;
  @override
  String toString() => 'LoadShoppingCartEvent';

  @override
  Future<ShoppingCartState> applyAsync(
      {ShoppingCartState currentState, ShoppingCartBloc bloc}) async {
    try {
      var iw = ShoppingCartInfo.of(context);
      var products = iw.products;
      await SharedPreferencesController.setPrefAddress(iw.address);
      await SharedPreferencesController.setPrefCellPhone(iw.phone);
      await SharedPreferencesController.setPrefEmail(iw.email);
      ShippingCreate shippingCreate = ShippingCreate(
          address: iw.address,
          contactEmail: iw.email,
          contactPhone: iw.phone,
          couponId: int.parse(iw.coupon.getId()),
          paymentWayId: int.parse(iw.payment.id),
          transactionCode: iw.payment.confirmationTicket,
          carts: products
              .map<CartSend>((item) => CartSend(
                  productId: int.parse(item.product.getId()),
                  quantity: item.amount,
                  size: item.sku.talla,
                  color: item.skuOption.color))
              .toList());
      var response =
          await _shoppingCartProvider.processShipping(shippingCreate);
      if (response["response"]) {
        ShoppingCartInfo.of(context).products = <ShoppingCartItem>[];
        ShoppingCartInfo.update(context);
        await SharedPreferencesController.setPrefCart(<String>[]);
        var choice = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Compra realizada"),
                content: Text(
                  response["message"],
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Continuar"),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });
        if (choice == null) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
          return UnShoppingCartState();
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OrderPage()));
          return UnShoppingCartState();
        }
      } else {
        var choice = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(response["message"]),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text("Continuar"),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });
        if (choice == null || !choice) {
          return currentState;
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
          return UnShoppingCartState();
        }
      }
    } catch (_, stackTrace) {
      print('$_ $stackTrace');
      return new ErrorShoppingCartState(_?.toString());
    }
  }
}
