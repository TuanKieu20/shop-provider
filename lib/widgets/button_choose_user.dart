import 'package:flutter/material.dart';
import 'package:shop_provider/screens/user_products_screen.dart';

// ignore: must_be_immutable
class ButtonChooseUser extends StatelessWidget {
  ButtonChooseUser({
    Key? key,
    required this.arg,
    required this.textArg,
  }) : super(key: key);

  String arg;
  String textArg;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(UserProductScreen.routeName, arguments: arg);
      },
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textArg,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const Icon(Icons.keyboard_arrow_right, size: 30)
            ],
          ),
        ),
      ),
    );
  }
}
