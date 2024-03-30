import 'package:device_info_plus/device_info_plus.dart';
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

  Future<void> _getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      if (await Permission.storage.request().isGranted) {
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.audio.request().isDenied) {}
    } else {
      if (await Permission.photos.request().isGranted) {
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
      } else if (await Permission.photos.request().isDenied) {}
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _getStoragePermission();
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

    return Scaffold(
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
    );
  }
}
