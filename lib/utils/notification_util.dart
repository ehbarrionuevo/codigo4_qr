import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationUtil {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static initMessaging() async {
    String token = await firebaseMessaging.getToken() ?? "-";
    print(token);

    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  static _onMessage(RemoteMessage message) async {
    print(message);
  }

  static Future _onBackgroundMessage(RemoteMessage message) async {
    print(message);
  }

  static _onMessageOpenedApp(RemoteMessage message) async {
    print(message);
  }
}
