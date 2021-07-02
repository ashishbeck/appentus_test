import 'dart:io';

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
    userInfo.updateUser(dummy);
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    User user = userInfo.user;
    titleWidget() => Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          child: ClipOval(
            child: Image.file(File(user.image), fit: BoxFit.cover,),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(user.name),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: titleWidget(),
        actions: [
          TextButton(onPressed: () => logout(userInfo), child: Text('Logout', style: TextStyle(color: Colors.white),))
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
