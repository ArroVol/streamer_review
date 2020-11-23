import 'package:flutter/material.dart';
import 'package:streamer_review/profile.dart';
import 'package:streamer_review/secondScreen.dart';
import 'package:streamer_review/widgets/home_page.dart';


import 'login.dart';


void main() => runApp(MaterialApp(
  initialRoute: '/login',
  routes: {
    // '/': (context) => Loading(),
    // '/home': (context) => Home(),
    '/login': (context) => LoginScreen(),
    // '/registration': (context) => Registration(),
    '/profile': (context) => Profile(),



  },
));
