import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});
}

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
