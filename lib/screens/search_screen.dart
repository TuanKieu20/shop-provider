import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/products.dart';
import 'package:shop_provider/widgets/product_item.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void didChangeDependencies() {
    final productsData = Provider.of<Products>(context);
    productsData.setItems = productsData.items;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context).dispose();
            Navigator.of(context).popAndPushNamed('/');
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Find products',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          SizedBox(
            width: 70,
            height: 70,
            child: Image.asset(
              "assets/images/LOGO 1.png",
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.6),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Write product ...',
                ),
                onChanged: (value) {
                  Provider.of<Products>(context, listen: false)
                      .filterProduct(value);
                },
                onSubmitted: (value) {
                  Provider.of<Products>(context, listen: false)
                      .filterProduct(value);
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: productsData.listDataFilter.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6 / 5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 30,
                ),
                itemBuilder: (context, i) => ChangeNotifierProvider.value(
                  value: productsData.listDataFilter[i],
                  child: const ProductItem(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
