import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/models/notification_model.dart';
import 'package:medico/widgets/indicator.dart';
import 'package:medico/widgets/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  DbController dbController = Get.find();
  ScreenController screenController = Get.find();
  late Future<List<NotificationModel>> notifications;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // notifications = dbController.getNotifications();
    refreshData();
  }

  Future<void> refreshData() async {
    notifications = dbController.getNotifications();
    Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_circle_left_outlined,
            color: color1,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: customTexttheme.titleLarge,
        ),
      ),
      body: RefreshIndicator(
        color: color2,
        onRefresh: () async {
          await refreshData();
          setState(() {});
          return Future.value();
        },
        child: FutureBuilder<List<NotificationModel>>(
          future: notifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Indicator.loader(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Indicator.loader(),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No notifications',
                  style: customTexttheme.titleLarge,
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final notification = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      screenController.bottomNavIndex.value = 1;
                      Get.back();
                    },
                    child: NotificationWidget(
                      title: notification.title,
                      body: notification.body,
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
