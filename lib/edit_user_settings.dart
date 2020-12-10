import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamer_review/profile.dart';
import 'package:streamer_review/secure_storage/secure_storage.dart';
import 'package:streamer_review/helper/database_helper.dart' as DBHelper;
import 'custom_route.dart';
import 'helper/database_helper.dart';
import 'main_screen.dart';
import 'model/user.dart';

/// Creates the state to edit user settings.
class EditUserSettings extends StatefulWidget {
  @override
  _EditUserSettings createState() => _EditUserSettings();
}

/// The class that controls the user's edits to their account.
class _EditUserSettings extends State<EditUserSettings> {
  bool verifiedRegistration = false;

  final SecureStorage secureStorage = SecureStorage();
  User updatedUser = new User();

  bool phoneVerified = false;
  bool userNameVerified = false;
  bool changed = false;

  String userName;
  String phoneNumber;

  String userTaken = 'The username is already taken';
  String phoneTaken = 'The mobile number is already taken';
  String updated = 'Your account has been updated';
  String displayText = '';

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final myController2 = TextEditingController();


  /// Builds the account edit widget.
  @override
  Widget build(BuildContext context) {
    // The text field to enter in a new username.
    final usernameField = TextField(
      style: TextStyle(color: Colors.black),

      controller: myController,
      onSubmitted: (value) {
        print(value);
        userName = value;
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Enter new username',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(' '),
        LengthLimitingTextInputFormatter(16),
        WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
      ],
      autofocus: true,
    );

    // The text field to enter in a new mobile number.
    final confirmPhoneNumber = TextField(
      controller: myController2,
      onSubmitted: (value) {
        print(value);
        phoneNumber = value;
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.phone_android),
        hintText: 'Enter new mobile number',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      style: TextStyle(color: Colors.black),
      autofocus: true,
    );

    // The login button that controls the snack bar
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.lightGreenAccent,
      // color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        textColor: Colors.lightGreenAccent,
        onPressed: () async {
          print('pressed confirm button');
          await checkFields();
          sleep(const Duration(milliseconds: 400));
          final snackBar = SnackBar(
            content: Text(displayText.toString()),
            duration: Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
          clearText();
          // Profile();
        },
        child: Text(
          "Accept Changes",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 20),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit User Settings',
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
                  "Change Username",
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
                  "Change Phone number",
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

  // alert dialog box.
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        // Navigator.of(context).pop(true);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change Settings"),
      content: Text("Are you sure you want to change your settings??"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Future.delayed(Duration(seconds: 8), () {
        //   Navigator.of(context).pop(true);
        // });
        return alert;
      },
    );
  }

  // showDialog(
  // context: context,
  // builder: (context) {
  // Future.delayed(Duration(seconds: 5), () {
  // Navigator.of(context).pop(true);
  // });
  // return AlertDialog(
  // title: Text('Title'),
  // );
  // });

  // Checks the username and phone number fields for input.
  void checkFields() async {
    if (userName == null) {
      print("username is null");
    } else {
      print('user name: $userName');
      await checkUserName(userName);
    }

    if (phoneNumber == null) {
      print("null number...");
    } else {
      print(phoneNumber);
      await checkPhoneNumber(phoneNumber);
    }
    checkVerified();
  }

  // Clears the text on submission of both text fields.
  void clearText() {
    myController.clear();
    myController2.clear();
  }

  /// This method checks to see if the user entered a phone number that already exists in the DB
  ///
  /// [userName], the user name of the user.
  Future<bool> checkUserName(String userName) async {
    String email = await secureStorage.readSecureData("email");
    print("in user check");
    if (!await DatabaseHelper2.instance.userRepository.checkByUserName(userName)) {
      print("the user name doesnt exist");
      userNameVerified = true;
      print("done");
      displayText = updated;
    } else {
      print("the user name already exists");
      displayText = userTaken;
      userNameVerified = false;
    }
  }

  /// This method checks to see if the user entered a phone number that already exists in the DB
  ///
  /// [phoneNumber], the phoneNumber of the user.
  Future<bool> checkPhoneNumber(String phoneNumber) async {
    String email = await secureStorage.readSecureData("email");
    print("in phone check");
    print(phoneNumber);
    if (!await DatabaseHelper2.instance.userRepository
        .checkByPhoneNumber(phoneNumber)) {
      print("the phone Number doesnt exist");
      phoneVerified = true;
      print("done again ");
      displayText = updated;

    } else {
      displayText = phoneTaken;
      print("the phone number already exists in the db");
      phoneVerified = false;
    }
    return phoneVerified;
  }

  /// This class places the verified changes, if any, into an updated user and then into the database.
  void checkVerified() async {
    String email = await secureStorage.readSecureData("email");
    sleep(const Duration(milliseconds: 1200));
    print(userNameVerified);
    print(phoneVerified);
    if (userNameVerified) {
      print("username verified");
      print(userName);
      secureStorage.writeSecureData('userName', userName);
      List<User> pulledUser =
      await DatabaseHelper2.instance.getUserByEmail(email);
      print(pulledUser.first.phoneNumber);
      print(pulledUser.first.id);
      updatedUser.email = pulledUser.first.email;
      updatedUser.password = pulledUser.first.password;
      updatedUser.userName = userName;
      updatedUser.id = pulledUser.first.id;
      updatedUser.phoneNumber = pulledUser.first.phoneNumber;
      await DatabaseHelper2.instance.updateUser(updatedUser);
      changed = true;
      Profile().createState().setState(() {
      });
      // Profile().createState().setState(() {
      // });
    }
      if (phoneVerified) {
        print("phone verified");
        secureStorage.writeSecureData('phoneNumber', phoneNumber);
        List<User> pulledUser =
            await DatabaseHelper2.instance.getUserByEmail(email);
        print(pulledUser.first.phoneNumber);
        print(pulledUser.first.id);
        updatedUser.email = pulledUser.first.email;
        updatedUser.password = pulledUser.first.password;
        updatedUser.userName = pulledUser.first.userName;
        updatedUser.id = pulledUser.first.id;
        updatedUser.phoneNumber = phoneNumber;
        await DatabaseHelper2.instance.updateUser(updatedUser);
        changed = true;
        // Profile().createState().setState(() {
        // });
      } else {
        print('phone num not verified');
      }

      if(changed){
        // Navigator
        //     .of(context)
        //     .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Profile()));
        // Navigator.of(context).pushReplacement(FadePageRoute(
        //   builder: (context) => Profile(),
        // ));
      }
    }


  // The list of categories for tags.
  List<String> categories = [
    'Gaming',
    'Food & Drinks',
    'Sports & Fitness',
    'Talk Shows & Podcasts',
    'Just Chatting',
    'Makers & Crafting',
    'Tabletop RPGs',
    'Science & Technologies',
    'Music & Performing Arts',
    'Beauty & Body Art'
  ];
}

// class SnackBarPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: RaisedButton(
//         child: Text(
//           'Show SnackBar',
//           style: TextStyle(fontSize: 25.0),
//         ),
//         textColor: Colors.white,
//         color: Colors.redAccent,
//         padding: EdgeInsets.all(8.0),
//         splashColor: Colors.grey,
//         onPressed: () {
//           final snackBar = SnackBar(
//             content: Text('Hey! This is a SnackBar message.'),
//             duration: Duration(seconds: 5),
//             action: SnackBarAction(
//               label: 'Undo',
//               onPressed: () {
//                 // Some code to undo the change.
//               },
//             ),
//           );
//           Scaffold.of(context).showSnackBar(snackBar);
//         },
//       ),
//     );
//   }
// }
