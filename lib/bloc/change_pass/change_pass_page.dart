import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/bloc/home/index.dart';
import 'package:pluis/resources/sharedPreferencesController.dart';
import 'package:pluis/ui/shared/app_scaffold.dart';

import 'index.dart';

class ChangePassPage extends StatelessWidget {
  static const String routeName = "/changePass";
  ChangePassPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: Text("Perfil"),
        leadingAction: () {
          ChangePassBloc().add(LoadChangePassEvent());
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    homeBloc: HomeBloc(),
                  )));
        },
        child: ChangePassScreen(changePassBloc: ChangePassBloc()));
  }
}

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({
    Key key,
    @required ChangePassBloc changePassBloc,
  })  : _changePassBloc = changePassBloc,
        super(key: key);

  final ChangePassBloc _changePassBloc;

  @override
  ChangePassScreenState createState() {
    return new ChangePassScreenState(_changePassBloc);
  }
}

class ChangePassScreenState extends State<ChangePassScreen> {
  final ChangePassBloc _changePassBloc;
  static const offsetVisibleThreshold = 50;
  String selectedFilter;

  ChangePassScreenState(this._changePassBloc);

  @override
  void initState() {
    super.initState();
    _changePassBloc.add(LoadChangePassEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ChangePassBloc, ChangePassState>(
        bloc: widget._changePassBloc,
        builder: (
          BuildContext context,
          ChangePassState currentState,
        ) {
          if (currentState is UnChangePassState) {
            print(currentState);
            return Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            );
          } else if (currentState is ErrorChangePassState) {
            print(currentState);
            return ChagePass(
              userName: currentState.userName,
              avatar: currentState.avatar,
              error: currentState.error,
              pass: currentState.pass,
              newPass: currentState.newPass,
              key: ValueKey(currentState.hashCode),
            );
          } else if (currentState is InChangePassState) {
            print(currentState);
            return ChagePass(
              userName: currentState.userName,
              avatar: currentState.avatar,
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

class ChagePass extends StatefulWidget {
  String userName;
  String avatar;
  String error;
  String pass;
  String newPass;

  ChagePass(
      {Key key,
      this.userName = "",
      this.avatar = "",
      this.pass = "",
      this.newPass = "",
      this.error = ""})
      : super(key: key);

  @override
  _ChagePassState createState() => _ChagePassState();
}

class _ChagePassState extends State<ChagePass> {
  String pass;
  String newPass;
  String error;
  bool loading;
  GlobalKey<FormState> key = new GlobalKey();
  TextEditingController controllerPass = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerPass.text = widget.newPass;
    pass = widget.pass;
    //
    newPass = widget.newPass;
    error = widget.error;
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.avatar),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  widget.userName,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Cambiar contraseña",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                      key: key,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(color: Colors.grey),
                            initialValue: pass,
                            decoration: InputDecoration(
                                labelText: "Contraseña actual",
                                labelStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2))),
                            // keyboardType: TextInputType.emailAddress,
                            obscureText: true,
                            onSaved: (value) {
                              setState(() {
                                pass = value;
                              });
                            },
                          ),
                          TextFormField(
                            key: ValueKey("passwordField"),
                            style: TextStyle(color: Colors.grey),
                            controller: controllerPass,
                            decoration: InputDecoration(
                                labelText: "Nueva contraseña",
                                labelStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2))),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Campo obligatorio";
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                newPass = value;
                              });
                            },
                          ),
                          TextFormField(
                            key: ValueKey("repeatpasswordField"),
                            style: TextStyle(color: Colors.grey),
                            decoration: InputDecoration(
                                labelText: "Repetir nueva contraseña",
                                labelStyle:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2))),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Campo obligatorio";
                              else if (controllerPass.text != value) {
                                return "Deben coincidir las contraseñas";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                pass = value;
                              });
                            },
                          ),
                          if (error != null && !error.isEmpty)
                            Container(
                              padding: const EdgeInsets.only(top: 20.0),
                              height: 90,
                              child: Text(
                                error,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  shape: StadiumBorder(),
                                  elevation: 0.0,
                                  color: Colors.grey.shade300,
                                  child: Text("Cancelar"),
                                ),
                                RaisedButton(
                                  key: ValueKey("signinButton"),
                                  onPressed: () {
                                    if (!loading &&
                                        key.currentState.validate()) {
                                      key.currentState.save();
                                      if (!loading &&
                                          key.currentState.validate()) {
                                        key.currentState.save();
                                        ChangePassBloc().add(
                                            ProcessChangePassEvent(
                                                pass: pass,
                                                newPass: newPass,
                                                context: context));
                                        setState(() {
                                          loading = true;
                                        });
                                      }
                                      setState(() {
                                        loading = true;
                                      });
                                    }
                                  },
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  shape: StadiumBorder(),
                                  elevation: 0.0,
                                  color: Theme.of(context).accentColor,
                                  child: loading
                                      ? Container(
                                          height: 30,
                                          width: 30,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Text("Cambiar",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
