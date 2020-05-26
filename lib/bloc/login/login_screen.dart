import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/bloc/home/home_page.dart';
import 'package:pluis/models/send_models/register_send.dart';
import 'index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key key,
    @required LoginBloc loginBloc,
  })  : _loginBloc = loginBloc,
        super(key: key);

  final LoginBloc _loginBloc;

  @override
  LoginScreenState createState() {
    return new LoginScreenState(_loginBloc);
  }
}

class LoginScreenState extends State<LoginScreen> {
  final LoginBloc _loginBloc;
  static const offsetVisibleThreshold = 50;
  String selectedFilter;

  LoginScreenState(this._loginBloc);

  @override
  void initState() {
    super.initState();
    _loginBloc.add(LoadLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //constraints: BoxConstraints.expand(),
      child: BlocBuilder<LoginBloc, LoginState>(
        bloc: widget._loginBloc,
        builder: (
          BuildContext context,
          LoginState currentState,
        ) {
          if (currentState is UnLoginState) {
            print(currentState);
            return Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            );
          } else if (currentState is ErrorLoginState) {
            print(currentState);
            return Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(currentState.errorMessage),
              ),
            );
          } else if (currentState is ErrorInLoginState) {
            print(currentState);
            return LoginWidget(
              key: Key(currentState.hashCode.toString()),
              user: currentState.loginSend.username,
              pass: currentState.loginSend.password,
              error: currentState.errorMessage,
            );
          } else if (currentState is NoDataLoginState) {
            print(currentState);
            return Text("NoDataLoginState");
          } else if (currentState is InLoginState) {
            print(currentState);
            return LoginWidget(
              user: "",
              pass: "",
              error: "",
            );
          } else if (currentState is RegisterLoginState) {
            print(currentState);
            return RegisterWidget(
              registerSend: RegisterSend(),
              error: "",
            );
          } else if (currentState is ErrorInRegisterLoginState) {
            print(currentState);
            return RegisterWidget(
              key: Key(currentState.hashCode.toString()),
              registerSend: currentState.registerSend,
              error: currentState.errorMessage,
            );
          } else if (currentState is AuthLoginState) {
            print(currentState);
            return HomePage();
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

class LoginWidget extends StatefulWidget {
  LoginWidget({
    Key key,
    this.user,
    this.pass,
    this.error,
  }) : super(key: key);
  final String user;
  final String pass;
  final String error;
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String pass;
  String user;
  String error;
  bool loading;
  GlobalKey<FormState> key = new GlobalKey();

  @override
  void initState() {
    super.initState();
    loading = false;
    pass = widget.pass;
    user = widget.user;
    error = widget.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: const EdgeInsets.symmetric(vertical: 15)),
          Image.asset(
            "assets/images/pluis.png",
            height: MediaQuery.of(context).size.height / 10,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                  key: key,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        initialValue: user,
                        decoration: InputDecoration(
                            labelText: "Usuario",
                            labelStyle: TextStyle(color: Colors.white),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2))),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          // var emailExp = RegExp(
                          //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                          if (value == null || value.isEmpty)
                            return "Campo obligatorio";
                          // else if (!emailExp.hasMatch(value) &&
                          //     value.isNotEmpty) return "Correo inválido";
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            user = value;
                          });
                        },
                      ),
                      TextFormField(
                        key: ValueKey("passwordField"),
                        style: TextStyle(color: Colors.white),
                        initialValue: pass,
                        decoration: InputDecoration(
                            labelText: "Contraseña",
                            labelStyle: TextStyle(color: Colors.white),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2))),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Campo obligatorio";
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            pass = value;
                          });
                        },
                      ),
                      if (error != null && error != "")
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
                              onPressed: () async {
                                LoginBloc().add(OpenRegisterLoginEvent());
                              },
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              shape: StadiumBorder(),
                              elevation: 0.0,
                              color: Theme.of(context).accentColor,
                              child: Text(
                                "Registrar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            RaisedButton(
                              key: ValueKey("signinButton"),
                              onPressed: () {
                                if (!loading && key.currentState.validate()) {
                                  key.currentState.save();
                                  LoginBloc().add(AuthenticateLoginEvent(
                                      pass: pass, user: user));
                                  setState(() {
                                    loading = true;
                                  });
                                }
                              },
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              shape: StadiumBorder(),
                              elevation: 0.0,
                              color: Colors.grey.shade300,
                              child: loading
                                  ? Container(
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Text("Ingresar"),
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
    );
  }
}

class RegisterWidget extends StatefulWidget {
  RegisterWidget({Key key, this.error, this.registerSend}) : super(key: key);
  final String error;
  final RegisterSend registerSend;

  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  String user = "";
  String email = "";
  String pass = "";
  String repeatpass = "";
  bool autovalidate;
  bool loading;
  TextEditingController controllerPass = TextEditingController();
  GlobalKey<FormState> key = new GlobalKey();
  List<FocusNode> nodes;
  static var textFieldStyle = TextStyle(color: Colors.white, fontSize: 14);

  InputDecoration getDecoration(String hintText) {
    return InputDecoration(
        labelText: hintText,
        labelStyle: textFieldStyle,
        border:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2)));
  }

  @override
  void initState() {
    super.initState();
    user = widget.registerSend.username == null
        ? ""
        : widget.registerSend.username;
    email = widget.registerSend.email == null ? "" : widget.registerSend.email;
    loading = false;
    autovalidate = false;
    nodes =
        List<FocusNode>.generate(7, (index) => FocusNode(), growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: ListView(children: <Widget>[
        Container(
          //height: MediaQuery.of(context).size.height,
          //width: MediaQuery.of(context).size.width,
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/pluis.png",
                height: MediaQuery.of(context).size.height / 10,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                      key: key,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: textFieldStyle,
                            initialValue: user,
                            focusNode: nodes[0],
                            autovalidate: autovalidate,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(nodes[1]);
                            },
                            decoration: getDecoration("Usuario"),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Campo obligatorio";
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                user = value;
                              });
                            },
                          ),
                          TextFormField(
                            key: ValueKey("email"),
                            style: textFieldStyle,
                            initialValue: email,
                            focusNode: nodes[1],
                            autovalidate: autovalidate,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(nodes[2]);
                            },
                            decoration: getDecoration("Correo"),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              var emailExp = RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                              if (value == null || value.isEmpty)
                                return "Campo obligatorio";
                              else if (!emailExp.hasMatch(value) &&
                                  value.isNotEmpty) return "Correo inválido";
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                          TextFormField(
                            key: ValueKey("passwordField"),
                            style: textFieldStyle,
                            controller: controllerPass,
                            focusNode: nodes[2],
                            autovalidate: autovalidate,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(nodes[3]);
                            },
                            decoration: getDecoration("Contraseña"),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Campo obligatorio";
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                pass = value;
                              });
                            },
                          ),
                          TextFormField(
                            key: ValueKey("passwordRepeatField"),
                            style: textFieldStyle,
                            focusNode: nodes[3],
                            autovalidate: autovalidate,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(nodes[4]);
                            },
                            decoration: getDecoration("Repetir Contraseña"),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value != controllerPass.text) {
                                return "No coinciden las contraseñas";
                              }
                              if (value == null || value.isEmpty)
                                return "Campo obligatorio";
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                repeatpass = value;
                              });
                            },
                          ),
                          if (widget.error != null && widget.error != "")
                            Container(
                              padding: const EdgeInsets.only(top: 20.0),
                              height: 90,
                              child: Text(
                                widget.error,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                RaisedButton(
                                  key: ValueKey("signinButton"),
                                  onPressed: () {
                                    LoginBloc().add(LoadLoginEvent());
                                  },
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  shape: StadiumBorder(),
                                  elevation: 0.0,
                                  color: Colors.grey.shade300,
                                  child: Text("Cancelar"),
                                ),
                                RaisedButton(
                                  onPressed: () async {
                                    if (!autovalidate) {
                                      setState(() {
                                        autovalidate = true;
                                      });
                                    }

                                    if (!loading &&
                                        key.currentState.validate()) {
                                      key.currentState.save();
                                      LoginBloc().add(RegisterLoginEvent(
                                          RegisterSend(
                                              username: user,
                                              password: pass,
                                              repeatPassword: repeatpass,
                                              email: email)));

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
                                      : Text(
                                          "Registrar",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
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
      ]),
    );
  }
}
