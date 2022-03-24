import 'package:flutter/material.dart';

class Badges extends StatelessWidget {
  const Badges({
    Key? key,
    this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  final Widget? child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child!,
        Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                // ignore: prefer_if_null_operators
                color: color != null ? color : Colors.deepOrange,
              ),
              constraints: const BoxConstraints(
                minHeight: 16,
                minWidth: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            )),
      ],
    );
  }
}
