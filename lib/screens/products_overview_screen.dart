import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/cart.dart';
import 'package:shop_provider/widgets/app_drawer.dart';
import 'package:shop_provider/widgets/products_grid.dart';
import 'package:badges/badges.dart';

import '../provider/products.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: SizedBox(
            width: 70,
            height: 70,
            child: Image.asset(
              "assets/images/LOGO 1.png",
              fit: BoxFit.cover,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Popular',
              ),
              Tab(
                text: 'Men',
              ),
              Tab(
                text: 'Woman',
              ),
              Tab(
                text: 'Sale',
              ),
            ],
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20.0),
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
          // title: const Text("My Shop"),
          actions: <Widget>[
            Badge(
              badgeContent: const Text(
                '1',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              position: BadgePosition.topStart(top: 4, start: 8),
              // padding: const EdgeInsets.all(0),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: 26,
                ),
                onPressed: () {
                  Provider.of<Products>(context, listen: false)
                      .getAllDataOfCategories();
                },
              ),
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                  badgeContent: Text(
                    cart.itemCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  position: BadgePosition.topStart(top: 4, start: 8),
                  // padding: const EdgeInsets.all(0),
                  child: ch),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/cart");
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                  size: 26,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search-screen');
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 30,
              ),
            ),
          ],
        ),
        endDrawer: const AppDrawer(),
        // body: _isLoading
        //     ? const Center(child: CircularProgressIndicator())
        //     :
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: Row(children: <Widget>[
                  const Text(
                    'FILTER & SORT',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 20),
                  PopupMenuButton(
                    onSelected: (FilterOptions selectedValue) {
                      setState(() {
                        if (selectedValue == FilterOptions.favorites) {
                          _showOnlyFavorites = true;
                        } else {
                          _showOnlyFavorites = false;
                        }
                      });
                    },
                    child: const Icon(
                      Icons.sort,
                      color: Colors.black,
                      size: 30,
                    ),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text("Only Favorites"),
                        value: FilterOptions.favorites,
                      ),
                      const PopupMenuItem(
                        child: Text("Show All"),
                        value: FilterOptions.all,
                      )
                    ],
                  ),
                ]),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ProductsGrid(
                      isFav: _showOnlyFavorites,
                      category: 'products',
                    ),
                    ProductsGrid(
                      isFav: _showOnlyFavorites,
                      category: 'productsMen',
                    ),
                    ProductsGrid(
                      isFav: _showOnlyFavorites,
                      category: 'productsWoman',
                    ),
                    ProductsGrid(
                      isFav: _showOnlyFavorites,
                      category: 'productsSale',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//ProductsGrid(isFav: _showOnlyFavorites)
