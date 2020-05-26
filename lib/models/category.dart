import 'package:flutter/material.dart';
import 'package:pluis/models/api_models/product.dart';
class CategoryItem{
  final int parentId;
  final int id;
  final String image;
  final String name;
  final List<Product> products;

  const CategoryItem({
    this.parentId,
    this.id,
    this.image,
    this.name,
    @required this.products
  });

   
  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'id': id,
      'image': image,
      'name': name,
    };
  }

  static CategoryItem fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return CategoryItem(
      parentId: map['parentId'],
      id: map['id'],
      image: map['image'],
      name: map['name'],
      products: map['products']
    );
  }
}
