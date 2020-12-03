import 'package:flutter/material.dart';
import 'package:streamer_review/profile.dart';


import '../login.dart';


void main() => runApp(MaterialApp(
  initialRoute: '/login',

  routes: {
    // '/': (context) => Loading(),
    // '/home': (context) => Home(),

    '/login': (context) => LoginScreen(),
    // '/login': (context) => MainScreen(),
    // '/registration': (context) => Registration(),
    '/profile': (context) => Profile(),



  },
));
