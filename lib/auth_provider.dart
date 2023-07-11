import 'package:flutter/material.dart';

import 'screens/login.dart';

class AuthProvider with ChangeNotifier {
  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  void login() {
    _loggedIn = true;
    notifyListeners();
  }

  void logout(BuildContext context) {
    _loggedIn = false;
    notifyListeners();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(onLogin: login)),
    );
  }
}
