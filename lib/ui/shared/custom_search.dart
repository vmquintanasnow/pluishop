import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pluis/bloc/home/index.dart';
import 'package:pluis/bloc/product/index.dart';
import 'package:pluis/models/api_models/product.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({
    String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      inputDecorationTheme:
          InputDecorationTheme(hintStyle: TextStyle(color: Colors.white)),
      textTheme: TextTheme(title: TextStyle(color: Colors.white)),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Los términos de búsqueda deben tener mas de dos letras",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    // InheritedBlocs.of(context).searchBloc.searchTerm.add(query);

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FutureBuilder<List<Product>>(
            future: HomeRepository().findAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.data.length == 0) {
                return Column(
                  children: <Widget>[
                    Text(
                      "No Results Found.",
                    ),
                  ],
                );
              } else {
                var results = snapshot.data
                    .where((a) => a.name.toLowerCase().contains(query))
                    .toList();
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    var result = results[index];
                    return SearchProductTile(
                      product: result,
                    );
                  },
                );
              }
            }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FutureBuilder<List<Product>>(
            future: HomeRepository().findAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              } else if (snapshot.data.length == 0) {
                return Column(
                  children: <Widget>[
                    Text(
                      "No Results Found.",
                    ),
                  ],
                );
              } else {
                var results = snapshot.data
                    .where((a) => a.name.toLowerCase().contains(query))
                    .toList();
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    var result = results[index];
                    return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductPage(
                                    product: result,
                                  )));
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CachedNetworkImage(
                                    imageUrl: result.image,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          height: 50,
                                          width: 50,
                                          constraints:
                                              BoxConstraints(minWidth: 70),
                                          child: Center(
                                              child: Image.asset(
                                                  "assets/images/no_image.png")),
                                        ),
                                    placeholder: (context, url) => Container(
                                          height: 50,
                                          width: 50,
                                          constraints:
                                              BoxConstraints(minWidth: 70),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                            heightFactor: 0.5,
                                            widthFactor: 1,
                                          ),
                                        )),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width /
                                              2),
                                  child: Text(result.name),
                                ),
                                Spacer(),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "USD: ${result.priceUsd.toStringAsFixed(2)}"),
                                      Text(
                                          "CUP: ${result.priceCup.toStringAsFixed(2)}"),
                                      Text(
                                          "CUC: ${result.priceCuc.toStringAsFixed(2)}"),
                                    ],
                                  ),
                                ),
                              ],
                            )));
                  },
                );
              }
            }));
  }
}

class SearchProductTile extends StatelessWidget {
  const SearchProductTile({Key key, this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700);
    return GestureDetector(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: product.image,
                      height: 90,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                            height: 90,
                            constraints: BoxConstraints(minWidth: 70),
                            child: Center(
                                child:
                                    Image.asset("assets/images/no_image.png")),
                          ),
                      placeholder: (context, url) => Container(
                            height: 90,
                            constraints: BoxConstraints(minWidth: 70),
                            child: Center(
                              child: CircularProgressIndicator(),
                              heightFactor: 0.5,
                              widthFactor: 1,
                            ),
                          )),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 5),
                          height: 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width /
                                                2),
                                    child: Text(
                                      product.name.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Spacer(),
                                  Text(
                                      "${product.priceUsd.toStringAsFixed(2)} Usd",
                                      style: style)
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Talla: ${product.getSizes()}",
                                      style: style),
                                  Text(
                                      "${product.priceCuc.toStringAsFixed(2)} Cuc",
                                      style: style)
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Wrap(
                                    children: <Widget>[
                                      Text("Color: ", style: style),
                                      Row(children: product.getColors())
                                    ],
                                  ),
                                  Text(
                                      "${product.priceCup.toStringAsFixed(2)} Cup",
                                      style: style)
                                ],
                              ),
                            ],
                          ))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Divider(
                  thickness: 1,
                ),
              )
            ],
          )),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductPage(
                  product: product,
                )));
      },
    );
  }
}
