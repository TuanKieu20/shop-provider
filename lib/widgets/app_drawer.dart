import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/auth.dart';
import 'package:shop_provider/screens/choose_user_products_screen.dart';
import 'package:shop_provider/screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.black,
      child: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            AppBar(
              leading: Image.asset(
                'assets/images/LOGO 1.png',
                fit: BoxFit.cover,
              ),
              backgroundColor: Colors.black,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Shop',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Consumer<Auth>(
                    builder: (context, auth, ch) => Text(
                      auth.email.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: Colors.white))
              ],
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              leading: const Icon(
                Icons.shop,
                color: Colors.white,
              ),
              title: const Text(
                "Shop",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              leading: const Icon(
                Icons.shop,
                color: Colors.white,
              ),
              title: const Text(
                "Orders",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrderScreen.routeName);
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: const Text(
                "Manage Products",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(ChooseUserProductsScreen.routeName);
              },
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).loggout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
