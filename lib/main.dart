import 'package:flutter/material.dart';
import 'package:urrgeo12/services/authentication.dart';
import 'package:urrgeo12/pages/root_page.dart';

void main() {
  runApp(MyApp());
}

final ThemeData _themeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.yellow,
  primarySwatch: Colors.yellow,
  accentColor: Colors.yellow,
  buttonColor: Colors.yellow,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: _themeData,
        home: new RootPage(auth: new Auth()));
  }
}
