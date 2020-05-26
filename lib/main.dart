import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pluis/bloc/login/index.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';

import 'models/shop_iw.dart';
import 'resources/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          return ShoppingCartBinding(
            child: MaterialApp(
              title: 'PluisShop',
              theme: DecoratorTheme().lightTheme(),
              darkTheme: DecoratorTheme().darkTheme(),
              home: LoginPage(),
            ),
            shoppingCartInfo: new ShoppingCartInfo(products: snapshot.data),
          );
        } else {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      future: getShoppingCartFromPreferences(),
    );
  }

  Future<List<ShoppingCartItem>> getShoppingCartFromPreferences() async {
    List<ShoppingCartItem> products = List();
    List<String> productsJson = await SharedPreferencesController.getPrefCart();
    if (productsJson.length > 0) {
      productsJson.forEach((item) {
        return products.add(ShoppingCartItem.fromJson(json.decode(item)));
      });
    }
    return products;
  }
}
