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
import 'package:permission_handler/permission_handler.dart';

import '../models/file_model.dart';
import '../models/user_model.dart';
import '../widgets/indicator.dart';
import 'files_controller.dart';

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
  UserModel? admin;
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
    await requestStoragePermission();

    await assignHiveFolders();
    fetchAdmin();
  }

  Future<void> assignHiveFolders() async {
    hiveFolders.clear();

    var hiveBox = await Hive.openBox(foldersBox);

    if (!hiveBox.containsKey('root')) {
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
        ;
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
        ;
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

  Future<void> updateFileInFolder(
      String folderId, FileModel updatedFile) async {
    try {
      var hiveBox = await Hive.openBox(foldersBox);

      if (hiveBox.containsKey('root')) {
        // Find the index of the folder in hiveFolders
        int folderIndex =
            hiveFolders.indexWhere((element) => element.id == folderId);
        FolderModel folder = hiveFolders[folderIndex];
        folder.files?.add(updatedFile);
        hiveFolders[folderIndex] = folder;
        ;
        // hiveFolders[folderIndex].files?.add(updatedFile);
        ;
        update();

        // Update the root folder in Hive
        hiveBox.put('root', hiveFolders);
      } else {
        ;
      }

      // Close Hive box
      await hiveBox.close();
    } catch (e) {
      ;
    }
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
      ;
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
      ;
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

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      // Permission already granted, proceed with folder creation
      return true; // Replace with your folder creation logic
    } else {
      var result = await Permission.storage.request();
      if (result.isGranted) {
        // Permission granted after request, proceed with folder creation
        return true; // Replace with your folder creation logic
      } else {
        // Permission denied, handle the denial gracefully
        ;
        // You can show a snackbar or dialog to explain why the permission is needed
        return false;
      }
    }
  }

  Future<void> downloadRootFolder() async {
    try {
      print('download root folder');
      if (await Permission.storage.isGranted) {
        print('permission is granted');
        String folderId = '9876543210';
        String folderPath = '/folders';
        Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);
        ListResult items = await storageRef.listAll();
        Directory appDocDir = await getApplicationDocumentsDirectory();
        // Directory documentsDirectory = await getApplicationDocumentsDirectory();
        //
        // // Create a folder in the documents directory
        // Directory folderDirectory =
        //     Directory('${documentsDirectory.path}$folderPath');
        // folderDirectory.createSync(recursive: true);
        //  totalFiles.value = items.items.length;
        // Get all items (files and folders) in the folder

// Filter out only the files
        List<Reference> files = items.items.whereType<Reference>().toList();
        await Future.wait(
          files.map((item) async {
            ;

            if (item.name.contains('.')) {
              ;
              //  File file = File('${folderDirectory.path}/${item.name}');
              File file = File('${appDocDir.path}${folderPath}/${item.name}');
              ;
              Directory parentDirectory = file.parent;

// Check if the parent directory exists
              if (!parentDirectory.existsSync()) {
                // If it doesn't exist, create it
                ;
                try {
                  parentDirectory.createSync(recursive: true);
                  ;
                } catch (e) {
                  ;
                  // Handle the error (print, log, or throw)
                  return;
                }
              } else {
                ;
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
          ;
          storeFolder(updatedFolder);
        }
      } else {
        await await Permission.storage.request();
        downloadRootFolder();
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

  Future<void> deleteFolderUser(String id) async {
    // Open the Hive box named 'folders'
    Indicator.showLoading();
    var hiveBox = await Hive.openBox(foldersBox);
    // Find the folder with the specified ID
    FolderModel folderToDelete =
        hiveFolders.firstWhere((element) => element.id == id);
    int parentIndex = hiveFolders
        .indexWhere((element) => element.id == folderToDelete.parentId);
    // Get the list of folders from the box
    hiveFolders.removeWhere((element) => element.id == id);

    if (folderToDelete != null) {
      // Delete associated files from the application storage

      if (folderToDelete.files != null && folderToDelete.files!.isNotEmpty) {
        await deleteFilesFromAppStorage(folderToDelete.files!);
      }

      // Remove the folder from the list
      hiveFolders.remove(folderToDelete);
      hiveFolders[parentIndex].actualSubfolders?.remove(folderToDelete);
      // Update the Hive box with the modified list
      await hiveBox.put('root', hiveFolders);
      print('your folder deleted now gett all new');
      await getAllHiveFolders();
    } else {}

    //   hiveBox.put('root', hiveFolders);

    Indicator.closeLoading();
    ;
  }

  Future<void> deleteFilesFromAppStorage(List<FileModel> files) async {
    FilesController filesController = Get.find();
    for (var file in files) {
      // Get the application documents directory
      var appDocDir = await getApplicationDocumentsDirectory();

      // Construct the file path
      String filePath = '${appDocDir.path}${file.path}';
      ;
      // /data/user/0/com.example.medico/app_flutter/folders/folder1//sample.pdf
      // Check if the file exists and delete it
      File fileToDelete = File(filePath);
      if (await fileToDelete.exists()) {
        ;

        await fileToDelete.delete();
        ;
      } else {
        ;
      }
    }
  }

  Future<void> fetchAdmin() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        print('fetching admin');
        print('doc is not empty');
        final DocumentSnapshot doc = querySnapshot.docs.first;
        final userData = doc.data() as Map<String, dynamic>;
        admin = UserModel.fromJson(userData);
      } else {
        print('couldnt fetch admin');
      }
    } catch (e) {
      print('Error fetching admin: $e');
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
