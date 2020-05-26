import 'package:flutter/material.dart';
import 'package:pluis/ui/shared/app_scaffold.dart';

import 'index.dart';

class OrderPage extends StatelessWidget {
  static const String routeName = "/order";
  OrderPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(child: OrderScreen(orderBloc: OrderBloc()));
  }
}
