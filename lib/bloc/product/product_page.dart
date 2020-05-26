import 'package:flutter/material.dart';
import 'package:pluis/models/api_models/product.dart';
import 'package:pluis/ui/shared/app_scaffold.dart';

import 'index.dart';

class ProductPage extends StatelessWidget {
  static const String routeName = "/product";
  final Product product;
  ProductPage( {Key key, @required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productBloc = new ProductBloc(); 
    return AppScaffold(
      child: ProductScreen(productBloc: productBloc,product: product)
    );  
  }
}
