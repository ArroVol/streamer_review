
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:streamer_review/model/user.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.id);
    prefs.setString("password", user.password);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phoneNumber);
    prefs.setString("userName", user.userName);
    // prefs.setString("type", user.type);
    // prefs.setString("token", user.token);
    // prefs.setString("renewalToken", user.renewalToken);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int userId = prefs.getInt("userId");
    String userName = prefs.getString("userName");
    String email = prefs.getString("email");
    String phoneNumber = prefs.getString("phoneNumber");
    String password = prefs.getString("password");
    String type = prefs.getString("type");
    String token = prefs.getString("token");
    String renewalToken = prefs.getString("renewalToken");

    return User(
        id: userId,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        password: password);
    // type: type,
    // token: token,
    // renewalToken: renewalToken);
    //     ;
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("userName");
    prefs.remove("email");
    prefs.remove("phoneNumber");
    prefs.remove("password");
    prefs.remove("type");
    prefs.remove("token");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
