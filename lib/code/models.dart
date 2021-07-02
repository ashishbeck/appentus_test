import 'package:flutter/material.dart';

final String userTable = "Users";
User dummy = User(name: '', email: '', password: '', number: 0, image: '');

class UserInfo with ChangeNotifier {
  String token = '';
  // User user = dummy;
  updateToken(String value) {
    token = value;
    notifyListeners();
  }

  // updateUser(User value) {
  //   user = value;
  //   notifyListeners();
  // }
}

class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final int number;
  final String image;

  const User({this.id, required this.name, required this.email, required this.password, required this.number, required this.image});

  toJson() => {
    UserFields.id: id,
    UserFields.name: name,
    UserFields.email: email,
    UserFields.password: password,
    UserFields.number: number,
    UserFields.image: image
  };

  static User fromJson(Map json) => User(
    id: json[UserFields.id] as int?,
    name: json[UserFields.name] as String,
    email: json[UserFields.email] as String,
    password: json[UserFields.password] as String,
    number: json[UserFields.number] as int,
    image: json[UserFields.image] as String
  );
}

class UserFields {
  static final List<String> values = [
    id, name, email, password, number, image
  ];

  static final String id = "_id";
  static final String name = "name";
  static final String email = "email";
  static final String password = "password";
  static final String number = "number";
  static final String image = "image";
}