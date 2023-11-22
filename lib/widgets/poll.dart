import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/colors.dart';
import 'package:medico/core/text_theme.dart';

class Poll extends StatefulWidget {
  const Poll({super.key});

  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
  List<PollOption> options = [
    PollOption("Very Good"),
    PollOption("Good"),
    PollOption("Average"),
    PollOption("Poor"),
  ];

  List<double> votes = [45, 60, 34, 14];

  int selectedOptionIndex = -1;
  @override
  Widget build(BuildContext context) {
    double totalVotes = votes.reduce((value, element) => value + element);
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
              'How was the paper?',
              style: customTexttheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: List.generate(
              options.length,
              (index) => PollOptionTile(
                option: options[index],
                isSelected: selectedOptionIndex == index,
                value: totalVotes > 0 ? votes[index] / totalVotes : 0,
                onTap: () {
                  setState(() {
                    selectedOptionIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PollOption {
  final String text;

  PollOption(this.text);
}

class PollOptionTile extends StatelessWidget {
  final PollOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final double value;

  PollOptionTile({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.value,
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
            child: Text(
              option.text,
              style: customTexttheme.labelSmall!.copyWith(
                color: textColor,
              ),
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
