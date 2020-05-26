import 'package:flutter/material.dart';
import 'package:pluis/models/category.dart';
import 'package:pluis/ui/shared/app_main_scaffold.dart';

class HomePageUI extends StatefulWidget {
  final List<CategoryItem> categories;
  final List<String> bannerImages;

  HomePageUI({this.categories, this.bannerImages});

  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppMainScaffold(
      bannerImages: this.widget.bannerImages,
      mainCategories: this.widget.categories,
    );
  }
}

class HomePageUICharging extends StatefulWidget {
  HomePageUICharging({Key key}) : super(key: key);

  @override
  _HomePageUIChargingState createState() => _HomePageUIChargingState();
}

class _HomePageUIChargingState extends State<HomePageUICharging> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
