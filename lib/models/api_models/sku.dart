import 'dart:convert';

class Sku {
  String talla;
  List<SkuOption> options;

  Sku({
    this.talla,
    this.options,
  });

  Sku.fromMap(Map json)
      : talla = json["size"],
        options =
            (json["options"].map<SkuOption>((item) => SkuOption.fromJson(item)))
                .toList();
  Sku.fromJson(Map json)
      : talla = json["talla"],
        options = (json["url"]
                .map<SkuOption>((item) => SkuOption.fromJson(jsonDecode(item))))
            .toList();

  Map<String, dynamic> toMap() {
    return {"talla": this.talla, "url": this.options};
  }

  String toJson() {
    return jsonEncode(Sku(options: options, talla: talla).toMap());
  }
}

class SkuOption {
  String color;
  int quantity;
  bool limitedEdition;

  SkuOption({this.color, this.quantity, this.limitedEdition});

  SkuOption.fromJson(Map json)
      : color = json["color"],
        limitedEdition = json["limited_edition"],
        quantity = json["quantity"];

  Map<String, dynamic> toMap() {
    return {
      "color": this.color,
      "quantity": this.quantity,
      "limited_edition": this.limitedEdition
    };
  }

  String toJson() {
    return jsonEncode(SkuOption(
            color: color, quantity: quantity, limitedEdition: limitedEdition)
        .toMap());
  }
}
