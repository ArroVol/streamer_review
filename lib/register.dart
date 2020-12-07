import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'package:streamer_review/secure_storage/secure_storage.dart';
import 'custom_route.dart';
import 'helper/database_helper.dart';
import 'main_screen.dart';
import 'model/user.dart';

/// This classes finalizes the users account.
class Register extends StatelessWidget {
  static const routeName = '/auth';
  bool verifiedRegistration = false;

  final SecureStorage secureStorage = SecureStorage();
  User updatedUser = new User();

  bool phoneVerified = false;
  bool userNameVerified = false;

  String userName;
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final formKey = new GlobalKey<FormState>();

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
        hintText: 'Enter a username',
      ),
      autofocus: true,
    );

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

  /// This method checks to see if the user entered a phone number that already exists in the DB
  ///
  /// [userName], the user name of the user.
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
  /// This method checks to see if the user entered a phone number that already exists in the DB
  ///
  /// [phoneNumber], the phoneNumber of the user.
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    String email = await secureStorage.readSecureData("email");
    print("in check");
    if (await DatabaseHelper2.instance.getPhoneNumber(phoneNumber) == null) {
      print("the phone Number doesnt exist");
      List<User> pulledUser = await DatabaseHelper2.instance.getUserByEmail(
          email);
      print(pulledUser.first.phoneNumber);
      print(pulledUser.first.id);
      updatedUser.phoneNumber = phoneNumber;
      await DatabaseHelper2.instance.updateUser(updatedUser);
      phoneVerified = true;
      print("done again ");
    } else {
      print("the phone number already exists in the db");
    }
  }
}
