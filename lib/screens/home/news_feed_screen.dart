import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/screens/home/add_post_screen.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/indicator.dart';
import 'package:medico/widgets/poll.dart';
import 'package:medico/widgets/post.dart';

import '../../constants/user_role.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/db_controller.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  FeedController feedController = Get.find();
  late Future<List<dynamic>> getPostsAndPolls;
  AuthenticationController authController = Get.find();
  DbController dbController = Get.find();

  void loadUser() async {
    await dbController.loadUserRole();
  }

  Future<void> getdata() async {
    setState(() {
      getPostsAndPolls = feedController.getPostsAndPolls();
    });
    return Future.value();
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    refreshData();
  }

  Future<void> refreshData() async {
    getPostsAndPolls = feedController.getPostsAndPolls();
    Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 10.h,
        ),
        child: RefreshIndicator(
          color: color2,
          onRefresh: () async {
            await refreshData();
            setState(() {});
            return Future.value();
          },
          child: FutureBuilder<List<dynamic>>(
            future: getPostsAndPolls, //orderBy('timestamp', descending: true)
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Indicator.loader());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<dynamic> combinedData = snapshot.data!;
                if (combinedData.isEmpty) {
                  return Center(
                    child: Text('No posts Avaialble'),
                  );
                }

                return ListView.builder(
                  itemCount: combinedData.length,
                  itemBuilder: (context, index) {
                    if (combinedData[index]['type'] == 'post') {
                      return Post(
                        postId: combinedData[index]['id'],
                      );
                    } else if (combinedData[index]['type'] == 'poll') {
                      //  PollModel poll = PollModel.fromJson(combinedData[index]);

                      return Poll(
                        pollId: combinedData[index]['id'],
                      );
                    }

                    return Container();
                  },
                );
              } else {
                return Center(
                  child: Text('No posts Avaialble'),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: dbController.userRole.value == UserRole.ADMIN
          ? Align(
              alignment: Alignment(1.20.w, 1.17.h),
              child: FloatingActionButton(
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
            )
          : null,
    );
  }
}
