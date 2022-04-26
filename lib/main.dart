import 'attendance.dart';
import 'login.dart';
import 'notification.dart';
import 'profile.dart';
import 'report.dart';
import 'users.dart';
import 'package:flutter/material.dart';

import 'addGeofence.dart';
import 'geofences.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int lang = 1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        return new Builder(
          builder: (BuildContext context) {
            return new MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child,
            );
          },
        );
        // );
      },
      title: "Myfence",
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff67B2BB)),
        //fontFamily: 'Hdtc',
        primaryColor: Color(0xff67B2BB),
        primaryColorBrightness: Brightness.dark,
        accentColor: Color(0xff67B2BB),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/attendance': (context) => AttendanceMark(),
        '/report': (context) => Report(),
        '/profile': (context) => Profile(),
        '/addGeofence': (context) => AddGeofence(),
        '/geofences': (context) => Geofences(),
        '/users': (context) => Users(),
        '/notification': (context) => Notifications(),
      },
    );
  }
}
