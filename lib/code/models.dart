import 'package:flutter/material.dart';

class UserInfo with ChangeNotifier {
  String token = '';
  User user = User();
  updateToken(String value) {
    token = value;
    notifyListeners();
  }

  updateUser(User value) {
    user = value;
    notifyListeners();
  }
}

class User {
  String name;
  String email;
  String password;
  String number;
  String image;

  User({this.name = '', this.email = '', this.password = '', this.number = '', this.image = ''});
}