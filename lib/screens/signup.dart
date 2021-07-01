import 'dart:math';

import 'package:appentus/code/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  signup(UserInfo userInfo) {
    var token = Random().nextInt(100000000).toString();
    userInfo.updateToken(token);
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Token is " + userInfo.token),
            ElevatedButton(onPressed: () => signup(userInfo), child: Text('Signup'))
          ],
        ),
      ),
    );
  }
}
