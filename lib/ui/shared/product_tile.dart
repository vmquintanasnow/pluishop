import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pluis/models/api_models/sku.dart';
import 'package:pluis/models/shop_iw.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';

import '../product_ui.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({Key key, this.shoppingCartItem}) : super(key: key);
  final ShoppingCartItem shoppingCartItem;

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700);
    return GestureDetector(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: shoppingCartItem.product.image,
                      height: 90,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                            height: 90,
                            constraints: BoxConstraints(minWidth: 70),
                            child: Center(
                                child:
                                    Image.asset("assets/images/no_image.png")),
                          ),
                      placeholder: (context, url) => Container(
                            height: 90,
                            constraints: BoxConstraints(minWidth: 70),
                            child: Center(
                              child: CircularProgressIndicator(),
                              heightFactor: 0.5,
                              widthFactor: 1,
                            ),
                          )),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          height: 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                2),
                                    child: Text(
                                      shoppingCartItem.product.name
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.clear,
                                      size: 18,
                                    ),
                                    onTap: () async{
                                      ShoppingCartItem shoppingItem;
                                      try {
                                        shoppingItem =
                                            ShoppingCartInfo.of(context)
                                                .products
                                                .singleWhere((item) =>
                                                    item.hashCode ==
                                                    shoppingCartItem.hashCode);
                                        if (shoppingItem != null) {
                                          ShoppingCartInfo.of(context)
                                              .products
                                              .remove(shoppingItem);
                                          ShoppingCartInfo.update(context);
                                        }
                                        var products =
                                            ShoppingCartInfo.of(context)
                                                .products;
                                        List<String> productJsons = List();
                                        products.forEach((item) =>
                                            productJsons.add(item.toJson()));
                                        await SharedPreferencesController
                                            .setPrefCart(productJsons);
                                      } catch (e) {
                                        if (e is StateError) {
                                          if (e.message ==
                                              "Too many elements") {
                                            shoppingItem =
                                                ShoppingCartInfo.of(context)
                                                    .products
                                                    .firstWhere((item) =>
                                                        item.product ==
                                                        shoppingCartItem
                                                            .product);
                                            if (shoppingItem != null) {
                                              ShoppingCartInfo.of(context)
                                                  .products
                                                  .remove(shoppingItem);
                                              ShoppingCartInfo.update(context);
                                            }
                                          }
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Cantidad: ${shoppingCartItem.amount}",
                                      style: style),
                                  Text(
                                      "${(shoppingCartItem.product.priceUsd * shoppingCartItem.amount).toStringAsFixed(2)} Usd",
                                      style: style)
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Talla: ${shoppingCartItem.sku.talla}",
                                      style: style),
                                  Text(
                                      "${(shoppingCartItem.product.priceCuc * shoppingCartItem.amount).toStringAsFixed(2)} Cuc",
                                      style: style)
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Wrap(
                                    children: <Widget>[
                                      Text("Color: ", style: style),
                                      Container(
                                        height: 13,
                                        width: 13,
                                        color: getColorFromHex(
                                                shoppingCartItem.skuOption)
                                            .withOpacity(1),
                                      )
                                    ],
                                  ),
                                  Text(
                                      "${(shoppingCartItem.product.priceCup * shoppingCartItem.amount).toStringAsFixed(2)} Cup",
                                      style: style)
                                ],
                              ),
                            ],
                          ))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Divider(
                  thickness: 1,
                ),
              )
            ],
          )),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            builder: (context) {
              return EditBuySheet(shoppingCartItem: shoppingCartItem);
            });
      },
    );
  }

  Color getColorFromHex(SkuOption option) {
    return Color(int.parse(option.color.replaceFirst("#", ""), radix: 16));
  }
}

class EditBuySheet extends StatefulWidget {
  EditBuySheet({
    Key key,
    @required this.shoppingCartItem,
  }) : super(key: key);
  final ShoppingCartItem shoppingCartItem;
  @override
  _EditBuySheetState createState() => _EditBuySheetState();
}

class _EditBuySheetState extends State<EditBuySheet>
    with TickerProviderStateMixin {
  String size;
  int amount;
  Map<String, List<RadioModel>> map;
  Sku sku;
  SkuOption optionSelected;

  @override
  void initState() {
    amount = widget.shoppingCartItem.amount;
    sku = widget.shoppingCartItem.sku;
    size = sku.talla;
    optionSelected = widget.shoppingCartItem.skuOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
                child: Text(
              this.widget.shoppingCartItem.product.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              textAlign: TextAlign.center,
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "${this.widget.shoppingCartItem.product.priceUsd.toStringAsFixed(2)} Usd ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "${this.widget.shoppingCartItem.product.priceCuc.toStringAsFixed(2)} Cuc ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "${this.widget.shoppingCartItem.product.priceCup.toStringAsFixed(2)} Cup ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text("Talla: ${sku.talla}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500))),
            ],
          ),
          Spacer(),
          Text("Color:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 40.0,
              width: 40.0,
              decoration: new BoxDecoration(
                color: Color(int.parse(
                        optionSelected.color.replaceFirst("#", ""),
                        radix: 16))
                    .withOpacity(1),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
              )),
          Spacer(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (amount != 0) amount--;
                    });
                  },
                ),
                Text(
                  "$amount",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (amount < optionSelected.quantity) amount++;
                    });
                  },
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              onPressed: () {
                if (amount > 0) {
                  var product = ShoppingCartItem(
                      product: widget.shoppingCartItem.product,
                      skuOption: optionSelected,
                      sku: sku,
                      amount: amount);
                  var index = ShoppingCartInfo.of(context).products.indexWhere(
                      (index) =>
                          index.hashCode == widget.shoppingCartItem.hashCode);

                  ShoppingCartInfo.of(context).products[index] = product;
                } else {
                  ShoppingCartInfo.of(context).products.removeWhere((item) =>
                      item.hashCode == widget.shoppingCartItem.hashCode);
                }
                ShoppingCartInfo.update(context);
                Navigator.of(context).pop();
              },
              color: Colors.black,
              child: Text(
                "ACTUALIZAR COMPRA",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
