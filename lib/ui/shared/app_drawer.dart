import 'package:flutter/material.dart';
import 'package:pluis/bloc/change_pass/change_pass_page.dart';
import 'package:pluis/bloc/login/index.dart';
import 'package:pluis/bloc/order/index.dart';
import 'package:pluis/bloc/profile/index.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key key, this.activeRoute}) : super(key: key);

  final String activeRoute;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Map userData = Map();

  Future<Map> getUserData() async {
    Map map = {};
    map['username'] = await SharedPreferencesController.getPrefUsername();
    map['fullname'] = await SharedPreferencesController.getPrefFullname();
    map['avatar'] = await SharedPreferencesController.getPrefAvatarUrl();
    return map;
  }

  @override
  void initState() {
    super.initState();
    getUserData().then((value) => setState(() {
          userData = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SafeArea(
            child: Column(
      children: <Widget>[
        userData.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text("Pluis Shop",
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)))
            : ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(userData['avatar']),
                ),
                title: Text(userData["fullname"]),
                subtitle: Text("@${userData["username"]}"),
              ),
        FlatButton(
          child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Perfil"),
            contentPadding: const EdgeInsets.all(0),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProfilePage();
            }));
          },
        ),
        /* FlatButton(
          child: ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text("Cambiar contraseña"),
            contentPadding: const EdgeInsets.all(0),
          ),
          onPressed:() {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ChangePassPage();
                  }));
                },
        ),*/
        FlatButton(
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Cerrar sesión"),
            contentPadding: const EdgeInsets.all(0),
          ),
          onPressed: () {
            LoginBloc().add(LogoutLoginEvent());
          },
        ),
        Divider(),
        FlatButton(
          child: ListTile(
            leading: Icon(Icons.assignment),
            title: Text("Seguimiento"),
            contentPadding: const EdgeInsets.all(0),
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => OrderPage()));
          },
        ),
      ],
    )));
  }
}
