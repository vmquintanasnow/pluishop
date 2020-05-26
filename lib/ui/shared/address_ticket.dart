import 'package:flutter/material.dart';
import 'package:pluis/models/shop_iw.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';
import 'package:pluis/ui/shopping_stepper.dart';

import 'dashed_divider.dart';

class AddressTicket extends StatefulWidget {
  AddressTicket({Key key, @required this.formKey, this.autoValidate})
      : super(key: key);
  GlobalKey<FormState> formKey;
  bool autoValidate;

  @override
  _AddressTicketState createState() => _AddressTicketState();
}

class _AddressTicketState extends State<AddressTicket> {
  FocusNode address, phone1, phone2, email;
  List<ShoppingCartItem> products;
  double cuc, cup, usd;
  Map<dynamic, dynamic> deliveryInfo;

  calculate(BuildContext context) {
    products = ShoppingCartInfo.of(context).products;
    double bonus = ShoppingCartInfo.of(context).coupon.amount / 100;
    if (products.length > 0) {
      products.forEach((item) => cuc += item.product.priceCuc * item.amount);
      products.forEach((item) => cup += item.product.priceCup * item.amount);
      products.forEach((item) => usd += item.product.priceUsd * item.amount);
    }
    cuc -= bonus * cuc;
    cup -= bonus * cup;
    usd -= bonus * usd;
  }

  Future<Map<dynamic, dynamic>> getDeliveryInfo() async {
    Map map = Map();
    map['address'] = await SharedPreferencesController.getPrefAddress();
    map['cellPhone'] = await SharedPreferencesController.getPrefCellPhone();
    map['fixedPhone'] = await SharedPreferencesController.getPrefFixedPhone();
    map['email'] = await SharedPreferencesController.getPrefEmail();
    return map;
  }

  @override
  void initState() {
    super.initState();
    cuc = 0;
    cup = 0;
    usd = 0;
    address = FocusNode();
    phone1 = FocusNode();
    phone2 = FocusNode();
    email = FocusNode();
    //calculate();
    getDeliveryInfo().then((value) => setState(() {
          deliveryInfo = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (deliveryInfo != null) {
      calculate(context);
      return Form(
          key: widget.formKey,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey)),
              child: Column(
                children: <Widget>[
                  Text(
                    "INFORMACIÓN DE ENTREGA",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Información a almacenada en el perfil de usuario",
                    style: TextStyle(fontSize: 10),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DashedDivider()),
                  Container(
                    constraints: BoxConstraints(minHeight: 30),
                    width: MediaQuery.of(context).size.width * .75,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    child: TextFormField(
                      initialValue: deliveryInfo["address"],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      decoration: InputDecoration(
                          hintText: "Dirección",
                          contentPadding: EdgeInsets.only(top: 8),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      autovalidate: widget.autoValidate,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Campo obligatorio";
                        }
                        return null;
                      },
                      focusNode: address,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(phone1);
                      },
                      onSaved: (value) {
                        // await SharedPreferencesController.setPrefAddress(value);
                        ShoppingCartInfo.of(context).address = value;
                        ShoppingCartInfo.update(context);
                      },
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(minHeight: 30),
                    width: MediaQuery.of(context).size.width * .75,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    child: TextFormField(
                      initialValue: deliveryInfo["cellPhone"],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      decoration: InputDecoration(
                          hintText: "Teléfono",
                          contentPadding: EdgeInsets.only(top: 8),
                          border: InputBorder.none),
                      keyboardType: TextInputType.phone,
                      autovalidate: widget.autoValidate,
                      validator: (value) {
                        var numberExp = RegExp(r'^[0-9]{8}$');
                        if (value.isEmpty) {
                          return "Campo obligatorio";
                        } else if (!numberExp.hasMatch(value) &&
                            value.isNotEmpty) {
                          return "Numero de télefono inválido";
                        }
                        return null;
                      },
                      focusNode: phone1,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(email);
                      },
                      onSaved: (value) {
                        // await SharedPreferencesController.setPrefCellPhone(
                        //     value);
                        ShoppingCartInfo.of(context).phone = value;
                        ShoppingCartInfo.update(context);
                      },
                    ),
                  ),
                  // Container(
                  //   constraints: BoxConstraints(minHeight: 30),
                  //   width: MediaQuery.of(context).size.width * .75,
                  //   margin:
                  //       const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  //   padding: const EdgeInsets.only(left: 10),
                  //   decoration: BoxDecoration(
                  //       border: Border.all(width: 0.5, color: Colors.grey)),
                  //   child: TextFormField(
                  //     initialValue: deliveryInfo["fixedPhone"],
                  //     style: TextStyle(fontSize: 12, color: Colors.grey),
                  //     decoration: InputDecoration(
                  //         hintText: "Teléfono 2",
                  //         contentPadding: EdgeInsets.only(top: 8),
                  //         border: InputBorder.none),
                  //     keyboardType: TextInputType.phone,
                  //     autovalidate: widget.autoValidate,
                  //     validator: (value) {
                  //       var numberExp = RegExp(r'^[0-9]{8}$');

                  //       if (!numberExp.hasMatch(value) && value.isNotEmpty)
                  //         return "Numero de télefono inválido";
                  //       return null;
                  //     },
                  //     focusNode: phone2,
                  //     onFieldSubmitted: (term) {
                  //       FocusScope.of(context).requestFocus(email);
                  //     },
                  //     onSaved: (value) async {
                  //       await SharedPreferencesController.setPrefFixedPhone(
                  //           value);
                  //     },
                  //   ),
                  // ),
                  Container(
                    constraints: BoxConstraints(minHeight: 30),
                    width: MediaQuery.of(context).size.width * .75,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.grey)),
                    child: TextFormField(
                      initialValue: deliveryInfo["email"],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      decoration: InputDecoration(
                          hintText: "Correo",
                          contentPadding: EdgeInsets.only(top: 8),
                          border: InputBorder.none),
                      keyboardType: TextInputType.emailAddress,
                      autovalidate: widget.autoValidate,
                      validator: (value) {
                        var emailExp = RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (value.isEmpty)
                          return "Campo obligatorio";
                        else if (!emailExp.hasMatch(value) && value.isNotEmpty)
                          return "Correo inválido";
                        return null;
                      },
                      focusNode: email,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).unfocus();
                      },
                      onSaved: (value) {
                        //await SharedPreferencesController.setPrefEmail(value);
                        ShoppingCartInfo.of(context).email = value;
                        ShoppingCartInfo.update(context);
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DashedDivider()),
                  Container(
                    width: MediaQuery.of(context).size.width * .75,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total:",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "${cuc.toStringAsFixed(2)} CUC",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${usd.toStringAsFixed(2)} USD",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${cup.toStringAsFixed(2)} CUP",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )));
    } else {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration:
              BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey)),
          child: Column(children: <Widget>[
            Text(
              "INFORMACIÓN DE ENTREGA",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              "Información a almacenada en el perfil de usuario",
              style: TextStyle(fontSize: 10),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DashedDivider()),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CircularProgressIndicator())
          ]));
    }
  }
}
