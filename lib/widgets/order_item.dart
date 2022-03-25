import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../provider/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  const OrderItem(this.order, {Key? key}) : super(key: key);

  final ord.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        color: Colors.grey.withOpacity(0.4),
        margin: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text(
                  "\$${widget.order.amount}",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                ),
                trailing: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 900),
                  transitionBuilder: ((child, animation) => RotationTransition(
                        turns: _expanded
                            ? Tween<double>(begin: 1.5, end: 0.5)
                                .animate(animation)
                            : Tween<double>(begin: 0.5, end: 1.5)
                                .animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      )),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    icon: !_expanded
                        ? const Icon(
                            Icons.expand_less,
                            key: ValueKey('icon1'),
                          )
                        : const Icon(
                            Icons.expand_more,
                            key: ValueKey('icon2'),
                          ),
                  ),
                )),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 10, 100)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map((pro) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              pro.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${pro.quantity}x \$${pro.price}",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.redAccent,
                              ),
                            )
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
