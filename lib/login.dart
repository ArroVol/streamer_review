import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/users.dart';
import 'custom_route.dart';
import 'home.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_screen.dart';


// const users = const {
//   'reviewer@gmail.com': 'reviewer',
//   'complainer@gmail.com': 'icomplain1234',
// };

class LoginScreen extends StatelessWidget {
  String _email = "";
  String _password = "";
  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      bool match = false;
     match = DatabaseHelper2.instance.checkEmailByEmail(_email) as bool;
     if(!match){
         return 'Username not exists';
     }
      // if (!mockUsers.containsKey(data.name)) {
      //   return 'Username not exists';
      // }
      if (mockUsers[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      title: 'Streview',
      logo: 'assets/logo2.png',
      messages: LoginMessages(
        usernameHint: 'Username',
        passwordHint: 'Password',
      //   confirmPasswordHint: 'Confirm',
        loginButton: 'LOGIN',
      //   signupButton: 'REGISTER',
      //   forgotPasswordButton: 'Forgot huh?',
      //   recoverPasswordButton: 'HELP ME',
      //   goBackButton: 'GO BACK',
      //   confirmPasswordError: 'Not match!',
      //   recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
      //   recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
      //   recoverPasswordSuccess: 'Password rescued successfully',
      ),
      theme: LoginTheme(
        primaryColor: Colors.lightGreenAccent,
        accentColor: Colors.yellow,
        errorColor: Colors.deepOrange,
        pageColorLight: Colors.black12,
        pageColorDark: Colors.black87,
        titleStyle: TextStyle(
          color: Colors.lightGreenAccent,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),
      //   // beforeHeroFontSize: 50,
      //   // afterHeroFontSize: 20,
      //   bodyStyle: TextStyle(
      //     fontStyle: FontStyle.italic,
      //     decoration: TextDecoration.underline,
      //   ),
      //   textFieldStyle: TextStyle(
      //     color: Colors.orange,
      //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
      //   ),
        buttonStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.black38,
        ),
        cardTheme: CardTheme(
          color: Colors.black54,
          elevation: 20,
          margin: EdgeInsets.only(top: 30),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
        ),
      //   inputTheme: InputDecorationTheme(
      //     filled: true,
      //     fillColor: Colors.purple.withOpacity(.1),
      //     contentPadding: EdgeInsets.zero,
      //     errorStyle: TextStyle(
      //       backgroundColor: Colors.orange,
      //       color: Colors.white,
      //     ),
      //     labelStyle: TextStyle(fontSize: 12),
      //     enabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //     errorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedErrorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      //       borderRadius: inputBorder,
      //     ),
      //     disabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //   ),
      //   buttonTheme: LoginButtonTheme(
      //     splashColor: Colors.purple,
      //     backgroundColor: Colors.pinkAccent,
      //     highlightColor: Colors.lightGreen,
      //     elevation: 9.0,
      //     highlightElevation: 6.0,
      //     shape: BeveledRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      ),
      emailValidator: (value) {
       // bool exists =  DatabaseHelper2.instance.checkEmailByEmail(value);
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        _email = value;
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        _password = value;
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => MainScreen(),
        ));
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: false,
    );
  }
}
