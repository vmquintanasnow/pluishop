import 'package:flutter/material.dart';
import 'package:pluis/models/category.dart';
import 'package:pluis/ui/shared/app_scaffold.dart';

import 'index.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = "/category";
  CategoryPage({Key key, this.categoryItem}) : super(key: key);

  CategoryItem categoryItem;

  @override
  Widget build(BuildContext context) {
    var categoryBloc = new CategoryBloc();
    return CategoryScreen(
        categoryBloc: categoryBloc, categoryitem: categoryItem);
  }
}
