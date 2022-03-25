import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_provider/models/http_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// ignore: constant_identifier_names
enum AuthMode { Signup, Login }

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _autoTimer;
  String? _email;
  AuthMode _authMode = AuthMode.Login;

  void switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      _authMode = AuthMode.Signup;
      notifyListeners();
    } else {
      _authMode = AuthMode.Login;
      notifyListeners();
    }
  }

  AuthMode get authMode {
    return _authMode;
  }

  bool get isAuth {
    return token != null;
  }

  String? get email {
    return _email;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBeOsXONXAW8dpfRdJ_j9b2kAUlhJUSQ7E');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _email = responseData['email'];
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
        'email': _email,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool?> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    _email = extractedUserData['email'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> loggout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    GoogleSignIn().signOut();
    FacebookAuth.instance.logOut();
    if (_autoTimer != null) {
      _autoTimer!.cancel();
      _autoTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_autoTimer != null) {
      _autoTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _autoTimer = Timer(Duration(seconds: timeToExpiry), loggout);
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final authCredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication!.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    try {
      final response =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      await response.user!.getIdToken().then((value) => _token = value);
      _userId = response.user!.uid;
      await response.user!.getIdTokenResult(true).then((value) {
        _expiryDate = value.expirationTime;
      });
      _email = response.user!.email;
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
        'email': _email,
      });
      prefs.setString('userData', userData);
    } on FirebaseAuthException catch (error) {
      throw HttpException(error.message.toString());
    }
  }

  Future<void> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    try {
      final response = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      await response.user!.getIdToken().then((value) => _token = value);
      _userId = response.user!.uid;
      await response.user!.getIdTokenResult(true).then((value) {
        _expiryDate = value.expirationTime;
      });
      _email = response.user!.email;
      // print(response.)
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
        'email': _email,
      });
      prefs.setString('userData', userData);
    } on FirebaseAuthException catch (error) {
      throw HttpException(error.message.toString());
    }
  }
}
