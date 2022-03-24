import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/cart.dart' show Cart;
import 'package:shop_provider/provider/orders.dart';
import 'package:shop_provider/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white10,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: const Text(
          "Cart",
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
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Card(
          //   margin: const EdgeInsets.all(15),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         const Text("Total", style: TextStyle(fontSize: 20)),
          //         const Spacer(),
          //         Chip(
          //           label: Text("\$${cart.amountCart.toStringAsFixed(2)}"),
          //           backgroundColor: Colors.purple,
          //         ),
          //         OrderButton(cart: cart)
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                title: cart.items.values.toList()[i].title,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                imageUrl: cart.items.values.toList()[i].imageUrl!,
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: OrderButton(cart: cart),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.amountCart <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.amountCart,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.clean();
            },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: double.infinity,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black,
          ),
          child: Text(
            'ORDER NOW \t \$${widget.cart.amountCart.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }
}

// floatingActionButton: GestureDetector(
//           onTap: () {
//             Provider.of<Cart>(context, listen: false).addItem(
//                 loadedProduct.id,
//                 loadedProduct.title,
//                 loadedProduct.price,
//                 loadedProduct.imageUrl);
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text(
//                   "Added item to cart",
//                 ),
//                 duration: const Duration(seconds: 2),
//                 action: SnackBarAction(
//                   label: "UNDO",
//                   onPressed: () {
//                     Provider.of<Cart>(context, listen: false)
//                         .removeSingleItem(loadedProduct.id);
//                   },
//                 ),
//               ),
//             );
//           },
        //   child: Container(
        //       margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        //       width: double.infinity,
        //       height: 50,
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(30),
        //         color: Colors.black,
        //       ),
        //       child: const Text(
        //         'ADD TO CART',
        //         style: TextStyle(
        //             fontSize: 18,
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold),
        //       )),
        // ),