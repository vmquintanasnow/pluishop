import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';
import 'package:pluis/models/api_models/dio_helper.dart';
import 'package:pluis/models/api_models/product.dart';
import 'package:pluis/models/api_models/related_product.dart';
import 'package:pluis/models/api_models/sku.dart';
import 'package:pluis/models/shop_iw.dart';

class ProductUI extends StatefulWidget {
  ProductUI({Key key, @required this.product}) : super(key: key);
  final Product product;

  @override
  _ProductUIState createState() => _ProductUIState();
}

class _ProductUIState extends State<ProductUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          PinchZoomImage(
            image: CachedNetworkImage(
                imageUrl: this.widget.product.image,
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                      height: 150,
                      constraints: BoxConstraints(minWidth: 70),
                      child: Center(
                          child: Image.asset("assets/images/no_image.png")),
                    ),
                placeholder: (context, url) => Container(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(),
                        heightFactor: 0.5,
                        widthFactor: 1,
                      ),
                    )),
            zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
            hideStatusBarWhileZooming: true,
            onZoomStart: () {
              print('Zoom started');
            },
            onZoomEnd: () {
              print('Zoom finished');
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
                child: Text(
              this.widget.product.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              textAlign: TextAlign.center,
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "${this.widget.product.priceUsd.toStringAsFixed(2)} Usd ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "${this.widget.product.priceCuc.toStringAsFixed(2)} Cuc ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "${this.widget.product.priceCup.toStringAsFixed(2)} Cup ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: OutlineButton(
                child: Text("AÑADIR"),
                borderSide: BorderSide(width: 0.5),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                      ),
                      builder: (context) {
                        return BuySheet(
                          product: widget.product,
                        );
                      });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              widget.product.description,
              textAlign: TextAlign.justify,
            ),
          ),
          widget.product.relatedProducts.length > 0
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text("COMPLEMENTAR LOOK",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                )
              : Container(),
          ComplementProduct(product: widget.product),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Center(
                child: Text(
                    "Pluis Shop 2019. All right reserved. Powered by Snow",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 10))),
          ),
        ],
      ),
    );
  }
}

class BuySheet extends StatefulWidget {
  BuySheet({Key key, @required this.product}) : super(key: key);
  final Product product;

  @override
  _BuySheetState createState() => _BuySheetState();
}

class _BuySheetState extends State<BuySheet> with TickerProviderStateMixin {
  String size;
  int amount;
  List<RadioModel> options;
  Map<String, List<RadioModel>> map;
  Sku sku;
  SkuOption optionSelected;

  List<RadioModel> colorsFromSku(Sku _sku) {
    var colors = _sku.options;
    var result = colors
        .map<RadioModel>((item) => RadioModel(false, item,
            controller: AnimationController(
                vsync: this, value: 1, duration: Duration(milliseconds: 500))
              ..addListener(() {
                setState(() {});
              })))
        .toList();
    result.first.controller.value = 0;
    result.first.isSelected = true;
    return result;
  }

  colorsMap() {
    map = Map();
    widget.product.sku.forEach((item) {
      map[item.talla] = colorsFromSku(item);
    });
  }

  @override
  void initState() {
    amount = 1;
    sku = widget.product.sku.first;
    size = sku.talla;
    colorsMap();
    options = map[sku.talla];
    optionSelected = options.first.option;
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
              this.widget.product.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              textAlign: TextAlign.center,
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "${this.widget.product.priceUsd.toStringAsFixed(2)} Usd ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "${this.widget.product.priceCuc.toStringAsFixed(2)} Cuc ",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "${this.widget.product.priceCup.toStringAsFixed(2)} Cup ",
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
                  child: Text("Talla:",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500))),
              DropdownButton<String>(
                value: size,
                iconSize: 15,
                onChanged: (String newValue) {
                  setState(() {
                    if (size != newValue) {
                      size = newValue;
                      sku = widget.product.sku
                          .singleWhere((item) => item.talla == newValue);
                      options = map[sku.talla];
                      optionSelected = map[sku.talla]
                          .singleWhere((item) => item.isSelected == true)
                          .option;
                    }
                  });
                },
                items: widget.product.sku.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item.talla,
                    child: Text(
                      item.talla,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Spacer(),
          Text("Seleccione el color",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          CustomRadio(
            options: options,
            callBack: (option) {
              setState(() {
                optionSelected = option;
              });
            },
          ),
          Spacer(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      amount--;
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
                      amount++;
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
                try {
                  var product = ShoppingCartItem(
                      product: widget.product,
                      skuOption: optionSelected,
                      sku: sku,
                      amount: amount);
                  var sameProduct = ShoppingCartInfo.of(context)
                      .products
                      .singleWhere(
                          (item) =>
                              item.product == product.product &&
                              item.sku == product.sku &&
                              item.skuOption == product.skuOption,
                          orElse: () => null);
                  if (sameProduct != null) {
                    int index = ShoppingCartInfo.of(context)
                        .products
                        .indexOf(sameProduct);
                    sameProduct.amount += amount;
                    ShoppingCartInfo.of(context).products[index] = sameProduct;
                  } else {
                    ShoppingCartInfo.of(context).products.add(product);
                  }
                  ShoppingCartInfo.update(context);
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                }
              },
              color: Colors.black,
              child: Text(
                "AÑADIR AL CARRITO",
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

typedef SelectSKUCallBack = void Function(SkuOption option);

class CustomRadio extends StatefulWidget {
  final List<RadioModel> options;
  final SelectSKUCallBack callBack;

  CustomRadio({@required this.options, @required this.callBack});

  @override
  createState() {
    return new CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ListView.builder(
        itemCount: widget.options.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              widget.options.forEach((element) => element.controller.forward());
              widget.options[index].controller.reverse();
              setState(() {
                widget.options.forEach((element) => element.isSelected = false);
                widget.options[index].isSelected = true;
                widget.callBack(widget.options[index].option);
              });
            },
            child: new RadioBlock(item: widget.options[index]),
          );
        },
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  SkuOption option;
  AnimationController controller;

  RadioModel(this.isSelected, this.option, {this.controller});
}

class RadioBlock extends StatelessWidget {
  const RadioBlock({Key key, this.item}) : super(key: key);
  final RadioModel item;

  Color getColorFromHex(SkuOption option) {
    return Color(int.parse(option.color.replaceFirst("#", ""), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
              height: 40.0,
              width: 40.0,
              decoration: new BoxDecoration(
                color: item.isSelected
                    ? getColorFromHex(item.option).withOpacity(1)
                    : getColorFromHex(item.option).withOpacity(0.3),
                borderRadius: item.isSelected
                    ? BorderRadius.all(
                        Radius.circular(item.controller.value * 20.0))
                    : BorderRadius.all(
                        Radius.circular(item.controller.value * 40.0)),
              ),
              child: item.isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                  : null),
        ],
      ),
    );
  }
}

class ComplementProduct extends StatelessWidget {
  const ComplementProduct({Key key, this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    if (product.relatedProducts.length > 0) {
      return Container(
        height: 280,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: this.product.relatedProducts.length,
          itemBuilder: (context, index) {
            return MiniProductUi(
                relatedProduct: product.relatedProducts[index]);
          },
          scrollDirection: Axis.horizontal,
        ),
      );
    } else {
      return Container();
    }
  }
}

class MiniProductUi extends StatefulWidget {
  MiniProductUi({Key key, this.relatedProduct}) : super(key: key);
  final RelatedProduct relatedProduct;

  @override
  _MiniProductUiState createState() => _MiniProductUiState();
}

class _MiniProductUiState extends State<MiniProductUi> {
  bool charging;

  @override
  void initState() {
    charging = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
              imageUrl: widget.relatedProduct.image,
              height: 180,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                    height: 180,
                    constraints: BoxConstraints(minWidth: 70),
                    child: Center(
                        child: Image.asset("assets/images/no_image.png")),
                  ),
              placeholder: (context, url) => Container(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                      heightFactor: 0.5,
                      widthFactor: 1,
                    ),
                  )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
                child: Text(
              widget.relatedProduct.name.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
              textAlign: TextAlign.center,
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "${widget.relatedProduct.priceUsd.toStringAsFixed(2)} Usd ",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "${widget.relatedProduct.priceCuc.toStringAsFixed(2)} Cuc ",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "${widget.relatedProduct.priceCup.toStringAsFixed(2)} Cup ",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          charging
              ? Container(
                  padding: const EdgeInsets.all(4),
                  child: CircularProgressIndicator())
              : OutlineButton(
                  child: Text("AÑADIR"),
                  onPressed: () async {
                    setState(() {
                      charging = true;
                    });
                    var response = await DioHelper.get(
                        cachedPetition: true, url: widget.relatedProduct.url);
                    var product = Product.fromMap(response.data);
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        builder: (context) {
                          return BuySheet(
                            product: product,
                          );
                        });
                    setState(() {
                      charging = false;
                    });
                  },
                )
        ],
      ),
    );
  }
}
