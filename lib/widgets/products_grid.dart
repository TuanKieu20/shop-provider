import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/products.dart';
import 'package:shop_provider/widgets/product_item.dart';

class ProductsGrid extends StatefulWidget {
  final bool isFav;
  final String category;
  const ProductsGrid({
    Key? key,
    required this.isFav,
    required this.category,
  }) : super(key: key);

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .fetchData(widget.category, false)
          .then((_) {
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
    final productsData = Provider.of<Products>(context);
    final products =
        widget.isFav ? productsData.favoritesItems : productsData.items;

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 6 / 5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 30,
            ),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: const ProductItem(),
            ),
          );
  }
}
