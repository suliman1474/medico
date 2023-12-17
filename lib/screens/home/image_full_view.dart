import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_circle_left_outlined,
            color: Colors.white,
          ),
        ),
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
