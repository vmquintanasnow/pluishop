import 'dart:convert';

import 'package:equatable/equatable.dart';

class Coupon extends Equatable {
  String url;
  String key;
  String name;
  bool expireUsing;
  bool isPercent;
  int amount;
  bool used;

  Coupon(
      {this.url,
      this.key,
      this.name,
      this.expireUsing,
      this.isPercent,
      this.amount,
      this.used});

  Coupon.fromJson(Map json)
      : url = json["url"],
        key = json["key"],
        name = json["name"],
        expireUsing = json["expire_using"],
        isPercent = json["is_percent"],
        amount = json["amount"]??json["task"],
        used = json["used"];

  Map<String, dynamic> toMap() {
    return {
      "url": url,
      "key": key,
      "name": name,
      "expire_using": expireUsing,
      "is_percent": isPercent,
      "amount": amount,
      "used": used,
    };
  }

  String toJson() {
    return jsonEncode(Coupon(
            url: url,
            key: key,
            name: name,
            expireUsing: expireUsing,
            isPercent: isPercent,
            amount: amount,
            used: used)
        .toMap());
  }

  String getId() {
    return url.split('=')[1];
  }

  @override
  // TODO: implement props
  List<Object> get props =>
      [url, key, name, expireUsing, isPercent, amount, used];
}
