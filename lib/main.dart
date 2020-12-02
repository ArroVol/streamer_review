import 'package:flutter/material.dart';
import 'package:streamer_review/profile.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';


import 'bottomNavigationBar.dart';
import 'home.dart';
import 'login.dart';

final SecureStorage secureStorage = SecureStorage();

void main() => runApp(MaterialApp(
  // initialRoute: '/login',
  initialRoute: determineInitialRoute(),



  routes: {
    // '/': (context) => Loading(),
    '/home': (context) => MainScreen(),
    '/login': (context) => LoginScreen(),
    // '/registration': (context) => Registration(),
    '/profile': (context) => Profile(),

  },
));

String determineInitialRoute(){
  if(secureStorage.readSecureData('key') == null){
    return '/login';
  }else {
    return '/home';
  }
}