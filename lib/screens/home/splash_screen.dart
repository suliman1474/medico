import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/app_export.dart';

import '../../controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  DbController dbController = Get.find();
  AuthenticationController authController = Get.find();
  delayMethod() async {
    // ignore: use_build_context_synchronously
    late bool blocked;
    bool loggedIn = await dbController.isLoggedIn();
    if (await InternetConnectionChecker().hasConnection) {
      await authController.fetchUserProfile();
      blocked = await authController.userProfile.value?.blocked ?? false;
    } else {
      blocked = await dbController.isBlocked();
    }

    FlutterNativeSplash.remove();

    if (loggedIn) {
      if (blocked == false) {
        Get.offAllNamed(
          '/home',
        );
      } else {
        Get.offAndToNamed('/blocked');
      }
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
