import 'dart:io';

import 'package:appentus/code/constants.dart';
import 'package:appentus/screens/home.dart';
import 'package:appentus/screens/root.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:appentus/code/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getApplicationDocumentsDirectory();
  Hive..init(path.path);
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
