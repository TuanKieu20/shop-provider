import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/auth.dart';
import 'package:shop_provider/provider/cart.dart';
import 'package:shop_provider/provider/product.dart';
import 'package:shop_provider/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                height: 300,
                child: Hero(
                  tag: product.id,
                  child: FadeInImage(
                    placeholder: const AssetImage(
                      'assets/images/product-placeholder.png',
                    ),
                    image: NetworkImage(
                      product.imageUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Consumer<Product>(
                      builder: (ctx, product, _) => IconButton(
                        onPressed: () {
                          product.toggleFavoritStatus(
                              authData.token!, authData.userId!);
                        },
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Icon(
                            product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                product.isFavorite ? Colors.red : Colors.black,
                            size: 30,
                            key: product.isFavorite
                                ? const ValueKey<IconData>(Icons.favorite)
                                : const ValueKey<IconData>(
                                    Icons.favorite_border),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Text>[
                          Text(
                            product.title,
                            softWrap: true,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${product.price.toString()}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cart.addItem(product.id, product.title, product.price,
                            product.imageUrl);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Added item to cart",
                            ),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                cart.removeSingleItem(product.id);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
