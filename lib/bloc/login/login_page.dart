import 'package:flutter/material.dart';

import 'index.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = "/login";
  LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginScreen(loginBloc: LoginBloc()));
  }
}
