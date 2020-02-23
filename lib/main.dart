import 'package:flutter/material.dart';
import 'package:sharetime/dashboard/Dashboard.dart';
import 'package:sharetime/how/How.dart';
import 'package:sharetime/share_time/TimeZoneList.dart';
import 'package:timezone/data/latest.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  initializeTimeZones();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
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
        fontFamily: 'CabinSketch',
        primaryColor: Colors.white,
        accentColor: Colors.teal,
        brightness: Brightness.light
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Dashboard(),
        '/timezones': (context) => TimeZoneList(),
        '/how': (context) => How()
      },
    );
  }
}
