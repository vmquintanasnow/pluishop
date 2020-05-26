import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pluis/models/api_models/related_product.dart';
import 'package:pluis/models/api_models/sku.dart';

class Product {
  String name;
  String url;
  bool limitedEdition;
  bool inProduction;
  bool highlight;
  double priceCuc;
  double priceCup;
  double priceUsd;
  bool abstract;
  Map category;
  String image;
  List<dynamic> gallery;
  List<Sku> sku;
  List<RelatedProduct> relatedProducts;
  String description;
  bool active;

  Product(
      {this.name,
      this.url,
      this.limitedEdition,
      this.inProduction,
      this.highlight,
      this.priceCuc,
      this.priceCup,
      this.priceUsd,
      this.abstract,
      this.category,
      this.image,
      this.gallery,
      this.sku,
      this.relatedProducts,
      this.description,
      this.active});

  Product.fromJson(Map json)
      : name = json["name"],
        url = json["url"],
        limitedEdition = json["limited_edition"],
        inProduction = json["in_production"],
        highlight = json["highlight"],
        priceCuc = json["price_cuc"].toDouble(),
        priceCup = json["price_cup"].toDouble(),
        priceUsd = json["price_usd"].toDouble(),
        abstract = json["abstract"],
        category = json["category"],
        image = json["image"],
        gallery = json["gallery"],
        sku = (json["sku"].map<Sku>((item) => Sku.fromJson(jsonDecode(item))))
            .toList(),
        relatedProducts = (json["related_products"].map<RelatedProduct>(
                (item) => RelatedProduct.fromJson(jsonDecode(item))))
            .toList(),
        description = json["description"],
        active = json["active"];

  Product.fromMap(Map json)
      : name = json["name"],
        url = json["url"],
        limitedEdition = json["limited_edition"],
        inProduction = json["in_production"],
        highlight = json["highlight"],
        priceCuc = json["price_cuc"].toDouble(),
        priceCup = json["price_cup"].toDouble(),
        priceUsd = json["price_usd"].toDouble(),
        abstract = json["abstract"],
        category = json["category"],
        image = json["image"],
        gallery = json["gallery"],
        sku = (json["sku"].map<Sku>((item) => Sku.fromMap(item))).toList(),
        relatedProducts = (json["related_products"]
                .map<RelatedProduct>((item) => RelatedProduct.fromJson(item)))
            .toList(),
        description = json["description"] == false ? "" : json["description"],
        active = json["active"];

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "url": this.url,
      "limited_edition": this.limitedEdition,
      "in_production": this.inProduction,
      "highlight": this.highlight,
      "price_cuc": this.priceCuc,
      "price_cup": this.priceCup,
      "price_usd": this.priceUsd,
      "abstract": this.abstract,
      "category": this.category,
      "image": this.image,
      "gallery": this.gallery,
      "sku": this.sku,
      "related_products": this.relatedProducts,
      "description": this.description,
      "active": this.active,
    };
  }

  String toJson() {
    return jsonEncode(Product(
            name: name,
            url: url,
            limitedEdition: limitedEdition,
            inProduction: inProduction,
            highlight: highlight,
            priceCuc: priceCuc,
            priceCup: priceCup,
            priceUsd: priceUsd,
            abstract: abstract,
            category: category,
            image: image,
            gallery: gallery,
            sku: sku,
            relatedProducts: relatedProducts,
            description: description,
            active: active)
        .toMap());
  }

  String getSizes() {
    var result = "";
    sku.forEach((i) {
      result += "${i.talla} ";
    });
    return result.trim();
  }

  List<Widget> getColors() {
    var colors = <Widget>[];
    sku.forEach((i) {
      colors.addAll(i.options.map<Widget>((f) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            height: 13,
            width: 13,
            color: getColorFromHex(f).withOpacity(1),
          )));
    });
    return colors;
  }

  Color getColorFromHex(SkuOption option) {
    return Color(int.parse(option.color.replaceFirst("#", ""), radix: 16));
  }

  String getId() {
    return url.split('=')[1];
  }
}
