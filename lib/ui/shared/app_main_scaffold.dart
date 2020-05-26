import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pluis/bloc/category/index.dart';
import 'package:pluis/bloc/home/home_bloc.dart';
import 'package:pluis/bloc/home/home_event.dart';
import 'package:pluis/bloc/home/home_state.dart';
import 'package:pluis/bloc/shopping_cart.dart/index.dart';
import 'package:pluis/models/category.dart';
import 'package:pluis/models/shop_iw.dart';
import 'package:pluis/ui/shared/app_scaffold.dart';

import 'app_drawer.dart';
import 'custom_search.dart';
import 'products_sliver.dart';

class AppMainScaffold extends StatefulWidget {
  final List<String> bannerImages;
  final List<CategoryItem> mainCategories;

  const AppMainScaffold(
      {Key key, @required this.bannerImages, @required this.mainCategories})
      : super(key: key);

  @override
  _AppMainScaffoldState createState() => _AppMainScaffoldState();
}

class _AppMainScaffoldState extends State<AppMainScaffold>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  Widget body;
  int currentTab;
  @override
  void initState() {
    currentTab = 0;
    tabController = TabController(
        length: this.widget.mainCategories.length,
        vsync: this,
        initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.key, drawer: AppDrawer(), body: buildScaffold(context));
  }

  Widget buildScaffold(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width + 100,
            pinned: true,
            floating: false,
            forceElevated: true,
            title: title(),
            actions: <Widget>[
              shoppingCart(),
            ],
            flexibleSpace: flexibleSpace(context),
            bottom: TabBar(
                controller: tabController,
                onTap: (index) {
                  setState(() {
                    currentTab = index;
                  });
                },
                tabs: this
                    .widget
                    .mainCategories
                    .map((item) => Tab(
                          text: item.name,
                        ))
                    .toList()),
          )
        ];
      },
      body: buildTabBody(context, this.widget.mainCategories[currentTab]),
    );
  }

  Widget shoppingCart() {
    int shoppingCartCount = ShoppingCartInfo.of(context).products.length;
    return GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.shopping_cart, color: Theme.of(context).accentColor),
            shoppingCartCount > 0
                ? Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      "$shoppingCartCount",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ))
                : Container(
                    padding: const EdgeInsets.only(right: 10),
                  )
          ],
        ),
        onTap: () async {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ShoppingCartPage()));
        });
  }

  Widget title() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
          onTap: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(hintText: "Buscar"),
            );
          },
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Buscar',
              contentPadding: EdgeInsets.all(12.0),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide.none))),
    );
  }

  Widget flexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 55.0,
            ),
            SliderBanner(
              banners: this.widget.bannerImages,
            ),
            //categoriesSlider(context),
          ],
        ),
      ),
    );
  }

  Widget categoriesSlider(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 135,
      child: ListView.builder(
        itemCount: this.widget.mainCategories.length - 1,
        itemBuilder: (context, index) {
          CategoryItem categoryItem = this.widget.mainCategories[index + 1];
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryPage(
                          categoryItem: categoryItem,
                        )));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 90,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(categoryItem.image),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsetsDirectional.only(top: 5),
                        child: Text(
                          categoryItem.name.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              ));
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget buildTabBody(BuildContext context, CategoryItem categoryItem) {
    return ProductSliver(
      categoryItem: categoryItem,
    );
  }
}

class SliderBanner extends StatelessWidget {
  final List<String> banners;

  SliderBanner({
    Key key,
    this.banners,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      child: Swiper(
          fade: 1.0,
          layout: SwiperLayout.STACK,
          itemWidth: MediaQuery.of(context).size.width,
          itemHeight: MediaQuery.of(context).size.width - 10,
          itemBuilder: (context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5.0, // has the effect of softening the shadow
                      spreadRadius:
                          3.0, // has the effect of extending the shadow
                      offset: Offset(
                        2.0, // horizontal, move right 10
                        2.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    banners[index],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
          },
          autoplay: true,
          itemCount: banners.length),
    );
  }
}
