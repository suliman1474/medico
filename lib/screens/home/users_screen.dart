import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medico/core/icons.dart';
import 'package:medico/widgets/user_overview.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Widget> users = [
    UserOverview(
      image: IconConstant.icTopbarProfile,
      name: 'javed',
      email: 'javedkhan',
    ),
    UserOverview(
      image: IconConstant.icTopbarProfile,
      name: 'javed',
      email: 'javedkhan',
    ),
    UserOverview(
      image: IconConstant.icTopbarProfile,
      name: 'javed',
      email: 'javedkhan',
    ),
    UserOverview(
      image: IconConstant.icTopbarProfile,
      name: 'javed',
      email: 'javedkhan',
    ),
    UserOverview(
      image: IconConstant.icTopbarProfile,
      name: 'javed',
      email: 'javedkhan',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return users[index];
        },
      ),
    );
  }
}
