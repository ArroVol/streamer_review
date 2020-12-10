import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'custom_route.dart';
import 'helper/database_helper.dart';
import 'main_screen.dart';
import 'model/user.dart';

/// The build for the register app
class RegisterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retrieve Text Input',
      home: Register(),
    );
  }
}

/// Define a custom Form widget.
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

  String userTaken = 'The username is already taken';
  String phoneTaken = 'The mobile number is already taken';
  String complete = 'Your account has been registered';
  String displayText = '';

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final FocusNode fOne = FocusNode();
  final FocusNode fTwo = FocusNode();

  // The widget for the register page.
  @override
  Widget build(BuildContext context) {

    final usernameField = TextField(
      style: TextStyle(color: Colors.black),
      focusNode: fOne,
      onSubmitted: (value) {
        print(value);
        userName = value;
        fOne.unfocus();
        FocusScope.of(context).requestFocus(fTwo);
      },
      onChanged: (userNameOnChanged){
        userNameUnSubmitted = userNameOnChanged;
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Enter a username',
      ),
      // keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.deny(' '),
        LengthLimitingTextInputFormatter(16),
        WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
      ],
      autofocus: true,
    );

    final confirmPhoneNumber = TextField(
      // textInputAction: TextInputAction.go,
      focusNode: fTwo,
      onSubmitted: (value) {
        print(value);
        phoneNumber = value;
        DatabaseHelper2 d = DBHelper.DatabaseHelper2.instance;
        // checkPhoneNumber(value);
      },
      onChanged: (phoneNumberOnChanged){
       phoneNumberUnSubmitted = phoneNumberOnChanged;
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.phone_android),
        hintText: 'Enter your mobile number',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      style: TextStyle(color: Colors.black),
      autofocus: true,
    );

    // the login button
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightGreenAccent,
      // color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        textColor: Colors.lightGreenAccent,
        onPressed: () {
          print('pressed login button');
          checkFields();
          final snackBar = SnackBar(
            content: Text(displayText.toString()),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text(
          "Complete Registration",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Finalize Account',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Colors.lightGreenAccent,
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 115.0),
                Text(
                  "Username",
                  style: TextStyle(
                    letterSpacing: 2.0,
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
                    letterSpacing: 2.0,
                    fontSize: 22.0,
                    color: Colors.lightGreenAccent,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                confirmPhoneNumber,
                SizedBox(height: 25.0),
                loginButon,

              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[700],

    );
  }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {},
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
      displayText = userTaken;
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
      displayText = phoneTaken;
    }
  }

  /// This method verifies what user setting is to be updated.
  void checkVerified() async {
    String email = await secureStorage.readSecureData("email");
    sleep(const Duration(seconds:1));

    print(userNameVerified);
    print(phoneVerified);
    if (userNameVerified && phoneVerified) {
      print("verified");
      secureStorage.writeSecureData('userName', userName);
      secureStorage.writeSecureData('phoneNumber', phoneNumber);
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
      Navigator.of(context).pushReplacement(FadePageRoute(
        builder: (context) => MainScreen(),
      ));
    } else {
      print('fields arent completed');
    }
  }

  /// This method checks both of the fields for updates.
  void checkFields() async {
    if(phoneNumber != null) {
      print("not null number...");
     await checkPhoneNumber(phoneNumber);
    }

    if(userName == null && userNameUnSubmitted != null){
      print("switching for onchanged for user name");
      userName = userNameUnSubmitted;
      print(userName);
    }
    print('user name: $userName');
    if(userName != null) {
     await checkUserName(userName);
    }

    await checkVerified();
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

/// The snackbar widget.
///
/// This displays whether or not the profile was updated.
class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Show SnackBar', style: TextStyle(fontSize: 25.0),),
        textColor: Colors.white,
        color: Colors.redAccent,
        padding: EdgeInsets.all(8.0),
        splashColor: Colors.grey,
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('Hey! This is a SnackBar message.'),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }
}
