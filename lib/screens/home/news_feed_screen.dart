import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/screens/home/add_post_screen.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/poll.dart';
import 'package:medico/widgets/post.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  FeedController feedController = Get.find();
  late Future<List<dynamic>> getPostsAndPolls;

  @override
  void initState() {
    super.initState();

    getPostsAndPolls = feedController.getPostsAndPolls();
  }

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  FeedController feedController = Get.find();
  late Future<List<dynamic>> getPostsAndPolls;

  @override
  void initState() {
    super.initState();

    getPostsAndPolls = feedController.getPostsAndPolls();
  }

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  Widget build(BuildContext context) {
    // List<Widget> posts = [
    //   Post(
    //     post:
    //         'Bs Nursing first Sem result will be issued in first week of september',
    //   ),
    //   Post(
    //     image: IconConstant.icTopbarProfile,
    //   ),
    //   Poll(),
    // ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: FutureBuilder<List<dynamic>>(
          future: getPostsAndPolls, //orderBy('timestamp', descending: true)
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
      floatingActionButton: Align(
        alignment: Alignment(1.12.w, 1.05.h),
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
      ),
    );
  }
}
