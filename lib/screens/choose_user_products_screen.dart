import 'package:flutter/material.dart';
import 'package:shop_provider/widgets/app_drawer.dart';
import 'package:shop_provider/widgets/button_choose_user.dart';

class ChooseUserProductsScreen extends StatelessWidget {
  static const routeName = '/choose-user-products-screen';

  const ChooseUserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white10,
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                size: 30,
                color: Colors.black,
              )),
          title: const Text(
            'Choose user products',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            SizedBox(
              width: 70,
              height: 70,
              child: Image.asset(
                "assets/images/LOGO 1.png",
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            children: <Widget>[
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).pushNamed(UserProductScreen.routeName,
              //         arguments: 'products');
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     width: double.infinity,
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: const [
              //           Text(
              //             'Products products',
              //             style: TextStyle(
              //               fontSize: 30,
              //               fontWeight: FontWeight.w700,
              //             ),
              //             textAlign: TextAlign.center,
              //           ),
              //           Icon(Icons.near_me, size: 30)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).pushNamed(UserProductScreen.routeName,
              //         arguments: 'productsMen');
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     width: double.infinity,
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: const [
              //           Text(
              //             'Products productsMen',
              //             style: TextStyle(
              //               fontSize: 30,
              //               fontWeight: FontWeight.w700,
              //             ),
              //             textAlign: TextAlign.center,
              //           ),
              //           Icon(Icons.near_me, size: 30)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              ButtonChooseUser(arg: 'products', textArg: 'Products Products'),
              ButtonChooseUser(arg: 'productsMen', textArg: 'Products Men'),
              ButtonChooseUser(arg: 'productsWoman', textArg: 'Products Woman'),
              ButtonChooseUser(arg: 'productsSale', textArg: 'Products Sale')
            ],
          ),
        ));
  }
}
