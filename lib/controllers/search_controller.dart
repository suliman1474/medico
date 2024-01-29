import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/models/user_model.dart';
import 'package:medico/widgets/indicator.dart';

class UserSearchController extends GetxController {
  RxList<UserModel> users = <UserModel>[].obs;
  Rx<TextEditingController> search = TextEditingController().obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  @override
  void onReady() {
    // Observe changes in the 'users' list and update 'filteredUsers'
    // allusers.value = getAllUsers();
    users.clear();
    getAllUsers();

    super.onReady();
  }

  // Function to fetch all users from the 'users' collection
  Future<void> getAllUsers() async {
    try {
      Indicator.showLoading();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      users.clear();
      filteredUsers.clear();
      querySnapshot.docs.forEach((doc) {
        users.add(UserModel.fromJson(doc.data() as Map<String, dynamic>));
      });
      filteredUsers.addAll(users);
      update();
      Indicator.closeLoading();
      //return filteredUsers;
    } catch (error) {
      throw error;
    }
  }

  Future<void> searchUsers(String username) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: username)
          .where('name', isLessThan: username + 'z')
          .get();
      List<UserModel> users = [];

      users.assignAll(
        querySnapshot.docs
            .map(
                (doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );
      // allusers.value = Future.value(users.toList());
    } catch (error) {
      throw error;
    }
  }

  void filterUsers(String username) {
    if (username.isEmpty) {
      // If the search query is empty, show all users
      filteredUsers.value = users;
    } else {
      // Filter users based on the search query

      search.value.text = username;

      filteredUsers.value = users
          .where((user) =>
              user.name.toLowerCase().contains(username.toLowerCase()))
          .toList();

      update();
    }
  }

  void filterUsersbyCollege(String college) {
    if (college.isEmpty) {
      // If the search query is empty, show all users
      filteredUsers.value = users;
    } else {
      // Filter users based on the search query
      print('updatiing the obx');
      print('users length in filtering functin: ${users.length}');
      search.value.text = college;
      print('filtered user length before filter: ${filteredUsers.length}');

      filteredUsers.value = users
          .where((user) =>
              user.college.toLowerCase().contains(college.toLowerCase()))
          .toList();
      print('filtered user length after filter: ${filteredUsers.length}');
      update();
    }
  }

  void filterUsersbyDiscipline(String discipline) {
    if (discipline.isEmpty) {
      // If the search query is empty, show all users
      filteredUsers.value = users;
    } else {
      // Filter users based on the search query
      print('updatiing the obx');
      print('users length in filtering functin: ${users.length}');
      search.value.text = discipline;
      print('filtered user length before filter: ${filteredUsers.length}');

      filteredUsers.value = users
          .where((user) =>
              user.discipline.toLowerCase().contains(discipline.toLowerCase()))
          .toList();
      print('filtered user length after filter: ${filteredUsers.length}');
      update();
    }
  }

  void filterUsersbySemester(String semester) {
    if (semester.isEmpty) {
      // If the search query is empty, show all users
      filteredUsers.value = users;
    } else {
      // Filter users based on the search query
      print('updatiing the obx');
      print('users length in filtering functin: ${users.length}');
      search.value.text = semester;
      print('filtered user length before filter: ${filteredUsers.length}');

      filteredUsers.value = users
          .where((user) =>
              user.semester.toLowerCase().contains(semester.toLowerCase()))
          .toList();
      print('filtered user length after filter: ${filteredUsers.length}');
      update();
    }
  }
}
