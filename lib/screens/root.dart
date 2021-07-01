import 'package:appentus/code/models.dart';
import 'package:appentus/screens/home.dart';
import 'package:appentus/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserInfo userInfo = Provider.of<UserInfo>(context);
    if (userInfo.token.isEmpty) return SignupPage();
    return HomePage();
  }
}
