import 'package:flutter/material.dart';
import 'package:pluis/bloc/product/product_page.dart';
import 'package:pluis/models/category.dart';
import 'package:pluis/models/api_models/product.dart';

import 'product_card.dart';

class ProductSliver extends StatefulWidget {
  ProductSliver({Key key, this.categoryItem}) : super(key: key);

  final CategoryItem categoryItem;

  @override
  _ProductSliverState createState() => _ProductSliverState();
}

class _ProductSliverState extends State<ProductSliver> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.70),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  Product product = this.widget.categoryItem.products[index];
                  return GestureDetector(
                    child: ProductCard(
                      product: product,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductPage(
                                product: product,
                              )));
                    },
                  );
                },
                childCount: this.widget.categoryItem.products.length,
              ),
            )
          ],
        ));
  }
}
