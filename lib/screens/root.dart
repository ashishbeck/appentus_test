import 'package:appentus/code/models.dart';
import 'package:appentus/screens/home.dart';
import 'package:appentus/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool isLoading = true;

  checkForLogin(UserInfo userInfo) async {
    var box = await Hive.openBox('myBox');
    var token = box.get('token');
    if (token != null) userInfo.updateToken(token.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserInfo userInfo = Provider.of<UserInfo>(context);
    checkForLogin(userInfo);
    if (isLoading)
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    if (userInfo.token.isEmpty) return SignupPage();
    return HomePage();
  }
}
