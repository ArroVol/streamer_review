import 'dart:math';

import 'package:flutter/material.dart';
import 'package:streamer_review/login.dart';
import 'package:streamer_review/main_screen.dart';
import 'package:streamer_review/profile.dart';
import 'package:streamer_review/secondScreen.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';
import 'package:streamer_review/widgets/home_page.dart';


final SecureStorage secureStorage = SecureStorage();


void main() {

  if(secureStorage.readSecureData("email") != null){
    Future email = secureStorage.readSecureData("email");
    String sEmail = email.toString();
    print("***FOUND EMAIL***");
    print("***$sEmail***");

    // home: Profile();
    runApp(MaterialApp(
      initialRoute: '/main_screen',

      routes: {
        // '/': (context) => Loading(),
        // '/home': (context) => Home(),

        '/login': (context) => LoginScreen(),
        // '/registration': (context) => Registration(),
        '/main_screen': (context) => MainScreen(),


      },
    ));

  }else {
    print("there is not an email saved");

    // home: LoginScreen();
    runApp(MaterialApp(
      initialRoute: '/login',

      routes: {
        // '/': (context) => Loading(),
        // '/home': (context) => Home(),

        '/login': (context) => LoginScreen(),
        // '/registration': (context) => Registration(),
        '/profile': (context) => Profile(),


      },
    ));
  }
  // runApp(MaterialApp(
  //   initialRoute: '/login',
  //
  //   routes: {
  //     // '/': (context) => Loading(),
  //     // '/home': (context) => Home(),
  //
  //     '/login': (context) => LoginScreen(),
  //     // '/registration': (context) => Registration(),
  //     '/profile': (context) => Profile(),
  //
  //
  //   },
  // ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Streamer Review App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginScreen(),
      // home: ColorCircle(title: 'Color Circle',),
    );
  }
}



