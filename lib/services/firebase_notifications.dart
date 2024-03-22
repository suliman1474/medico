import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/constants/user_role.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/models/notification_model.dart';
import 'package:medico/screens/home/notifications_screen.dart';

class FirebaseNotifications {
  final DbController dbController = DbController();

  Future<void> initNotifications() async {
    // String? fcmToken = await FirebaseMessaging.instance.getToken();
    // print('fcmtoken: $fcmToken');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(
      (message) async {},
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dbController.userRole.value == UserRole.USER
          ? onHandleMessage(message)
          : null;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      dbController.userRole.value == UserRole.USER
          ? saveMessage(message)
          : null;
    });
  }

  void saveMessage(RemoteMessage message) async {
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
    await dbController.saveNotification(notification).then((_) {
      Get.to(NotificationsScreen());
    });
  }

  Future<void> onHandleMessage(RemoteMessage message) async {
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
        if (dbController.userRole.value == UserRole.USER) {
          Get.to(NotificationsScreen());
        }
      },
      duration: Duration(seconds: 2),
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      overlayColor: secondryColor,
    );
  }

  // Future<void> onHandleBackgroundMessage(RemoteMessage message) async {
  //   print(message.data);
  //   print(message.messageId);
  //    ;
  // }
}
