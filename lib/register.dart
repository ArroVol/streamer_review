import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamer_review/main.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;

import 'custom_route.dart';
import 'helper/database_helper.dart';
import 'main_screen.dart';
import 'model/user.dart';


class RegisterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrieve Text Input',
      home: Register(),
    );
  }
}

// Define a custom Form widget.
class Register extends StatefulWidget {
  @override
 RegisterForm createState() => RegisterForm();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class RegisterForm extends State<Register> {

  bool verifiedRegistration = false;

  final SecureStorage secureStorage = SecureStorage();
  User updatedUser = new User();

  bool phoneVerified = false;
  bool userNameVerified = false;

  String userName;
  String phoneNumber;

  String userNameUnSubmitted;
  String phoneNumberUnSubmitted;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final usernameField = TextField(

      style: TextStyle(color: Colors.white),

      // textInputAction: TextInputAction.go,
      onSubmitted: (value) {
        print("search");
        print(value);
        userName = value;
        DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
        // checkUserName(value);
      },
      onChanged: (userNameOnChanged){
        userNameUnSubmitted = userNameOnChanged;
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Enter a username',
        // color: Colors.lightGreenAccent,

      ),
      autofocus: true,
    );

    final confirmPhoneNumber = TextField(
      // textInputAction: TextInputAction.go,
      onSubmitted: (value) {
        print("search");
        print(value);
        phoneNumber = value;
        DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
        // checkPhoneNumber(value);
      },
      onChanged: (phoneNumberOnChanged){
       phoneNumberUnSubmitted = phoneNumberOnChanged;
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Enter your mobile number',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      style: TextStyle(color: Colors.white),

      autofocus: true,
    );


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

        // textColor: Colors.lightGreenAccent,
        // color: Colors.lightGreenAccent,
        onPressed: () {
          print('pressed login button');
          print(phoneNumber);
          if(phoneNumber == null && phoneNumberUnSubmitted != null){
            print("switching for onchanged for phone number");
            phoneNumber = phoneNumberUnSubmitted;
            print(phoneNumber);
          }
          if(phoneNumber != null) {
            print("not null number...");
            checkPhoneNumber(phoneNumber);
          }

          if(userName == null && userNameUnSubmitted != null){
            print("switching for onchanged for user name");
            userName = userNameUnSubmitted;
            print(userName);
          }
          print('user name: $userName');
          if(userName != null) {
            checkUserName(userName);
          }

          // sleep(const Duration(seconds:1));
          checkVerified();
          if (userNameVerified && phoneVerified) {
            print("verified");
            Navigator.of(context).pushReplacement(FadePageRoute(
              builder: (context) => MainScreen(),
            ));
          } else {
            print('fields arent completed');
          }
        },
        child: Text(
          "Complete Registration",
          textAlign: TextAlign.center,
        ),
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 215.0),
                Text(
                  "Username",
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 22.0,
                    color: Colors.lightGreenAccent,
                  ),
                ),

                SizedBox(height: 5.0),
                usernameField,
                SizedBox(height: 15.0),
                SizedBox(height: 15.0),
                Text(
                  "Phone number",
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 22.0,
                    color: Colors.lightGreenAccent,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                confirmPhoneNumber,
                SizedBox(height: 5.0),
                loginButon
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black54,

    );
  }

  /// This method checks to see if the user entered a phone number that already exists in the DB
  ///
  /// [userName], the user name of the user.
  Future<bool> checkUserName(String userName) async {
    String email = await secureStorage.readSecureData("email");
    print("in user check");
    if (!await DatabaseHelper2.instance.checkByUserName(userName)) {
      print("the user name doesnt exist");
      userNameVerified = true;
      print("done");
    } else {
      print("the user name already exists");
    }
  }
  /// This method checks to see if the user entered a phone number that already exists in the DB
  ///
  /// [phoneNumber], the phoneNumber of the user.
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    String email = await secureStorage.readSecureData("email");
    print("in phone check");
    print(phoneNumber);
    if (!await DatabaseHelper2.instance.userRepository.checkByPhoneNumber(phoneNumber)) {
      print("the phone Number doesnt exist");
      List<User> pulledUser = await DatabaseHelper2.instance.getUserByEmail(
          email);
      // print(pulledUser.first.phoneNumber);
      // print(pulledUser.first.id);
      // updatedUser.phoneNumber = phoneNumber;
      // await DatabaseHelper2.instance.updateUser(updatedUser);
      phoneVerified = true;
      print("done again ");
    } else {
      print("the phone number already exists in the db");
    }
  }

  void checkVerified() async {
    String email = await secureStorage.readSecureData("email");
    List<User> pulledUser = await DatabaseHelper2.instance.getUserByEmail(
        email);
    print(pulledUser.first.phoneNumber);
    print(pulledUser.first.id);
    updatedUser.email = pulledUser.first.email;
    updatedUser.password = pulledUser.first.password;
    updatedUser.userName = userName;
    updatedUser.id = pulledUser.first.id;
    updatedUser.phoneNumber = phoneNumber;
    await DatabaseHelper2.instance.updateUser(updatedUser);
    sleep(const Duration(seconds:1));

    print(userNameVerified);
    print(phoneVerified);
    if (userNameVerified && phoneVerified) {
      print("verified");
      secureStorage.writeSecureData('userName', userName);
      secureStorage.writeSecureData('phoneNumber', phoneNumber);
      Navigator.of(context).pushReplacement(FadePageRoute(
        builder: (context) => MainScreen(),
      ));
    } else {
      print('fields arent completed');
    }
  }

}
