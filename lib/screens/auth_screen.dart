import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/provider/auth.dart';
import 'package:shop_provider/provider/products.dart';
import 'package:shop_provider/widgets/auth_card.dart';
import 'package:shop_provider/widgets/background_auth.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/AuthScreen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _authMode = Provider.of<Auth>(context).authMode;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white10,
        elevation: 0,
        toolbarHeight: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BackgroundAuth(
                child: Positioned(
                    top: size.height * 0.4 / 2 - 30,
                    left: 45,
                    child: (_authMode == AuthMode.Login)
                        ? RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: '\n\n'),
                                TextSpan(
                                  text:
                                      'Yay! You\'re back! Thanks for shopping with us.\nWe have excited deals and promotions going on, grab\nyour pick now!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Get’s started with \nBajuku',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<Auth>(context,
                                                listen: false)
                                            .switchAuthMode();
                                      },
                                      child: const Text('Log In'))
                                ],
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                'REGISTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )),
              ),
              if (_authMode == AuthMode.Login)
                Container(
                  margin: const EdgeInsets.all(30),
                  child: const Text(
                    'LOG IN',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              const AuthCard(),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                // color: Colors.red,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Provider.of<Auth>(context, listen: false)
                            .signInWithGoogle();
                      },
                      child: Image.asset('assets/images/Google Logo.png'),
                    ),
                    const SizedBox(width: 40),
                    InkWell(
                      onTap: () {
                        Provider.of<Auth>(context, listen: false)
                            .signInWithFacebook();
                      },
                      child: Image.asset('assets/images/Facebook Logo.png'),
                    ),
                    const SizedBox(width: 40),
                    InkWell(
                      onTap: () {
                        Provider.of<Products>(context, listen: false)
                            .getAllDataOfCategories();
                      },
                      child: Image.asset('assets/images/Apple Logo.png'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
