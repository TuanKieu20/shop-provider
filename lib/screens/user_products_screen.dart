import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/products.dart';
import 'package:shop_provider/screens/edit_product_screen.dart';
import 'package:shop_provider/widgets/user_product_item.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = "/user-products";
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  Future<void> _refreshData(BuildContext context) async {
    // final arg = ModalRoute.of(context)!.settings.arguments as String;
    // create new screen
    // await Provider.of<Products>(context, listen: false)
    //     .fetchAndSetProductsMen();
    // switch (widget.arg) {
    //   case 'producs':
    //     await Provider.of<Products>(context, listen: false)
    //         .fetchAndSetProducts(true);
    //     break;
    //   case 'productsMen':
    //     await Provider.of<Products>(context, listen: false)
    //         .fetchAndSetProductsMen(true);
    //     break;
    //   default:
    // }
    setState(() {});
  }

  var _isInit = true;
  var _isLoading = false;
  String? arg;
  @override
  void initState() {
    // arg = ModalRoute.of(context)!.settings.arguments as String;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    arg = ModalRoute.of(context)!.settings.arguments as String;
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchData(arg!).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              // size: 30,
            )),
        title: const Text(
          "Your Products",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: '');
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ],
      ),
      // drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder(
              future: _refreshData(context),
              builder: (ctx, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshData(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Consumer<Products>(
                          builder: (context, productsData, _) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, i) => Column(
                                children: [
                                  UserProductItem(
                                    id: productsData.items[i].id,
                                    title: productsData.items[i].title,
                                    imageUrl: productsData.items[i].imageUrl,
                                  ),
                                  const Divider()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
    );
  }
}
