import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medico/models/user_model.dart';

class UserSearchController extends GetxController {
  RxList<UserModel> users = <UserModel>[].obs;
  Rx<TextEditingController> search = TextEditingController().obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  @override
  void onInit() {
    // Observe changes in the 'users' list and update 'filteredUsers'
    // allusers.value = getAllUsers();
    super.onInit();
  }

  // Function to fetch all users from the 'users' collection
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      users.clear();
      querySnapshot.docs.forEach((doc) {
        users.add(UserModel.fromJson(doc.data() as Map<String, dynamic>));
      });
      print('users length:  ${users.length}');
      return users;
    } catch (error) {
      print('Error fetching users: $error');
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
      print('Error searching users: $error');
      throw error;
    }
  }
}
