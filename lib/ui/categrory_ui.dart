import 'package:flutter/material.dart';
import 'package:pluis/models/category.dart';

import 'shared/app_scaffold.dart';
import 'shared/products_sliver.dart';

class CategoryUI extends StatefulWidget {
  CategoryUI(
      {Key key, @required this.categoryItems, @required this.mainCategory})
      : super(key: key);

  final List<CategoryItem> categoryItems;
  final CategoryItem mainCategory;

  @override
  _CategoryUIState createState() => _CategoryUIState();
}

class _CategoryUIState extends State<CategoryUI> with TickerProviderStateMixin {
  TabController controler;
  int currentIndex;
  @override
  void initState() {
    currentIndex = 0;
    controler = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Text(this.widget.mainCategory.name),
      bottom: TabBar(
          controller: controler,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          tabs: this
              .widget
              .categoryItems
              .map((item) => Tab(
                    text: item.name,
                  ))
              .toList()),
      child: buildTabBody(context, this.widget.categoryItems[currentIndex]),
    );
  }

  Widget buildTabBody(BuildContext context, CategoryItem categoryItem) {
    return ProductSliver(
      categoryItem: categoryItem,
    );
  }
}
