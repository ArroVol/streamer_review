import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/register.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';
import 'package:streamer_review/users.dart';
import 'custom_route.dart';
import 'home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'main_screen.dart';
import 'model/user.dart';

/// Creates the log in screen state.
class LoginScreen extends StatelessWidget {

  // final _storage = FlutterSecureStorage();
  final SecureStorage secureStorage = SecureStorage();

  User userStored = new User();

  String _email = "";
  String _password = "";
  static const routeName = '/auth';
  bool signedUp = false;

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);


  static User loadUsers() {

  }
  /// Logs in the user
  ///
  /// [data], the username and password from the user.
  Future<String> _loginUser(LoginData data) {

    return Future.delayed(loginTime).then((_) async {
      if(!await DatabaseHelper2.instance.checkEmailByEmail(data.name.toLowerCase())){
        return 'Username not exists';
      }
      if(!await DatabaseHelper2.instance.checkPasswordByPassword(data.password)){
        return 'Password does not match';
      }
      return null;
    });
  }

  /// Recovers the password for the user, not yet implemented.
  ///
  /// [name], the users username/email
  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  // builds the widget.
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
        usernameHint: 'Email',
        passwordHint: 'Password',
      //   confirmPasswordHint: 'Confirm',
        loginButton: 'LOGIN',
        // signupButton: 'REGISTER',
        // confirmPasswordError: 'REGISTER',

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
        accentColor: Colors.lightGreenAccent,
        errorColor: Colors.deepOrange,
        pageColorLight: Colors.black12,
        pageColorDark: Colors.black87,
        titleStyle: TextStyle(
          color: Colors.lightGreenAccent,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),


      //   // be,foreHeroFontSize: 50,
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
        _email = value.toLowerCase();
        secureStorage.writeSecureData("email", _email);
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        _password = value;
        secureStorage.writeSecureData("password", _password);
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        // loginData.name = loginData.name.toLowerCase();
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) async {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        User newUser = new User();
        messages: LoginMessages(
          usernameHint: 'Email',
          passwordHint: 'Password',
          //   confirmPasswordHint: 'Confirm',
          loginButton: 'LOGIN',
          signupButton: 'REGISTER',
          //   forgotPasswordButton: 'Forgot huh?',
          //   recoverPasswordButton: 'HELP ME',
          //   goBackButton: 'GO BACK',
          //   confirmPasswordError: 'Not match!',
          //   recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
          //   recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
          //   recoverPasswordSuccess: 'Password rescued successfully',
        );

        if(!await DatabaseHelper2.instance.checkEmailByEmail(loginData.name.toLowerCase())){
        newUser.userName = loginData.name.toLowerCase();
        newUser.email = loginData.name.toLowerCase();
        newUser.password = loginData.password;
        print('Username is available');
        print(newUser.userName);
        print(newUser.email);
        _email = loginData.name.toLowerCase();
        DatabaseHelper2.instance.insertUser(newUser);
        signedUp = true;
        return _loginUser(loginData);
        }
        return 'Email already in use';
      },
      onSubmitAnimationCompleted: () {
        if(signedUp){
          print("user has first time sign up");
          secureStorage.writeSecureData("email", _email);

          secureStorage.writeSecureData("password", _password);

          // Navigator.pushReplacementNamed(context, '/main_screen');

        Navigator.of(context).pushReplacement(FadePageRoute(
            builder: (context) => Register(),
          )
        );
        } else {
    Navigator.of(context).pushReplacement(FadePageRoute(
    builder: (context) => MainScreen(),
    ));
    }
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
