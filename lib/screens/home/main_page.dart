import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/custom_appbar.dart';
import 'package:medico/widgets/custom_bottombar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controllers/screen_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  // var _bottomNavIndex = 0;

  ScreenController screenController = Get.find<ScreenController>();
  FilesController filesController = Get.put(FilesController());
  //DbController dbController = Get.put(DbController());
  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      // Permission already granted, proceed with folder creation
      // Replace with your folder creation logic
    } else {
      var result = await Permission.storage.request();
      if (result.isGranted) {
        // Permission granted after request, proceed with folder creation
        // Replace with your folder creation logic
      } else {
        // Permission denied, handle the denial gracefully
        ;
        // You can show a snackbar or dialog to explain why the permission is needed
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    // final appLifecycleState = WidgetsBinding.instance.lifecycleState;
    // if (appLifecycleState == AppLifecycleState.resumed) {
    //   // App resumed from background
    //
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     filesController.getFolders();
    //   });
    // } else {
    //   // App started fresh or in a different state
    // }

    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        appBar: CustomAppBar(),
        body: Obx(() {
          return screenController.pages[screenController.bottomNavIndex.value];
        }),
        bottomNavigationBar: CustomBottomBar(onChanged: (index) {
          if (index == screenController.bottomNavIndex.value) {
            screenController.assignAll();
          } else {
            setState(() {
              screenController.previousIndex.value =
                  screenController.bottomNavIndex.value;
              screenController.bottomNavIndex.value = index;
            });
          }
        }),
        // floatingActionButton: CustomFloatingButton(),
      ),
    );
  }
}
