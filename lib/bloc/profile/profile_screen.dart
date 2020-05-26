import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluis/models/api_models/coupon.dart';
import 'index.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key key,
    @required ProfileBloc profileBloc,
  })  : _profileBloc = profileBloc,
        super(key: key);

  final ProfileBloc _profileBloc;

  @override
  ProfileScreenState createState() {
    return new ProfileScreenState(_profileBloc);
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc _profileBloc;
  static const offsetVisibleThreshold = 50;
  String selectedFilter;

  ProfileScreenState(this._profileBloc);

  @override
  void initState() {
    super.initState();
    _profileBloc.add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: widget._profileBloc,
        builder: (
          BuildContext context,
          ProfileState currentState,
        ) {
          if (currentState is UnProfileState) {
            print(currentState);
            return Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor,
                ),
              ),
            );
          } else if (currentState is ErrorProfileState) {
            print(currentState);
            return Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(currentState.errorMessage),
              ),
            );
          } else if (currentState is NoDataProfileState) {
            print(currentState);
            return Text("NoDataProfileState");
          } else if (currentState is InProfileState) {
            print(currentState);
            return ProfileWidget(
              profileState: currentState,
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

class ProfileWidget extends StatefulWidget {
  ProfileWidget({Key key, this.profileState}) : super(key: key);
  InProfileState profileState;

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.profileState.avatar),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        widget.profileState.fullname,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "@${widget.profileState.username}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle,
                ),
              ),
              title: Text(
                "Nombre",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              subtitle: Text(
                widget.profileState.fullname,
                style: TextStyle(fontSize: 14),
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.email,
                ),
              ),
              title: Text(
                "Correo electrónico",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              subtitle: Text(
                widget.profileState.email,
                style: TextStyle(fontSize: 14),
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.contact_phone,
                ),
              ),
              title: Text(
                "Teléfono",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              subtitle: Text(
                widget.profileState.phone,
                style: TextStyle(fontSize: 14),
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.location_on,
                ),
              ),
              title: Text(
                "Dirección",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              subtitle: Text(
                widget.profileState.address,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Divider(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text("Cupones disponibles",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
            CouponsList(coupons: widget.profileState.coupons)
          ],
        ));
  }
}

class CouponsList extends StatelessWidget {
  CouponsList({Key key, this.coupons}) : super(key: key);
  List<Coupon> coupons;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(shrinkWrap: true, slivers: <Widget>[
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2.5),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            Coupon item = coupons[index];
            return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.local_activity,
                    color: item.expireUsing ? Colors.green : Colors.grey,
                  ),
                ),
                title: Text(
                  "Descuento",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                subtitle: Text("${item.amount.toString()}%"));
          },
          childCount: coupons.length,
        ),
      )
    ]);
    // return Container(
    //   child: Column(
    //     children: coupons.map((item) {
    //       return ListTile(
    //         leading: Container(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Icon(
    //             Icons.local_activity,
    //           ),
    //         ),
    //         title: Text(
    //           "Descuento",
    //           style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    //         ),
    //         subtitle: Text("${item.name}"),
    //         trailing: Text("${item.amount.toString()}%"),
    //       );
    //     }).toList(),
    //   ),
    // );
  }
}
