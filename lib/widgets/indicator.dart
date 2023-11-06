import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Indicator {
  static void showLoading() {
    Get.dialog(
      Center(
        child:
            LoadingAnimationWidget.hexagonDots(color: Colors.white, size: 45),
      ),
    );
  }

  static void closeLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
