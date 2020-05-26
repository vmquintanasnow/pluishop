import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis/models/api_models/coupon.dart';
import 'package:pluis/models/api_models/product.dart';
import 'package:pluis/models/send_models/payment.dart';

import 'api_models/sku.dart';

class ShoppingCartInfo {
  List<ShoppingCartItem> products;
  String child;
  Coupon coupon;
  String address;
  String phone;
  String email;
  PaymentType payment;

  ShoppingCartInfo(
      {@required this.products,
      this.child,
      this.coupon,
      this.address,
      this.phone,
      this.email,
      this.payment});

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final ShoppingCartInfo otherShoppingCart = other;
    return otherShoppingCart.products == products &&
        child == child &&
        coupon == coupon &&
        address == address &&
        phone == phone &&
        email == email &&
        payment == payment;
  }

  @override
  int get hashCode => products.hashCode;

  static ShoppingCartInfo of(BuildContext context) {
    final ShoppingCartBindingScope scope =
        context.inheritFromWidgetOfExactType(ShoppingCartBindingScope);
    return scope.shoppingCartBindingState.shoppingCart;
  }

  static void update(BuildContext context) {
    final ShoppingCartBindingScope scope =
        context.inheritFromWidgetOfExactType(ShoppingCartBindingScope);
    scope.shoppingCartBindingState
        .updateBalance(scope.shoppingCartBindingState.shoppingCart);
  }
}

class ShoppingCartItem {
  Product product;
  SkuOption skuOption;
  Sku sku;
  int amount;

  ShoppingCartItem({
    @required this.product,
    @required this.skuOption,
    @required this.sku,
    @required this.amount,
  });

  String toJson() {
    return jsonEncode(ShoppingCartItem(
            product: product, skuOption: skuOption, sku: sku, amount: amount)
        .toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "product": this.product,
      "skuOption": this.skuOption,
      "sku": this.sku,
      "amount": this.amount
    };
  }

  ShoppingCartItem.fromJson(Map json)
      : product = Product.fromJson(jsonDecode(json["product"])),
        skuOption = SkuOption.fromJson(jsonDecode(json["skuOption"])),
        sku = Sku.fromJson(jsonDecode(json["sku"])),
        amount = json["amount"];
}

class ShoppingCartBindingScope extends InheritedWidget {
  final _ShoppingCartBindingState shoppingCartBindingState;

  const ShoppingCartBindingScope({
    Key key,
    this.shoppingCartBindingState,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(ShoppingCartBindingScope old) {
    return true;
  }
}

class ShoppingCartBinding extends StatefulWidget {
  final ShoppingCartInfo shoppingCartInfo;
  final Widget child;

  const ShoppingCartBinding({Key key, this.shoppingCartInfo, this.child})
      : super(key: key);

  @override
  _ShoppingCartBindingState createState() => _ShoppingCartBindingState();
}

class _ShoppingCartBindingState extends State<ShoppingCartBinding> {
  ShoppingCartInfo shoppingCart;

  @override
  void initState() {
    super.initState();
    shoppingCart = widget.shoppingCartInfo;
  }

  void updateBalance(ShoppingCartInfo newBalance) {
    setState(() {
      shoppingCart = newBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShoppingCartBindingScope(
      shoppingCartBindingState: this,
      child: widget.child,
    );
  }
}
