import 'coupon.dart';

class Shipping {
  String url;
  int id;
  bool delivered_at;
  String status;
  String messenger_name;
  int messenger_task;
  Coupon coupon;
  DeliverySettings delivery_settings;
  PaymentWay payment_way;
  bool is_payed;
  List<CartShipping> carts;
  double amount_cup;
  double amount_cuc;
  double amount_usd;

  Shipping(
      {this.url,
      this.id,
      this.delivered_at,
      this.status,
      this.messenger_name,
      this.messenger_task,
      this.coupon,
      this.delivery_settings,
      this.payment_way,
      this.is_payed,
      this.carts,
      this.amount_cup,
      this.amount_cuc,
      this.amount_usd});

  Shipping.fromJson(Map json)
      : id = json["id"],
        url = json["url"],
        delivered_at = json["delivered_at"],
        status = json["status"],
        messenger_name =
            json["messenger_name"] == false ? "" : json["messenger_name"],
        messenger_task = json["messenger_task"],
        is_payed = json["is_payed"],
        amount_cup = double.parse("${json["amount_cup"]}"),
        amount_cuc = double.parse("${json["amount_cuc"]}"),
        amount_usd = double.parse("${json["amount_usd"]}"),
        coupon = Coupon.fromJson(json["coupon"]),
        delivery_settings =
            DeliverySettings.fromJson(json["delivery_settings"]),
        payment_way = PaymentWay.fromJson(json["payment_way"]),
        carts = (json["carts"]
                .map<CartShipping>((item) => CartShipping.fromJson(item)))
            .toList();
}

class CartShipping {
  String url;
  String image;
  String name;
  String color;
  String size;
  int quantity;
  double price_cup;
  double price_cuc;
  double price_usd;

  CartShipping(
      {this.url,
      this.image,
      this.name,
      this.color,
      this.size,
      this.quantity,
      this.price_cup,
      this.price_cuc,
      this.price_usd});

  CartShipping.fromJson(Map json)
      : url = json["url"],
        image = json["image"],
        name = json["name"],
        color = json["color"],
        size = json["size"],
        quantity = json["quantity"],
        price_cup = json["price_cup"].toDouble(),
        price_cuc = json["price_cuc"].toDouble(),
        price_usd = json["price_usd"].toDouble();
}

class DeliverySettings {
  String address;
  String contact_phone;
  dynamic contact_phone2;
  String contact_email;

  DeliverySettings(
      {this.address,
      this.contact_phone,
      this.contact_phone2,
      this.contact_email});

  DeliverySettings.fromJson(Map json)
      : address = json["address"],
        contact_phone = json["contact_phone"],
        contact_phone2 = json["contact_phone2"],
        contact_email = json["contact_email"];
}

class PaymentWay {
  String url;
  String name;
  bool has_account;

  PaymentWay({this.url, this.name, this.has_account});

  PaymentWay.fromJson(Map json)
      : url = json["url"],
        name = json["name"],
        has_account = json["has_account"];
}
