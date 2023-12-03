import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medico/core/app_export.dart';

class Indicator {
  static void showLoading() {
    Get.dialog(
      Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: color1,
          rightDotColor: color2,
          size: 40,
        ),
      ),
    );
  }

  static void closeLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
