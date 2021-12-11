import 'dart:io';

import 'package:appentus/code/constants.dart';
import 'package:appentus/screens/home.dart';
import 'package:appentus/screens/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:appentus/code/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var path = await getApplicationDocumentsDirectory();
  Hive..init(path.path);
  // SystemChrome.setEnabledSystemUIOverlays(overlays)
  runApp(MyApp()); //test 2
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfo>(create: (context) => UserInfo())
      ],
      child: MaterialApp(
        title: 'Appentus Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: appColor,
          appBarTheme: AppBarTheme(brightness: Brightness.dark)
        ),
        home: RootPage(),
      ),
    );
  }
}
