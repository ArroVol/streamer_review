import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // FirebaseMessaging Token for Android
      String token = await _firebaseMessaging.getToken();
      print('FirebaseMessaging token: $token');

      _initialized = true;
    }
  }
}
