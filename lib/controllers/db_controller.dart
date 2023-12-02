import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_model.dart';

class DbController extends GetxController {
  final String userBox = 'user';
  final String isLoggedInBox = 'isLoggedIn';
  final String roleBox = 'role';
  RxString userRole = 'user'.obs;
  // static const String quizAttemptId = 'quiz_attempt_id';
  // static const String quizModelAttempt = 'quiz';
  @override
  Future<void> onReady() async {
    super.onReady();
    await loadUserRole();
  }

  Future<void> initialize() async {
    // await Hive.openBox<Attempt>(Db.attemptsBoxName);
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
  }

  Future<void> storeUser(UserModel user) async {
    var userIdBox = await Hive.openBox<UserModel>(userBox);
    var isLoggedInIdBox = await Hive.openBox(isLoggedInBox);
    var roleIdBox = await Hive.openBox(roleBox);
    print('make is logged in true');
    await isLoggedInIdBox.put('isLoggedIn', true);
    await roleIdBox.put('role', user.role);
    return userIdBox.put('current_user', user);
  }

  Future<UserModel?> getUser() async {
    var userIdBox = await Hive.openBox<UserModel>(userBox);

    return userIdBox.get('current_user');
  }

  Future<void> loadUserRole() async {
    var roleIdBox = await Hive.openBox(roleBox);
    userRole.value = roleIdBox.get('role', defaultValue: 'user');
  }

  Future<bool> isLoggedIn() async {
    var isLoggedInIdBox = await Hive.openBox(isLoggedInBox);
    return isLoggedInIdBox.get('isLoggedIn', defaultValue: false) == true;
  }

  Future<void> signOut() async {
    var isLoggedInIdBox = await Hive.openBox(isLoggedInBox);

    print('Setting isLoggedIn to false');
    await isLoggedInIdBox.put('isLoggedIn', false);

    // You may also want to clear other user-related data when signing out
    // For example, clear the user data from the UserModel box:
    var userIdBox = await Hive.openBox<UserModel>(userBox);
    await userIdBox.clear();
  }
  // static Future<String?> getQuizId() async {
  //   var quizIdBox = await Hive.openBox(Db.quizIdBox);
  //   print(' get quiz id === ${quizIdBox.get('id')}');
  //   return quizIdBox.get('id');
  // }
  //
  // static Future<void> setQuizId(String id) async {
  //   var quizIdBox = await Hive.openBox(Db.quizIdBox);
  //   print('quizid set to : $id');
  //   await quizIdBox.put('id', id);
  // }
  //
  // static Future<int> getQuizAttemptId() async {
  //   var quizIdBox = await Hive.openBox(Db.quizAttemptId);
  //   return quizIdBox.get('id');
  // }
  //
  // static Future<void> setQuizAttemptId(int id) async {
  //   var quizIdBox = await Hive.openBox(Db.quizAttemptId);
  //   print(' ================== set quiz attempt id: $id');
  //   await quizIdBox.put('id', id);
  // }
  //
  // static Future<void> createAttempt(String testId, Attempt attempt) async {
  //   final box = await Hive.openBox<Attempt>(attemptsBoxName);
  //   box.put(testId, attempt);
  //   homeController.setAttempt(attempt);
  //   print('attempts created at test_id: $testId');
  // }
  //
  // static Future<Attempt?> getAttempt(String testId) async {
  //   final box = await Hive.openBox<Attempt>(attemptsBoxName);
  //   // Check if the attempt with the given testId exists in the box
  //   if (box.containsKey(testId)) {
  //     print('yes the box contains the id');
  //     return box.get(testId);
  //   } else {
  //     // Attempt does not exist
  //     print('NO the box doesnt contains the id');
  //
  //     return null;
  //   }
  // }

  ///==========================

  //
  // static Future<void> updateAttempt(String testId, Attempt attempt) async {
  //   final box = await Hive.openBox<Attempt>(attemptsBoxName);
  //   box.put(testId, attempt);
  // }
  //
  // static Future<void> deleteAttempt() async {
  //   final testId = await getQuizId();
  //   final box = await Hive.openBox<Attempt>(attemptsBoxName);
  //   await box.delete(testId);
  // }
  //
  // static Future<List<Attempt>> getAllAttempts() async {
  //   final box = await Hive.openBox<Attempt>(attemptsBoxName);
  //   return box.values.toList();
  // }
  //
  // static Future<void> clearAllAttempts() async {
  //   final box = await Hive.openBox<Attempt>(attemptsBoxName);
  //   await box.clear();
  // }
}
