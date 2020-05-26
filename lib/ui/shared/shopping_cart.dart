import 'package:flutter/material.dart';
import 'package:pluis/models/api_models/coupon.dart';
import 'package:pluis/models/send_models/payment.dart';
import 'package:pluis/models/shop_iw.dart';

import 'product_tile.dart';

class ShoppingCartUI extends StatefulWidget {
  ShoppingCartUI({Key key, this.bonuses}) : super(key: key);
  List<Coupon> bonuses;

  @override
  _ShoppingCartUIState createState() => _ShoppingCartUIState();
}

class _ShoppingCartUIState extends State<ShoppingCartUI> {
  @override
  Widget build(BuildContext context) {
    var products = ShoppingCartInfo.of(context).products;
    var widgetList = products.map<Widget>((item) {
      return ProductTile(shoppingCartItem: item);
    }).toList()
      ..insert(0, ResumeBox(context: context, bonuses: widget.bonuses));
    return ListView(children: widgetList);
  }
}

class ResumeBox extends StatefulWidget {
  ResumeBox({Key key, @required this.context, this.bonuses}) : super(key: key);
  BuildContext context;
  List<Coupon> bonuses;

  @override
  _ResumeBoxState createState() => _ResumeBoxState();
}

class _ResumeBoxState extends State<ResumeBox> {
  List<ShoppingCartItem> products;
  Map prices;
  String selectedCurrency;
  Coupon bonus;

  var style = TextStyle(fontSize: 11, color: Colors.grey.shade800);
  var styleBono = TextStyle(
      fontSize: 11, color: Colors.grey.shade800, fontWeight: FontWeight.w500);
  var styleTotal =
      TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700);

  calculate(String currency, BuildContext context) {
    products = ShoppingCartInfo.of(context).products;
    prices = Map<String, String>();
    double price = 0;
    switch (currency) {
      case "Cuc":
        if (products.length > 0)
          products
              .forEach((item) => price += item.product.priceCuc * item.amount);
        double cupon = (price * bonus.amount.toDouble() / 100);
        prices["productsPrice"] = "${price.toStringAsFixed(2)} Cuc";
        prices["total"] = "${(price - cupon).toStringAsFixed(2)} Cuc";
        prices["cupon"] = "-${cupon.toStringAsFixed(2)} Cuc";
        break;
      case "Cup":
        if (products.length > 0)
          products
              .forEach((item) => price += item.product.priceCup * item.amount);
        double cupon = (price * bonus.amount / 100);
        prices["productsPrice"] = "${price.toStringAsFixed(2)} Cup";
        prices["total"] = "${(price - cupon).toStringAsFixed(2)} Cup";
        prices["cupon"] = "-${cupon.toStringAsFixed(2)} Cup";
        break;
      case "Usd":
        if (products.length > 0)
          products
              .forEach((item) => price += item.product.priceUsd * item.amount);
        double cupon = (price * bonus.amount / 100);
        prices["productsPrice"] = "${price.toStringAsFixed(2)} Usd";
        prices["total"] = "${(price - cupon).toStringAsFixed(2)} Usd";
        prices["cupon"] = "-${cupon.toStringAsFixed(2)} Usd";
        break;
      default:
    }
  }

  @override
  void initState() {
    selectedCurrency = "Cuc";

    var storedBonus = ShoppingCartInfo.of(widget.context).coupon;
    if (storedBonus == null) {
      bonus = widget.bonuses[0];
    } else {
      bonus = storedBonus;
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      var storedBonus = ShoppingCartInfo.of(widget.context).coupon;
      if (storedBonus == null) {
        ShoppingCartInfo.of(widget.context).coupon = bonus;
        ShoppingCartInfo.of(widget.context).payment = PaymentType();
        ShoppingCartInfo.update(widget.context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    calculate(selectedCurrency, context);
    return Wrap(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 15),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: Colors.grey.shade300,
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    DropdownButton<String>(
                      icon: Icon(Icons.swap_vert),
                      value: selectedCurrency,
                      style: style,
                      iconSize: 15,
                      onChanged: (String newValue) {
                        setState(() {
                          selectedCurrency = newValue;
                          calculate(newValue, context);
                        });
                      },
                      items: <String>['Cuc', 'Usd', 'Cup']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Cupón de descuento",
                      style: styleBono,
                    ),
                    DropdownButton<Coupon>(
                      icon: Icon(Icons.swap_vert),
                      value: bonus,
                      style: styleBono,
                      iconSize: 15,
                      onChanged: (Coupon newValue) {
                        ShoppingCartInfo.of(context).coupon = newValue;
                        ShoppingCartInfo.update(context);
                        setState(() {
                          bonus = newValue;
                        });
                      },
                      items: widget.bonuses
                          .map<DropdownMenuItem<Coupon>>((Coupon value) {
                        return DropdownMenuItem<Coupon>(
                          value: value,
                          child: Text("${value.amount}%"),
                        );
                      }).toList(),
                    )
                  ]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${ShoppingCartInfo.of(context).products.length} Producto(s)",
                        style: style,
                      ),
                      Text(
                        prices["productsPrice"],
                        style: style,
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Cupón de rebaja:",
                        style: style,
                      ),
                      Text(
                        prices["cupon"],
                        style: style,
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("TOTAL", style: styleTotal),
                      Text(prices["total"], style: styleTotal),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
