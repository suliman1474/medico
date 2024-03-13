import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive/hive.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/files_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../../models/folder_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  DbController dbController = Get.find();
  // FilesController filesController = Get.find();
  delayMethod() async {
    // ignore: use_build_context_synchronously
    bool loggedIn = await dbController.isLoggedIn();
    FlutterNativeSplash.remove();

    if (loggedIn) {
      Get.offAllNamed(
        '/home',
      );
    } else {
      Get.offAndToNamed('/login');
    }
    // await Future.delayed(const Duration(seconds: 4));

    // if (loggedIn) {
    //   Get.offAllNamed(
    //     '/home',
    //   );
    // } else {
    //   Get.offAndToNamed('/login');
    // }
    //  Navigator.pushNamed(context, '/');
  }

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   duration: const Duration(seconds: 3),
    //   vsync: this,
    // );
    // CurvedAnimation curvedAnimation = CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeIn, // Replace with the desired curve
    // );
    // _animation = curvedAnimation;
    // _controller.forward();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   filesController.getFolders();
    // });
    delayMethod();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: CircularProgressIndicator(
        color: color1,
      )),
      // body: Center(
      //   child: FadeTransition(
      //     opacity: _animation,
      //     child: CustomImageView(
      //       imagePath: IconConstant.icAppLogo,
      //       height: 250.h,
      //       width: 250.w,
      //     ),
      //   ),
      // ),
    );
  }
}
