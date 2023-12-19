import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/text_theme.dart';

import '../models/option_model.dart';
import '../models/poll_model.dart';

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
  List<double> votes = [45, 60, 34, 14];
  int selectedOptionIndex = -1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  double totalVotes = votes.reduce((value, element) => value + element);
    return Obx(() {
      print('updated');
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                poll.question,
                style: customTexttheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Column(
              children: List.generate(options.length, (index) {
                // print(
                //     'options[index].voterId!.length ${options[index].voterId!.length}');
                return PollOptionTile(
                  optiontitle: options[index].title,
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
                      print('clicked same option');
                      selectedOptionIndex = 5;
                      feedController.vote(
                          poll.id, options[index].id, userId, true);
                    } else {
                      print('else vote');
                      selectedOptionIndex = index;
                      print('index clicked: $index');
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

  PollOptionTile({
    required this.optiontitle,
    required this.isSelected,
    required this.onTap,
    required this.value,
    this.votes,
    required this.option,
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
              children: [
                Text(
                  optiontitle,
                  style: customTexttheme.labelSmall!.copyWith(
                    color: textColor,
                  ),
                ),
                Text(
                  votes == null ? '0' : 'Votes: ${votes}',
                  style: customTexttheme.labelSmall!.copyWith(
                    color: textColor,
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
