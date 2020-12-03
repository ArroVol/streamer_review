import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streamer_review/login.dart';
import 'package:streamer_review/main_screen.dart';
import 'package:streamer_review/profile.dart';
import 'package:streamer_review/register.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';


final SecureStorage secureStorage = SecureStorage();
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (secureStorage != null) {
    String email = await secureStorage.readSecureData("email");
    print(email);
    if (email != null) {
      print('passed if check, its not null');
      print("***FOUND EMAIL***");
      print("***$email***");

      // home: Profile();
      runApp(MaterialApp(
        initialRoute: '/main_screen',
        routes: {
          '/register': (context) => Register(),
          '/login': (context) => LoginScreen(),
          '/main_screen': (context) => MainScreen(),
        },
      ));
    } else {
      print("***THERE IS NOT AN EMAIL SAVED***");
      // home: LoginScreen();
      runApp(MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => Register(),
          '/profile': (context) => Profile(),
        },
      ));
    }
  }
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
