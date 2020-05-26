import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/bloc/order/index.dart';
import 'package:pluis/ui/shopping_stepper.dart';
import 'index.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen(
      {Key key,
      @required ShoppingCartBloc shoppingCartBloc,
      @required this.context})
      : _shoppingCartBloc = shoppingCartBloc,
        super(key: key);

  final ShoppingCartBloc _shoppingCartBloc;
  final BuildContext context;

  @override
  ShoppingCartScreenState createState() {
    return new ShoppingCartScreenState(_shoppingCartBloc);
  }
}

class ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final ShoppingCartBloc _shoppingCartBloc;
  static const offsetVisibleThreshold = 50;
  String selectedFilter;

  ShoppingCartScreenState(this._shoppingCartBloc);

  @override
  void initState() {
    super.initState();
    _shoppingCartBloc.add(LoadShoppingCartEvent(context: widget.context));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
        bloc: widget._shoppingCartBloc,
        builder: (
          BuildContext context,
          ShoppingCartState currentState,
        ) {
          if (currentState is UnShoppingCartState) {
            return new Container(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          } else if (currentState is ErrorShoppingCartState) {
            return new Container(
                child: Text(
              "${currentState.errorMessage}",
            ));
          } else if (currentState is NoDataShoppingCartState) {
            return Text("NoDataShoppingCartState");
          } else if (currentState is InShoppingCartState) {
            return ShoppingStepper(
              bonuses: currentState.bonuses,
              payment: currentState.payment,
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
