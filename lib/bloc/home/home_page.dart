import 'package:flutter/material.dart';

import 'index.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    var homeBloc = new HomeBloc();
    return HomeScreen(homeBloc: homeBloc);     
  }
}
