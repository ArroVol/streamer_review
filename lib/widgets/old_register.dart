import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;

import 'package:provider/provider.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/model/user.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';

import '../custom_route.dart';
import '../main_screen.dart';



class Register extends StatelessWidget {
  static const routeName = '/auth';
  bool verifiedRegistration = false;

  final SecureStorage secureStorage = SecureStorage();
  User updatedUser = new User();

  bool phoneVerified = false;
  bool userNameVerified = false;

  String userName;
  String phoneNumber;

  // Register({this.email});

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

    String _username, _password, _confirmPassword;

    final usernameField = TextField(

      textInputAction: TextInputAction.go,
      onSubmitted: (value) {
        print("search");
        print(value);
        userName = value;
        DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
        // checkUserName(value);
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        // border: InputBorder.none,

        hintText: 'Enter a username',
        // labelText: 'Name *',
      ),
      // obscureText: true,
      autofocus: true,
      // onSaved: (String value) {
      //   // This optional block of code can be used to run
      //   // code when the user saves the form.
      // },
      // validator: (String value) {
      //   if (value.isEmpty) {
      //     print('its empty');
      //     return "Please enter a username..";
      //   }
      //   if (value.contains('@')) {
      //     return "Do not use @";
      //   }
      //   if (RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value)) {
      //     return "Do not use any special characters";
      //   }
      //   // validator: (value) => value.isEmpty ? "Please enter a username" : null;
      //   // onSaved: (value) => _password = value,
      //   return value.contains('@') ? 'Do not use the @ char.' : null;
      // },
    );


    final usernameField2 = TextFormField(

      textInputAction: TextInputAction.go,

      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        // border: InputBorder.none,

        hintText: 'Enter a username',
      ),
      autofocus: true,
      onSaved: (String value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String value) {
        return value.contains('@') ? 'Do not use the @ char.' : null;
      },
      // validator: (String value) {
      //   if (value.isEmpty) {
      //     print('its empty');
      //     return "Please enter a username..";
      //   }
      //   if (value.contains('@')) {
      //     return "Do not use @";
      //   }
      //   if (RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value)) {
      //     return "Do not use any special characters";
      //   }
      //   validator: (value) => value.isEmpty ? "Please enter a username" : null;
      //   onSaved: (value) => _password = value,
      //   return value.contains('@') ? 'Do not use the @ char.' : null;
      // },
    );


    // final phoneNumberField = TextFormField(
    //   decoration: const InputDecoration(
    //     icon: Icon(Icons.phone_android),
    //     hintText: 'Enter your phone number',
    //     // labelText: 'Name *',
    //   ),
    //   onSaved: (String value) {
    //     // This optional block of code can be used to run
    //     // code when the user saves the form.
    //   },
    //   validator: (value) {
    //     print("this is the phone number");
    //     print(value);
    //     if (value.isEmpty) {
    //       return "Please enter a userggname..";
    //     }
    //     // validator: (value) => value.isEmpty ? "Please enter a username" : null;
    //     // onSaved: (value) => _password = value,
    //     return value.contains('@') ? 'Do not use the @ char.' : null;
    //   },
    // );

    // final confirmPhoneNumber = TextFormField(
    //   autofocus: false,
    //   validator: (value) => value.isEmpty ? "Your password is required" : null,
    //   onSaved: (value) => _confirmPassword = value,
    //   obscureText: true,
    //   // decoration: buildInputDecoration("Confirm password", Icons.lock),
    //   decoration: InputDecoration(),
    //
    // );

    final confirmPhoneNumber = TextField(
      textInputAction: TextInputAction.go,
      onSubmitted: (value) {
        print("search");
        print(value);
        phoneNumber = value;
        DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
        // checkPhoneNumber(value);
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Enter your mobile number',
      ),
      autofocus: true,
    );

    // final confirmPhoneNumber = TextFormField(
    //   decoration: const InputDecoration(
    //     icon: Icon(Icons.phone_android),
    //     hintText: 'Verify phone number',
    //     // labelText: 'Name *',
    //   ),
    //   onSaved: (String value) {
    //     // This optional block of code can be used to run
    //     // code when the user saves the form.
    //   },
    //   validator: (String value) {
    //     if (value.isEmpty) {
    //       return "Please enter a username..";
    //     }
    //     // validator: (value) => value.isEmpty ? "Please enter a username" : null;
    //     // onSaved: (value) => _password = value,
    //     return value.contains('@') ? 'Do not use the @ char.' : null;
    //   },
    // );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          print('pressed in login button');
          print(phoneNumber);
          checkPhoneNumber(phoneNumber);
          print(userName);
          checkUserName(userName);

          // Navigator.pushReplacementNamed(context, '/main_screen');
          print(userNameVerified);
          print(phoneVerified);
          if (userNameVerified && phoneVerified) {
            print("verified");
            Navigator.of(context).pushReplacement(FadePageRoute(
              builder: (context) => MainScreen(),
            ));
          }
        },
        child: Text(
          "Complete Registration",
          textAlign: TextAlign.center,
        ),
      ),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // FlatButton(
        //   padding: EdgeInsets.all(0.0),
        //   child: Text("Forgot password?",
        //       style: TextStyle(fontWeight: FontWeight.w300)),
        //   onPressed: () {},
        // ),
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Complete Registration",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            print('pressed in button');
            // Navigator.pushReplacementNamed(context, '/main_screen');
            if (userNameVerified && phoneVerified) {
              print("verified");
              Navigator.of(context).pushReplacement(FadePageRoute(
                builder: (context) => MainScreen(),
              ));
            }
          },
        )
      ],
    );

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 215.0),
                  Text(
                    "Username",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  usernameField,
                  SizedBox(height: 15.0),
                  // Text(
                  //   "Phone number",
                  //   style: TextStyle(
                  //     color: Colors.deepPurple,
                  //     fontSize: 22.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 10.0),
                  // // phoneNumberField,
                  SizedBox(height: 15.0),
                  Text(
                    "Phone number",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  confirmPhoneNumber,
                  // SizedBox(height: 20.0),
                  // auth.registeredInStatus == Status.Registering
                  //     ? loading
                  //     : longButtons("Register", doRegister),
                  SizedBox(height: 5.0),
                  loginButon
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkUserName(String userName) async {
    String email = await secureStorage.readSecureData("email");
    print("in check");
    if (!await DatabaseHelper2.instance.checkByUserName(userName)) {
      print("the user name doesnt exist");
      List<User> pulledUser = await DatabaseHelper2.instance.getUserByEmail(
          email);
      print(pulledUser.first.phoneNumber);
      print(pulledUser.first.id);
      updatedUser.email = pulledUser.first.email;
      updatedUser.password = pulledUser.first.password;
      updatedUser.userName = userName;
      updatedUser.id = pulledUser.first.id;
      await DatabaseHelper2.instance.updateUser(updatedUser);
      userNameVerified = true;
      print("done");
    } else {
      print("the user name already exists");
    }
  }

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    String email = await secureStorage.readSecureData("email");
    print("in check");
    if (await DatabaseHelper2.instance.getPhoneNumber(phoneNumber) == null) {
      print("the phone Number doesnt exist");
      List<User> pulledUser = await DatabaseHelper2.instance.getUserByEmail(
          email);
      print(pulledUser.first.phoneNumber);
      print(pulledUser.first.id);
      // updatedUser.email = pulledUser.first.email;
      // updatedUser.password = pulledUser.first.password;
      // updatedUser.userName = userName;
      // updatedUser.id = pulledUser.first.id;
      updatedUser.phoneNumber = phoneNumber;
      await DatabaseHelper2.instance.updateUser(updatedUser);
      phoneVerified = true;
      print("done again ");
    } else {
      print("the phone number already exists in the db");
    }
  }
}
