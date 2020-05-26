class Category {
  String url;
  String name;
  bool parent;
  List<dynamic> children;
  bool active;

  Category({this.url, this.name, this.parent, this.children, this.active});

  Category.fromJson(Map json)
      : url = json["url"],
        name = json["name"],
        parent = json["parent"] is bool ? json["parent"] : true,
        children = json["children"],
        active = json["active"];

  Map<String, dynamic> toMap() {
    return {
      "url": this.url,
      "name": this.name,
      "parent": this.parent,
      "children": this.children,
      "active": this.active
    };
  }
}
