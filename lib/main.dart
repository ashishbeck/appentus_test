import 'package:appentus/code/constants.dart';
import 'package:appentus/screens/home.dart';
import 'package:appentus/screens/root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appentus/code/models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfo>(create: (context) => UserInfo())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: appColor,
        ),
        home: RootPage(),
      ),
    );
  }
}
