import 'package:flutter/material.dart';
import 'package:sharetime/dashboard/Dashboard.dart';
import 'package:timezone/data/latest.dart';

void main() {
  initializeTimeZones();
  runApp(Main());
}

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Pixel',
        primaryColor: Colors.white,
        accentColor: Colors.teal,
        brightness: Brightness.light
      ),
      home: Dashboard()
    );
  }
}
