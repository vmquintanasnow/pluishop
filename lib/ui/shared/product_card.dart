import 'package:flutter/material.dart';
import 'package:pluis/models/api_models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key key, @required this.product}) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(children: <Widget>[
        CachedNetworkImage(
            imageUrl: product.image,
            height: 150,
            errorWidget: (context, url, error) => Container(
                  height: 150,
                  constraints: BoxConstraints(minWidth: 70),
                  child:
                      Center(child: Image.asset("assets/images/no_image.png")),
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
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            simplifiedText(product.name.toUpperCase()),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            "${product.priceUsd.toStringAsFixed(2)} USD ${product.priceCuc.toStringAsFixed(2)} Cuc",
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: Colors.green),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text("${product.priceCup.toStringAsFixed(2)} Cup",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.red)),
        ),
      ]),
    );
  }

  String simplifiedText(String text) {
    if (text.length > 35) {
      return text.substring(0, 35) + "...";
    }
    return text;
  }
}
