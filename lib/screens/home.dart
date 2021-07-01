import 'package:appentus/code/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  logout(UserInfo userInfo) {
    userInfo.updateToken('');
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('user'),
        actions: [
          ElevatedButton(onPressed: () => logout(userInfo), child: Text('Logout'))
        ],
      ),
      body: Container(
        child: Center(
          child: Text("Token is " + userInfo.token),
        ),
      ),
    );
  }
}
