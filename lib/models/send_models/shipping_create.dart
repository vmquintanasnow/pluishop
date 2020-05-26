import 'dart:convert';

import 'package:equatable/equatable.dart';

class ShippingCreate extends Equatable {
  int couponId;
  String address;
  String contactPhone;
  String contactEmail;
  int paymentWayId;
  String transactionCode;
  List<CartSend> carts;

  ShippingCreate({
    this.couponId,
    this.address,
    this.contactPhone,
    this.contactEmail,
    this.paymentWayId,
    this.transactionCode,
    this.carts,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> cartsMapped = List();
    carts.forEach((cart) {
      cartsMapped.add(cart.toMap());
    });
    return {
      "coupon_id": couponId,
      "address": address,
      "contact_phone": contactPhone,
      "contact_email": contactEmail,
      "payment_way_id": paymentWayId,
      "transaction_code": transactionCode,
      "carts": cartsMapped
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  // TODO: implement props
  List<Object> get props => [
        couponId,
        address,
        contactPhone,
        contactEmail,
        paymentWayId,
        transactionCode,
        carts
      ];
}

class CartSend extends Equatable {
  final int productId;
  final String size;
  final String color;
  final int quantity;

  CartSend({this.productId, this.size, this.color, this.quantity});
  Map<String, dynamic> toMap() {
    return {
      "product_id": productId,
      "size": size,
      "color": color,
      "quantity": quantity,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  List<Object> get props => [productId, size, color, quantity];
}
