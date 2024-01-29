import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medico/constants/user_role.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/core/text_theme.dart';
import 'package:medico/widgets/custom_image_view.dart';

import '../models/option_model.dart';
import '../models/poll_model.dart';
import 'indicator.dart';

class Poll extends StatefulWidget {
  final pollId;

  const Poll({
    super.key,
    required this.pollId,
  });

  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
  FeedController feedController = Get.find();
  DbController dbController = Get.find();
  int selectedOptionIndex = -1;
  bool isPollExpired = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  double totalVotes = votes.reduce((value, element) => value + element);
    return Obx(() {
      PollModel poll = feedController.pollModels
          .firstWhere((poll) => poll.id == widget.pollId);
      List<OptionModel> options = poll.options;
      String userId = FirebaseAuth.instance.currentUser!.uid;

      double totalVotes = 0;
      for (int i = 0; i < options.length; i++) {
        if (options[i].voterId != null) {
          totalVotes += options[i].voterId?.length as num;
          if (options[i].voterId != null) {
            bool voted = options[i].voterId!.contains(userId);
            if (voted) {
              selectedOptionIndex = i;
            }
          }
        }
      }
      // Check if the post is older than 24 hours
      DateTime postCreationTime =
          DateTime.fromMicrosecondsSinceEpoch(int.parse(poll.timestamp!));
      DateTime currentTime = DateTime.now();
      isPollExpired = currentTime.difference(postCreationTime).inHours > 24;

      // int selectedOptionIndex = feedController.selectedOptionIndex.value;
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
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
                                int.parse(poll.timestamp!))),
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
                          Indicator.showDeleteDialogPoll(poll.id);
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
            Padding(
              padding: EdgeInsets.only(top: 10.h, left: 20.w),
              child: Text(
                poll.question,
                style: customTexttheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
              ),
            ),
            Column(
              children: List.generate(options.length, (index) {
                return PollOptionTile(
                  optiontitle: options[index].title,
                  pollId: poll.id,
                  option: options[index],
                  isSelected: selectedOptionIndex == index,
                  // value: 0.5,
                  votes: options[index].voterId!.length,
                  value: totalVotes > 0 && options[index].voterId!.length > 0
                      ? options[index].voterId!.length / totalVotes
                      : 0,
                  //value: totalVotes > 0 ? votes[index] / totalVotes : 0,
                  onTap: () {
                    if (selectedOptionIndex == index) {
                      selectedOptionIndex = 5;
                      feedController.vote(
                          poll.id, options[index].id, userId, true);
                    } else {
                      selectedOptionIndex = index;

                      feedController.vote(
                          poll.id, options[index].id, userId, false);
                    }
                  },
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}

class PollOption {
  final String text;

  PollOption(this.text);
}

class PollOptionTile extends StatelessWidget {
  final String optiontitle;
  final bool isSelected;
  final VoidCallback onTap;
  final double value;
  final int? votes;
  final OptionModel option;
  final String pollId;
  PollOptionTile({
    required this.optiontitle,
    required this.isSelected,
    required this.onTap,
    required this.value,
    this.votes,
    required this.option,
    required this.pollId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      tileColor: Colors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  optiontitle,
                  style: customTexttheme.labelSmall!
                      .copyWith(color: textColor, fontSize: 17.sp),
                ),
                GestureDetector(
                  onTap: () {
                    Indicator.openbottomSheetVotes(pollId, option);
                  },
                  child: Text(
                    votes == null ? 'Votes: 0' : 'Votes: ${votes}',
                    style: customTexttheme.labelSmall!
                        .copyWith(color: textColor, fontSize: 17.sp),
                  ),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: value,
            color: color2,
            borderRadius: BorderRadius.circular(5).r,
            backgroundColor: Colors.white,
            minHeight: 6.h,
          )
        ],
      ),
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? color2 : color2,
      ),
    );
  }
}
