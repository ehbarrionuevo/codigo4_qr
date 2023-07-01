import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationUtil {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static initMessaging() async {
    String token = await firebaseMessaging.getToken() ?? "-";
    print(token);
    firebaseMessaging.subscribeToTopic("MANDARINA");
    firebaseMessaging.subscribeToTopic("MANTEQUILLA");
    FirebaseMessaging.onMessage.listen(_onMessage);
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  static _onMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);
    }
  }

  static Future _onBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);
    }
  }

  static _onMessageOpenedApp(RemoteMessage message) async {
    if (message.notification != null) {
      print(message.notification!.title);
      print(message.notification!.body);
    }
  }
}
