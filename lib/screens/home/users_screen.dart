import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medico/controllers/search_controller.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/widgets/indicator.dart';
import 'package:medico/widgets/user_overview.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  UserSearchController searchController = Get.find();
  // late Future<List<UserModel>> users;
  @override
  void initState() {
    // TODO: implement initState
    // users = searchController.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserSearchController>(builder: (controller) {
      return FutureBuilder<List<UserModel>>(
        future: searchController.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Indicator.loader());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Data is ready
            searchController.filteredUsers.value =
                snapshot.data as List<UserModel>;
            print(searchController.search.value.text);

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: ListView.builder(
                itemCount: searchController.filteredUsers.length,
                itemBuilder: (context, index) {
                  var user = searchController.filteredUsers[index];
                  print(user.name);
                  return UserOverview(user: user, bottomsheet: false);
                },
              ),
            );
          }
        },
      );
    });
  }
}
