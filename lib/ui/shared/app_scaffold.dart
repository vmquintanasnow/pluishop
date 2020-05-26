import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pluis/bloc/shopping_cart.dart/index.dart';
import 'package:pluis/models/shop_iw.dart';

import 'app_drawer.dart';
import 'custom_search.dart';

class AppScaffold extends StatefulWidget {
  final AppDrawer appDrawer;
  final Widget child;
  final PreferredSizeWidget bottom;
  final List<Widget> actions;
  final Widget title;
  final bool hideBackButton;
  final bool activeChart;
  final bool resizeToAvoidBottomPadding;
  final Function leadingAction;
  final Widget flexibleSpace;

  const AppScaffold(
      {Key key,
      this.appDrawer,
      @required this.child,
      this.bottom,
      this.actions,
      this.title,
      this.hideBackButton = false,
      this.activeChart = true,
      this.resizeToAvoidBottomPadding = true,
      this.leadingAction,
      this.flexibleSpace})
      : super(key: key);

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      drawer: this.widget.appDrawer,
      appBar: AppBar(
          leading: widget.leadingAction != null
              ? InkWell(
                  child: Icon(Icons.arrow_back),
                  onTap: widget.leadingAction,
                )
              : null,
          actions: this.widget.actions != null
              ? this.widget.actions
              : <Widget>[shoppingCart()],
          centerTitle: true,
          title: this.widget.title != null ? this.widget.title : title(),
          bottom: this.widget.bottom),
      body: this.widget.child,
      resizeToAvoidBottomPadding: this.widget.resizeToAvoidBottomPadding,
    );
  }

  Widget shoppingCart() {
    int shoppingCartCount = ShoppingCartInfo.of(context).products.length;
    return GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.shopping_cart, color: Theme.of(context).accentColor),
            shoppingCartCount > 0
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      "$shoppingCartCount",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ))
                : Container(
                    padding: const EdgeInsets.only(right: 10),
                  )
          ],
        ),
        onTap: () async {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ShoppingCartPage()));
        });
  }

  Widget title() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Buscar',
            contentPadding: EdgeInsets.all(12.0),
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.0),
                borderSide: BorderSide.none)),
        onTap: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(hintText: "Buscar"),
          );
        },
      ),
    );
  }
}
