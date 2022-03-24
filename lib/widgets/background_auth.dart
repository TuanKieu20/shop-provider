import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/auth.dart';

class BackgroundAuth extends StatelessWidget {
  const BackgroundAuth({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _authMode = Provider.of<Auth>(context).authMode;
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Image.asset(
            (_authMode == AuthMode.Login)
                ? 'assets/images/Rectangle 289.png'
                : 'assets/images/Rectangle 290.png',
            height: size.height * 0.4,
            width: size.width,
            fit: BoxFit.cover,
          ),
        ),
        // Positioned(
        //   // top: 8,
        //   left: 5,
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.arrow_back_ios,
        //       size: 24,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        child,
        Positioned(
            bottom: 5,
            right: 5,
            child: Image.asset(
              'assets/images/LOGO 1.png',
              width: 70,
              height: 59,
              fit: BoxFit.cover,
            ))
      ],
    );
  }
}
