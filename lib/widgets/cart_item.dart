import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/cart.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {Key? key,
      required this.id,
      required this.productId,
      required this.title,
      required this.price,
      required this.quantity,
      required this.imageUrl})
      : super(key: key);

  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          size: 40,
          color: Colors.white10,
        ),
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text(
                      "Do you want to remove the item from the cart?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ));
      },
      child: Card(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Container(
            width: double.infinity,
            height: 160,
            padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
            decoration: BoxDecoration(
                color: const Color(0xFFD0D0D0),
                borderRadius: BorderRadius.circular(10)),
            child: Column(children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Image.network(imageUrl, fit: BoxFit.cover)),
                  const SizedBox(width: 10),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: "Total: \$${(quantity * price)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]))
                ],
              ),
              Container(
                margin: const EdgeInsets.only(right: 10),
                alignment: Alignment.bottomRight,
                child: Text(
                  "$quantity x",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ]),
          )
          // child: ListTile(
          //   leading: CircleAvatar(
          //     backgroundColor: Colors.purple,
          //     child: FittedBox(
          //       child: Padding(
          //         padding: const EdgeInsets.all(5.0),
          //         child: Text(
          //           "\$$price",
          //           style: const TextStyle(
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          //   title: Text(title),
          //   subtitle: Text("Total: \$${(quantity * price)}"),
          //   trailing: Text("$quantity x"),
          // ),

          ),
    );
  }
}
