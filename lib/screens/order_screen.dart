import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/orders.dart' show Orders;
import 'package:shop_provider/widgets/app_drawer.dart';
import 'package:shop_provider/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/orders";

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
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
                color: Colors.black,
              )),
          title: const Text(
            "Your Order",
            style: TextStyle(color: Colors.black),
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
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, snapshotData) {
              if (snapshotData.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshotData.error != null) {
                  return const Center(
                    child: Text("An error occurred !"),
                  );
                } else {
                  return Consumer<Orders>(
                    builder: (ctx, orderData, child) => orderData.orders.isEmpty
                        ? Column(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/images/Women Power Mobile.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'Your order is empty',
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Please go to home screen to add items, what you like !',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctx, i) => OrderItem(
                              orderData.orders[i],
                            ),
                          ),
                  );
                }
              }
            }));
  }
}
