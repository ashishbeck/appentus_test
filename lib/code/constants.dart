import 'package:flutter/material.dart';

var appColor = Colors.blueGrey;
TextStyle appNameStyle = TextStyle(
    color: appColor,
    fontWeight: FontWeight.normal,
    fontSize: 30
);
TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16
);
InputDecoration inputDecoration(String label) => InputDecoration(
    labelText: label,
  counterText: ''
);