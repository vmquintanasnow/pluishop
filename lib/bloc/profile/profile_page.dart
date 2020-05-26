import 'package:flutter/material.dart';
import 'package:pluis/bloc/home/index.dart';
import 'package:pluis/ui/shared/app_scaffold.dart';

import 'index.dart';

class ProfilePage extends StatelessWidget {
  static const String routeName = "/profile";
  ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: Text("Perfil"),
        leadingAction: () {
          //ProfileBloc().add(LoadProfileEvent());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    homeBloc: HomeBloc(),
                  )));
        },
        actions: <Widget>[],
        child: ProfileScreen(profileBloc: ProfileBloc()));
  }
}
