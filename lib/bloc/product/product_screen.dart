import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/models/api_models/product.dart';
import 'package:pluis/ui/product_ui.dart';
import 'index.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    Key key,
    @required ProductBloc productBloc,
    @required Product product,
  })  : _productBloc = productBloc,
        _product = product,
        super(key: key);

  final ProductBloc _productBloc;
  final Product _product;

  @override
  ProductScreenState createState() {
    return new ProductScreenState(_productBloc);
  }
}

class ProductScreenState extends State<ProductScreen> {
  final ProductBloc _productBloc;
  static const offsetVisibleThreshold = 50;
  String selectedFilter;

  ProductScreenState(this._productBloc);

  @override
  void initState() {
    super.initState();
    _productBloc.add(LoadProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: BlocBuilder<ProductBloc, ProductState>(
        bloc: widget._productBloc,
        builder: (
          BuildContext context,
          ProductState currentState,
        ) {
          if (currentState is UnProductState) {
            return new Container(
                child: Text(
              "UnProductState",
            ));
          } else if (currentState is ErrorProductState) {
            return new Container(
                child: Text(
              "ErrorProductState",
            ));
          } else if (currentState is NoDataProductState) {
            return Text("NoDataProductState");
          } else if (currentState is InProductState) {
            return ProductUI(
              product: this.widget._product,
            );
          }
          return new Container(
              child: Text(
            "Other",
          ));
        },
      ),
    );
  }
}
