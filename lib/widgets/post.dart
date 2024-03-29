import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medico/constants/user_role.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/app_export.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/screens/home/image_full_view.dart';
import 'package:medico/widgets/custom_image_view.dart';
import 'package:medico/widgets/indicator.dart';

import '../controllers/db_controller.dart';
import '../models/post_model.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  final postId;
  Post({
    super.key,
    required this.postId,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  FeedController feedController = Get.find();
  DbController dbController = Get.find();
  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String formatLikeCount(int? likeCount) {
    if (likeCount == null) {
      return '0';
    }

    if (likeCount < 1000) {
      return likeCount.toString();
    } else if (likeCount < 1000000) {
      return '${(likeCount / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(likeCount / 1000000).toStringAsFixed(1)}M';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      PostModel post = feedController.postModels
          .firstWhere((post) => post.id == widget.postId);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      // feedController.isLiked.value = post.like?.contains(userId) ?? false;

      bool isLiked = post.like?.contains(userId) ?? false;

      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        padding:
            EdgeInsets.only(top: 10.h, bottom: 0.h, left: 10.w, right: 10.w),
        width: 379.w,
        decoration: BoxDecoration(
          color: secondryColor,
          borderRadius: BorderRadius.circular(20).r,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CustomImageView(
                    imagePath: IconConstant.icAppLogo,
                    height: 40.h,
                    width: 40.w,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(20).r,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medico Slides',
                        style: customTexttheme.displayLarge,
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy hh:mma').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                int.parse(post.timestamp!))),
                        // DateFormat('dd-MM-yyyy hh:mma').format(DateTime.now()),
                        style: customTexttheme.bodySmall!.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 120.w),
                dbController.userRole.value == UserRole.ADMIN
                    ? GestureDetector(
                        onTap: () {
                          Indicator.showDeleteDialogPost(post.id);
                        },
                        child: Icon(
                          Icons.delete,
                          size: 25.sp,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            Container(
              child: post.description != null && post.description!.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 35.w,
                        vertical: 10.h,
                      ),
                      child: Text(
                        post.description! ?? '',
                        style: customTexttheme.bodyLarge,
                      ),
                    )
                  : SizedBox(height: 10.h),
            ),
            post.images != null && post.images!.isNotEmpty
                ? post.images!.length > 1
                    ? Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 40.w,
                              vertical: 5.h,
                            ),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 16 / 20,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                autoPlay: false,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),
                              items: post.images!.map((image) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      ImageViewScreen(
                                        image: image,
                                        isfile: false,
                                      ),
                                    );
                                  },
                                  onDoubleTap: () {
                                    if (post.like!.contains(userId)) {
                                      post.like?.remove(userId);
                                    } else {
                                      post.like?.add(userId);
                                    }
                                    feedController.isLiked.value = !isLiked;
                                    feedController.likePost(post.id, userId);
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.scaleDown,
                                    imageUrl: image,
                                    placeholder: (context, url) => Image(
                                      image: AssetImage(
                                          IconConstant.placeHolderImage),
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                          IconConstant.placeHolderImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: post.images!.map((image) {
                                int index = post.images!.indexOf(image);
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == index
                                        ? Colors.black
                                        : const Color.fromRGBO(
                                            206, 206, 206, 1),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 5.h,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              ImageViewScreen(
                                image: post
                                    .images!.first, // Assuming only one image
                                isfile: false,
                              ),
                            );
                          },
                          onDoubleTap: () {
                            if (post.like!.contains(userId)) {
                              post.like?.remove(userId);
                            } else {
                              post.like?.add(userId);
                            }
                            feedController.isLiked.value = !isLiked;
                            feedController.likePost(post.id, userId);
                          },
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: post.images!.first,
                            placeholder: (context, url) => Image(
                              image: AssetImage(IconConstant.placeHolderImage),
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image(
                              image: AssetImage(IconConstant.placeHolderImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                : const SizedBox.shrink(),
            Divider(
              indent: 20.w,
              endIndent: 20.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (dbController.userRole.value == UserRole.USER) {
                        // if user cllicks on like then update that
                        if (post.like!.contains(userId)) {
                          post.like?.remove(userId);
                        } else {
                          post.like?.add(userId);
                        }
                        feedController.isLiked.value = !isLiked;
                        feedController.likePost(post.id, userId);
                      } else {
                        // IF ADMIN CLICKS ON LIKE BUTTON HE SHOULD SEE ALL USERS WHO'VE LIKED THE POST

                        Indicator.openbottomSheetLike(post);
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.only(right: 0.w, left: 0.w, bottom: 5.h),
                      child: isLiked == true
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_border),
                    ),
                  ),
                  Text(
                    formatLikeCount(post.like?.length),
                    // post.like?.length.toString() ?? '0',
                    style: customTexttheme.bodySmall!.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      color: isLiked == true ? Colors.red : textColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
