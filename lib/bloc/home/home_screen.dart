import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/models/category.dart';
import 'package:pluis/ui/home.dart';
import 'package:pluis/ui/shared/app_main_scaffold.dart';
import 'index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
    @required HomeBloc homeBloc,
  })  : _homeBloc = homeBloc,
        super(key: key);

  final HomeBloc _homeBloc;

  @override
  HomeScreenState createState() {
    return new HomeScreenState(_homeBloc);
  }
}

class HomeScreenState extends State<HomeScreen> {
  final HomeBloc _homeBloc;
  static const offsetVisibleThreshold = 50;
  String selectedFilter;

  HomeScreenState(this._homeBloc);

  @override
  void initState() {
    super.initState();
    _homeBloc.add(LoadHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: widget._homeBloc,
        builder: (
          BuildContext context,
          HomeState currentState,
        ) {
          if (currentState is UnHomeState) {
            print(currentState);
            return HomePageUICharging();
          } else if (currentState is ErrorHomeState) {
            print(currentState);
            return Container(
                child: Text(
              "ErrorHomeState",
            ));
          } else if (currentState is NoDataHomeState) {
            print(currentState);
            return Text("NoDataHomeState");
          } else if (currentState is InHomeState) {
            print(currentState);
            var bannerImages = <String>[
              'assets/images/hombre.jpg',
              'assets/images/mujer.jpg',
              'assets/images/s3.jpg',
              'assets/images/s4.jpg'
            ];

            List<CategoryItem> categories = <CategoryItem>[
              CategoryItem(
                  name: "Todos",
                  image: "assets/images/hombre.jpg",
                  products: currentState.products)
            ];
            currentState.categories.forEach((itemCategory) {
              categories.add(CategoryItem(
                  products: currentState.products.where((itemProduct) {
                    String category = itemProduct.category["name"];
                    if (category.contains(itemCategory.name)) {
                      return true;
                    }
                    return false;
                  }).toList(),
                  name: itemCategory.name,
                  image: "assets/images/zapato.jpg"));
            });
            return HomePageUI(
              categories: categories,
              bannerImages: bannerImages,
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
