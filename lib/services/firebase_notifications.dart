import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  Future<void> initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(
      (message) => onHandleBackgroundMessage(message),
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }
}

Future<void> onHandleBackgroundMessage(RemoteMessage message) async {
  print(message.data);
  print(message.messageId);
}
