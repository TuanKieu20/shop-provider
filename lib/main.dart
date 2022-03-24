import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/auth.dart';
import 'package:shop_provider/provider/cart.dart';
import 'package:shop_provider/provider/orders.dart';
import 'package:shop_provider/provider/products.dart';
import 'package:shop_provider/screens/auth_screen.dart';
import 'package:shop_provider/screens/cart_screen.dart';
import 'package:shop_provider/screens/choose_user_products_screen.dart';
import 'package:shop_provider/screens/edit_product_screen.dart';
import 'package:shop_provider/screens/order_screen.dart';
import 'package:shop_provider/screens/product_detail_screen.dart';
import 'package:shop_provider/screens/products_overview_screen.dart';
import 'package:shop_provider/screens/search_screen.dart';
import 'package:shop_provider/screens/splash_screen.dart';
import 'package:shop_provider/screens/user_products_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(),
            update: (ctx, value, previous) => Products()
              ..updates(
                value.token == null ? null : value.token!,
                previous == null ? [] : previous.items,
                value.userId == null ? null : value.userId!,
              ),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          // ChangeNotifierProxyProvider<Auth, Picker>(
          //   create: (ctx) => Picker(),
          //   update: (ctx, auth, previousPicker) => Picker()
          //     ..updates(
          //       auth.userId == null ? null : auth.userId!,
          //     ),
          // ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders(),
            update: (ctx, auth, previousOrders) => Orders()
              ..updates(
                auth.token == null ? null : auth.token!,
                previousOrders == null ? [] : previousOrders.orders,
                auth.userId == null ? null : auth.userId!,
              ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
                fontFamily: 'Lato',
                // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                //     .copyWith(secondary: Colors.deepOrange),
                primaryColor: Colors.black,
                primaryColorDark: Colors.black,
                primaryColorLight: Colors.black,
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle.dark)),
            // home: const ProductsOverviewScreen(),
            home: auth.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (ctx) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrderScreen.routeName: (ctx) => const OrderScreen(),
              UserProductScreen.routeName: (ctx) => const UserProductScreen(),
              ChooseUserProductsScreen.routeName: (ctx) =>
                  const ChooseUserProductsScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
              AuthScreen.routeName: (ctx) => const AuthScreen(),
              SearchScreen.routeName: (ctx) => const SearchScreen(),
            },
          ),
        ));
  }
}
