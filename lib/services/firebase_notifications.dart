import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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
      (message) async {
        print('on background message received');
        print('title: ${message.notification!.title}');
        print('body: ${message.notification!.body}');
        print('....saving notification');

        // Extract relevant information from the message
        String title = message.notification?.title ?? "No Title";
        String body = message.notification?.body ?? "No Body";
        String timestamp =
            DateTime.now().toUtc().microsecondsSinceEpoch.toString();

        // Create a NotificationModel instance
        NotificationModel notification = NotificationModel(
          title: title,
          body: body,
          timestamp: timestamp,
        );

        // Store the notification locally using Hive
        await dbController.saveNotification(notification);
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onHandleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // saveMessage(message);
      Get.to(NotificationsScreen());
    });
  }

  // void saveMessage(RemoteMessage message) async {
  // print('title: ${message.notification!.title}');
  // print('body: ${message.notification!.body}');

  // print('....on handle message opened app');

  // // Extract relevant information from the message
  // String title = message.notification?.title ?? "No Title";
  // String body = message.notification?.body ?? "No Body";
  // String timestamp = DateTime.now().toUtc().microsecondsSinceEpoch.toString();

  // // Create a NotificationModel instance
  // NotificationModel notification = NotificationModel(
  //   title: title,
  //   body: body,
  //   timestamp: timestamp,
  // );

  // // Store the notification locally using Hive
  // await dbController.saveNotification(notification);

  // Get.to(NotificationsScreen());
  // }

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
      duration: Duration(seconds: 10),
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      overlayColor: secondryColor,
    );
  }

  // Future<void> onHandleBackgroundMessage(RemoteMessage message) async {
  //   print(message.data);
  //   print(message.messageId);
  //   print('...notification received');
  // }
}
