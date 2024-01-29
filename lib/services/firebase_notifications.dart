import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/models/notification_model.dart';
import 'package:medico/screens/home/notifications_screen.dart';

class FirebaseNotifications {
  final DbController dbController = DbController();

  Future<void> initNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(
      (message) => onHandleBackgroundMessage(message),
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onHandleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      saveMessage(message);
    });
  }

  void saveMessage(RemoteMessage message) {
    print('title: ${message.notification!.title}');
    print('body: ${message.notification!.body}');

    print('....on handle message opened app');

    // Extract relevant information from the message
    String title = message.notification?.title ?? "No Title";
    String body = message.notification?.body ?? "No Body";
    String timestamp = DateTime.now().toUtc().microsecondsSinceEpoch.toString();

    // Create a NotificationModel instance
    NotificationModel notification = NotificationModel(
      title: title,
      body: body,
      timestamp: timestamp,
    );

    // Store the notification locally using Hive
    dbController.saveNotification(notification);

    // Get.to(NotificationsScreen());
  }

  Future<void> onHandleMessage(RemoteMessage message) async {
    print('title: ${message.notification!.title}');
    print('body: ${message.notification!.body}');

    print('....on handle message');

    String title = message.notification?.title ?? "No Title";
    String body = message.notification?.body ?? "No Body";
    String timestamp = DateTime.now().toUtc().microsecondsSinceEpoch.toString();

    // Create a NotificationModel instance
    NotificationModel notification = NotificationModel(
      title: title,
      body: body,
      timestamp: timestamp,
    );

    // Store the notification locally using Hive
    await dbController.saveNotification(notification);

    Get.snackbar(
      'Notification',
      '$title\n$body',
      onTap: (snack) {
        Get.to(NotificationsScreen());
      },
      colorText: textColor,
      snackPosition: SnackPosition.TOP,
      backgroundColor: secondryColor,
    );
  }

  Future<void> onHandleBackgroundMessage(RemoteMessage message) async {
    print(message.data);
    print(message.messageId);
    print('...notification received');
  }
}
