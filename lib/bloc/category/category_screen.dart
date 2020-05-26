import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/models/category.dart';
import 'package:pluis/models/api_models/product.dart';
import 'package:pluis/ui/categrory_ui.dart';
import 'index.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    Key key,
    @required CategoryBloc categoryBloc,
    @required CategoryItem categoryitem,
  })  : _categoryBloc = categoryBloc,
        _categoryItem = categoryitem,
        super(key: key);

  final CategoryBloc _categoryBloc;
  final CategoryItem _categoryItem;

  @override
  CategoryScreenState createState() {
    return new CategoryScreenState(_categoryBloc);
  }
}

class CategoryScreenState extends State<CategoryScreen> {
  final CategoryBloc _categoryBloc;
  static const offsetVisibleThreshold = 50;
  String selectedFilter;

  CategoryScreenState(this._categoryBloc);

  @override
  void initState() {
    super.initState();
    _categoryBloc.add(LoadCategoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        bloc: widget._categoryBloc,
        builder: (
          BuildContext context,
          CategoryState currentState,
        ) {
          if (currentState is UnCategoryState) {
            return new Container(
                child: Text(
              "UnCategoryState",
            ));
          } else if (currentState is ErrorCategoryState) {
            return new Container(
                child: Text(
              "ErrorCategoryState",
            ));
          } else if (currentState is NoDataCategoryState) {
            return Text("NoDataCategoryState");
          } else if (currentState is InCategoryState) {
            var products = <Product>[
              Product(
                  image: "assets/images/mujer.jpg",
                  name: "Mujer",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/mujer.jpg",
                  name: "Mujer",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/mujer.jpg",
                  name: "Mujer",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/hombre.jpg",
                  name: "Abrigo de estrucutra cuadrada a rayas",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/hombre.jpg",
                  name: "Parka Combinado",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/hombre.jpg",
                  name: "Abrigo combinaod desmangado",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/hombre.jpg",
                  name: "Abrigo sastre cuadros",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/hombre.jpg",
                  name: "Abrigo de estrucutra cuadrada a rayas",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/hombre.jpg",
                  name: "Parka Combinado",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/hombre.jpg",
                  name: "Abrigo combinaod desmangado",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/hombre.jpg",
                  name: "Abrigo sastre cuadros",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/nino.jpg",
                  name: "niño",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/nino.jpg",
                  name: "niño",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5),
              Product(
                  image: "assets/images/nino.jpg",
                  name: "niño",
                  priceUsd: 10.5,
                  priceCuc: 12.5,
                  priceCup: 312.5)
            ];
            var categories = <CategoryItem>[
              CategoryItem(name: "Pullover", products: products),
              CategoryItem(name: "Zapatos", products: products),
              CategoryItem(name: "Pantalon", products: products),
            ];
            return CategoryUI(
              mainCategory: this.widget._categoryItem,
              categoryItems: categories,
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
