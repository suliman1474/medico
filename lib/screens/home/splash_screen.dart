import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/widgets/custom_image_view.dart';

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
  delayMethod() async {
    await Future.delayed(const Duration(seconds: 4));
    // ignore: use_build_context_synchronously
    if (await dbController.isLoggedIn()) {
      Get.offAllNamed('/home');
    } else {
      Get.offAndToNamed('/login');
    }
    //  Navigator.pushNamed(context, '/');
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn, // Replace with the desired curve
    );
    _animation = curvedAnimation;
    _controller.forward();
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
        child: FadeTransition(
          opacity: _animation,
          child: CustomImageView(
            imagePath: IconConstant.icAppLogo,
            height: 250.h,
            width: 250.w,
          ),
        ),
      ),
    );
  }
}
