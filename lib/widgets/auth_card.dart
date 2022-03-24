import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/models/http_exception.dart';
import 'package:shop_provider/provider/auth.dart';

// ignore: constant_identifier_names
// enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // AuthMode _authMode = AuthMode.Login;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error Occurred!'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Okay'))
              ],
            ));
  }

  Future<void> _submit() async {
    final _authMode = Provider.of<Auth>(context, listen: false).authMode;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
      } else {
        //Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This pass word is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _authMode = Provider.of<Auth>(context).authMode;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                '\tEMAIL',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(1),
                    hintText: 'name@gmail.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                '\tPASSWORD',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    hintText: '*******',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              if (_authMode == AuthMode.Signup) const SizedBox(height: 20),
              if (_authMode == AuthMode.Signup)
                const Text(
                  '\tPASSWORD',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  enabled: _authMode == AuthMode.Signup,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      contentPadding: EdgeInsets.all(0),
                      labelText: 'Confirm password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Password do not match!';
                          }
                          return null;
                        }
                      : null,
                ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                      child: Text(
                        _authMode == AuthMode.Login ? 'LOGIN' : 'REGISTER',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              Container(
                  margin: (_authMode == AuthMode.Login)
                      ? EdgeInsets.only(left: size.width / 2 - 150)
                      : const EdgeInsets.only(left: 20, bottom: 20),
                  child: (_authMode == AuthMode.Login)
                      ? Row(
                          children: <Widget>[
                            const Text('Not registered yet?'),
                            TextButton(
                                onPressed: () {
                                  Provider.of<Auth>(context, listen: false)
                                      .switchAuthMode();
                                },
                                child: const Text('Create Account'))
                          ],
                        )
                      : const Text(
                          'By joining I agree to receive emails from Bajuku.',
                          style: TextStyle(fontSize: 14),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
