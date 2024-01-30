import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/models/folder_model.dart';
import 'package:medico/models/notification_model.dart';
import 'package:path_provider/path_provider.dart';

import '../models/file_model.dart';
import '../models/user_model.dart';

class DbController extends GetxController {
  final String userBox = 'user';
  final String isLoggedInBox = 'isLoggedIn';
  final String roleBox = 'role';
  final String profileBox = 'profile_image';
  final String notificationBox = 'notifications';
  final String foldersBox = 'myfolders';
  RxString userRole = 'user'.obs;
  RxList<FolderModel> hiveFolders = <FolderModel>[].obs;
  RxBool isInternet = true.obs;
  // FilesController filesController = Get.find();
  // static const String quizAttemptId = 'quiz_attempt_id';
  // static const String quizModelAttempt = 'quiz';
  @override
  Future<void> onInit() async {
    super.onInit();
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      isInternet.value = true;
    } else {
      isInternet.value = false;
      //  print(InternetConnectionChecker().lastTryResults);
    }
    // await initialize();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await loadUserRole();
    await assignHiveFolders();
  }

  Future<void> assignHiveFolders() async {
    hiveFolders.clear();

    var hiveBox = await Hive.openBox(foldersBox);

    if (!hiveBox.containsKey('root')) {
      print('download root folder');
      downloadRootFolder();
      // var rootFolder = FolderModel(
      //   id: '9876543210',
      //   name: 'Root Folder',
      //   path: '/folders',
      //   subFolders: [],
      //   actualSubfolders: [],
      //   parentId: '',
      // );
      // hiveFolders.add(rootFolder);
      //
      // hiveBox.put('root', hiveFolders);
      // hiveBox.close();
    } else {
      // List<FolderModel>? temp = hiveBox.get('root');
      var hiveBox = await Hive.openBox(foldersBox);
      List<dynamic>? temp = hiveBox.get('root');
      hiveFolders.value = List.from(temp as Iterable);

      if (hiveFolders.length > 0) {
      } else {}
      //   hiveBox.close();
    }
  }

  Future<void> getAllHiveFolders() async {
    var hiveBox = await Hive.openBox(foldersBox);
    List<dynamic>? temp = hiveBox.get('root');
    hiveFolders.value = List.from(temp as Iterable);

    //  hiveBox.close();
  }

  Future<void> deleteAllHiveFolders() async {
    var hiveBox = await Hive.openBox(foldersBox);

    // Clear all data in the box
    await hiveBox.clear();

    // hiveBox.close();
  }

  // Future<List<FolderModel>> storeFolder(FolderModel folder) async {
  //   var userIdBox = await Hive.openBox<FolderModel>(foldersBox);
  // }
  Future<void> updateHiveFolders(List<FolderModel> updated) async {
    var hiveBox = await Hive.openBox(foldersBox);
    hiveBox.put('root', hiveFolders);
  }

  Future<void> storeFolder(FolderModel newFolder) async {
    try {
      var hiveBox = await Hive.openBox(foldersBox);

      // Check if the root folder exists

      if (hiveBox.containsKey('root')) {
        int folderIndex = hiveFolders
            .indexWhere((element) => element.id == newFolder.parentId);

        FolderModel temp = hiveFolders[folderIndex];
        temp.actualSubfolders?.add(newFolder);
        temp.subFolders?.add(newFolder.id);
        hiveFolders[folderIndex] = temp;
        hiveFolders.add(newFolder);

        update();
        // hiveFolders.value = rootFolder;
        hiveBox.put('root', hiveFolders);
      } else {
        // Create the root folder with the new folder as its child

        // var rootFolder = FolderModel(
        //   id: '9876543210',
        //   name: 'Root Folder',
        //   path: '/folders',
        //   subFolders: newFolder.subFolders,
        //   actualSubfolders: [newFolder],
        //   parentId: '',
        // );

        // Save the root folder in Hive
        hiveFolders.add(newFolder);
        hiveBox.put('root', hiveFolders);
      }

      // Store the new folder in Hive
      //  hiveBox.put(newFolder.id, newFolder);

      // Close Hive box
      // await hiveBox.close();
    } catch (e) {}
  }

  Future<void> initialize() async {
    // await Hive.openBox<Attempt>(Db.attemptsBoxName);
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(NotificationModelAdapter());
    Hive.registerAdapter(FolderModelAdapter());
    Hive.registerAdapter(FileModelAdapter());
  }

  Future<void> saveNotification(NotificationModel notification) async {
    final box = await Hive.openBox(notificationBox);
    try {
      print('saving notification');
      await box.add(notification);
    } finally {
      await box.close();
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    final box = await Hive.openBox<NotificationModel>(notificationBox);
    try {
      // Get notifications and convert them to a list
      List<NotificationModel> notifications = box.values.toList();

      // Sort the list in descending order based on timestamps
      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      print('notifications: ${notifications.length}');
      return notifications;
      // return box.values.toList();
    } finally {
      await box.close();
    }
  }

// Recursive function to find a folder by its id in the hierarchy
  FolderModel? findFolderByIdInHierarchy(FolderModel folder, String targetId) {
    if (folder.id == targetId) {
      return folder;
    } else {
      if (folder.actualSubfolders != null) {
        for (var subFolder in folder.actualSubfolders!) {
          var result = findFolderByIdInHierarchy(subFolder, targetId);
          if (result != null) {
            return result;
          }
        }
      }
    }
    return null;
  }

  FolderModel? getFolderById(FolderModel rootFolder, String folderId) {
    if (rootFolder.id == folderId) {
      // Found the folder with the specified ID
      return rootFolder;
    } else {
      // Check if the folder has actual subfolders
      if (rootFolder.actualSubfolders != null) {
        // Iterate through actual subfolders
        for (var subfolder in rootFolder.actualSubfolders!) {
          // Recursive call to getFolderById for each subfolder
          var result = getFolderById(subfolder, folderId);
          // If the result is not null, the folder was found, so return it
          if (result != null) {
            return result;
          }
        }
      }
      // Folder with the specified ID was not found in this branch
      return null;
    }
  }

  List<FolderModel>? getSubFolders(FolderModel rootFolder, String folderId) {
    if (rootFolder.id == folderId) {
      // Found the folder with the specified ID
      return rootFolder.actualSubfolders;
    } else {
      // Check if the folder has actual subfolders

      if (rootFolder.actualSubfolders != null) {
        return rootFolder.actualSubfolders;
      }
      // Folder with the specified ID was not found in this branch
      return null;
    }
  }

  Future<void> storeUser(UserModel user) async {
    var userIdBox = await Hive.openBox<UserModel>(userBox);
    var isLoggedInIdBox = await Hive.openBox(isLoggedInBox);
    var roleIdBox = await Hive.openBox(roleBox);

    await isLoggedInIdBox.put('isLoggedIn', true);
    await roleIdBox.put('role', user.role);
    var imageBox = await Hive.openBox<Uint8List>(profileBox);

    if (user.image!.isNotEmpty) {
      try {
        String imageName = user.image!.split('/').last.split('?').first;
        imageName = imageName.replaceAll('%', '_');

        final identifier = '${user.id}_$imageName';
        final storageRef = FirebaseStorage.instance.refFromURL(user.image!);
        final imageData = await storageRef.getData();
        //  final imageBytes = imageData?.buffer.asUint8List();
        if (imageData != null) {
          await imageBox.put(identifier, imageData);
        }
      } on FirebaseException catch (e) {}
    }

    return userIdBox.put('current_user', user).whenComplete(() async {
      await userIdBox.close();
      await isLoggedInIdBox.close();
      await roleIdBox.close();
      await imageBox.close();
    });
  }

  Future<UserModel?> getUser() async {
    var userIdBox = await Hive.openBox<UserModel>(userBox);

    return userIdBox.get('current_user');
  }

  Future<void> loadUserRole() async {
    var roleIdBox = await Hive.openBox(roleBox);
    userRole.value = roleIdBox.get('role', defaultValue: 'user');
    update();
  }

  Future<bool> isLoggedIn() async {
    var isLoggedInIdBox = await Hive.openBox(isLoggedInBox);
    print(
        'is logged in : ${isLoggedInIdBox.get('isLoggedIn', defaultValue: false)}');
    return isLoggedInIdBox.get('isLoggedIn', defaultValue: false);
  }

  Future<void> signOut() async {
    var isLoggedInIdBox = await Hive.openBox(isLoggedInBox);

    await isLoggedInIdBox.put('isLoggedIn', false);

    // You may also want to clear other user-related data when signing out
    // For example, clear the user data from the UserModel box:
    var userIdBox = await Hive.openBox<UserModel>(userBox);
    await userIdBox.clear();
  }

  Future<Uint8List?> getUserImage(UserModel user) async {
    String imageName = user.image!.split('/').last.split('?').first;
    imageName = imageName.replaceAll('%', '_');
    final identifier =
        '${user.id}_$imageName'; // Update identifier logic if needed
    final imageBox = await Hive.openBox<Uint8List>(profileBox);

    final imageData = await imageBox.get(identifier);

    // Convert ByteData to Uint8List if needed
    return imageData?.buffer.asUint8List();
  }

  Future<void> downloadRootFolder() async {
    try {
      String folderId = '9876543210';
      String folderPath = '/folders';
      Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);
      ListResult items = await storageRef.listAll();

      var appDocDir = await getApplicationDocumentsDirectory();
      //  totalFiles.value = items.items.length;
      await Future.wait(
        items.items.map((item) async {
          print('item name: ${item.name}');

          if (item is Reference) {
            print('is a file');
            File file = File('${appDocDir.path}${folderPath}/${item.name}');
            print('file.path: ${file.path}');
            Directory parentDirectory = file.parent;

// Check if the parent directory exists
            if (!parentDirectory.existsSync()) {
              // If it doesn't exist, create it
              print('existts');
              parentDirectory.createSync(recursive: true);
            }
            // File file = File('${appDocDir.path}/${item.name}');

            TaskSnapshot taskSnapshot = await item.writeToFile(file);

            // Handle the downloaded file
            //  filesDownloaded++;
            //  downloadProgress.value = (filesDownloaded / totalFiles.value) * 100;
          }
        }),
      );
      DocumentSnapshot folderDoc = await FirebaseFirestore.instance
          .collection('folders')
          .doc(folderId)
          .get();

      // FolderModel folder = filesController.folders.firstWhere(
      //   (folder) => folder.id == folderId,
      // );
      if (folderDoc.exists) {
        FolderModel folder = FolderModel.fromFirestore(folderDoc);
        List<FileModel> files = await fetchFilesForFolder(folder.id);

        //  folder.actualSubfolders = [];
        FolderModel updatedFolder = FolderModel(
            id: folder.id,
            name: folder.name,
            actualSubfolders: [],
            path: folder.path,
            subFolders: folder.subFolders,
            files: files,
            downloadUrl: folder.downloadUrl,
            parentId: folder.parentId,
            appearance: folder.appearance // Set to an empty list
            // Copy other properties as needed
            );
        print('updated folder files length: ${updatedFolder.files?.length}');
        storeFolder(updatedFolder);
      }
    } on FirebaseException catch (error) {
      Get.snackbar(
        'Error',
        error.message ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<List<FileModel>> fetchFilesForFolder(String folderId) async {
    DocumentSnapshot folderDoc = await FirebaseFirestore.instance
        .collection('folders')
        .doc(folderId)
        .get();

    if (folderDoc.exists) {
      Map<String, dynamic>? data = folderDoc.data() as Map<String, dynamic>?;

      List<FileModel> files = (data?['files'] as List<dynamic>?)
              ?.map((fileData) =>
                  FileModel.fromJson(fileData as Map<String, dynamic>))
              .toList() ??
          [];

      return files;
    } else {
      // Handle the case where the folder document doesn't exist
      return [];
    }
  }
// static Future<String?> getQuizId() async {
  //   var quizIdBox = await Hive.openBox(Db.quizIdBox);
  //   print(' get quiz id === ${quizIdBox.get('id')}');
  //   return quizIdBox.get('id');
  // }
  //
  // static Future<void> setQuizId(String id) async {
  //   var quizIdBox = await Hive.openBox(Db.quizIdBox);
  //
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
  //
  //   await quizIdBox.put('id', id);
  // }
  //
  // static Future<void> createAttempt(String testId, Attempt attempt) async {
  //   final box = await Hive.openBox<Attempt>(attemptsBoxName);
  //   box.put(testId, attempt);
  //   homeController.setAttempt(attempt);
  //
  // }
  //
  // static Future<Attempt?> getAttempt(String testId) async {
  //   final box = await Hive.openBox<Attempt>(attemptsBoxName);
  //   // Check if the attempt with the given testId exists in the box
  //   if (box.containsKey(testId)) {
  //
  //     return box.get(testId);
  //   } else {
  //     // Attempt does not exist
  //
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
