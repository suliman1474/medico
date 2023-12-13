import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/screens/home/add_post_screen.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/poll.dart';
import 'package:medico/widgets/post.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> posts = [
      Post(
        post:
            'Bs Nursing first Sem result will be issued in first week of september',
      ),
      Post(
        image: IconConstant.icTopbarProfile,
      ),
      Poll(),
    ];
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return posts[index];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddPostScreen());
        },
        backgroundColor: Colors.transparent,
        shape: CircleBorder(),
        elevation: 0,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: CustomImageView(
          svgPath: IconConstant.icAdd,
          height: 40.h,
          width: 40.w,
        ),
      ),
    );
  }
}
