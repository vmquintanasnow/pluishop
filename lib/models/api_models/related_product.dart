import 'dart:convert';

class RelatedProduct {
  String name;
  String url;
  double priceCuc;
  double priceCup;
  double priceUsd;
  String abstract;
  String category;
  String image;

  RelatedProduct({
    this.name,
    this.url,
    this.priceCuc,
    this.priceCup,
    this.priceUsd,
    this.abstract,
    this.category,
    this.image,
  });

  RelatedProduct.fromJson(Map json)
      : name = json["name"],
        url = json["url"],
        priceCuc = json["price_cuc"].toDouble(),
        priceCup = json["price_cup"].toDouble(),
        priceUsd = json["price_usd"].toDouble(),
        abstract = json["abstract"],
        category = json["category"],
        image = json["image"];

  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "url": this.url,
      "price_cuc": this.priceCuc,
      "price_cup": this.priceCup,
      "price_usd": this.priceUsd,
      "abstract": this.abstract,
      "category": this.category,
      "image": this.image,
    };
  }

  String toJson() {
    return jsonEncode(RelatedProduct(
      name: name,
      url: url,
      priceCuc: priceCuc,
      priceCup: priceCup,
      priceUsd: priceUsd,
      abstract: abstract,
      category: category,
      image: image,
    ).toMap());
  }
}
