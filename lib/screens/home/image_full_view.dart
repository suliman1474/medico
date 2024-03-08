import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/feed_controller.dart';

class ImageViewScreen extends StatelessWidget {
  String image;
  bool isfile;
  ImageViewScreen({
    super.key,
    required this.image,
    required this.isfile,
  });

  @override
  Widget build(BuildContext context) {
    FeedController feedController = Get.find();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_circle_left_outlined,
            color: Colors.white,
          ),
        ),
        actions: [
          Visibility(
            visible: !isfile,
            child: IconButton(
              onPressed: () {
                feedController.downloadImage(image);
              },
              icon: const Icon(
                Icons.download_for_offline_outlined,
                size: 27,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          child: isfile
              ? Image.file(
                  File(image),
                  fit: BoxFit.scaleDown,
                )
              : Image.network(
                  image,
                  fit: BoxFit.scaleDown,
                ),
        ),
      ),
    );
  }
}
