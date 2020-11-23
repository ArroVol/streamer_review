import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamer_review/login.dart';
import 'package:streamer_review/main_screen.dart';
import 'package:streamer_review/profile.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';

final SecureStorage secureStorage = SecureStorage();
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();


Future<void> main() async {

  if(secureStorage.readSecureData("email") != null){
    String email = await secureStorage.readSecureData("email");
    // String sEmail = email.toString();
    print("***FOUND EMAIL***");
    // print("***$sEmail***");
    print("***$email***");

    // home: Profile();
    runApp(MaterialApp(
      initialRoute: '/main_screen',

      routes: {
        '/login': (context) => LoginScreen(),
        '/main_screen': (context) => MainScreen(),
      },
    ));

  }else {
    print("***THERE IS NOT AN EMAIL SAVED***");

    // home: LoginScreen();
    runApp(MaterialApp(
      initialRoute: '/login',

      routes: {
        '/login': (context) => LoginScreen(),
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



