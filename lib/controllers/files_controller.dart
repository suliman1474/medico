import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/widgets/indicator.dart';
import 'package:path_provider/path_provider.dart';

import '../models/file_model.dart';
import '../models/folder_model.dart';

class FilesController extends GetxController {
  RxList<FolderModel> folders = <FolderModel>[].obs;
  RxString folderPath = ''.obs;
  RxBool uploading = false.obs;
  RxDouble uploadProgress = 0.0.obs;
  RxDouble downloadProgress = 0.0.obs;
  DbController dbController = Get.find();
  RxInt totalFiles = 0.obs;
  RxInt filesDownloaded = 0.obs;
  ScreenController screenController = Get.find();
  @override
  onInit() async {
    folders.clear();
    //  getFolders();
    super.onInit();
  }

  @override
  onReady() async {
    folders.clear();

    super.onReady();
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
      getFolders();
    } else {
      print('No internet :( Reason:');

      //  print(InternetConnectionChecker().lastTryResults);
    }
  }

  Future<List<FolderModel>> getFolders() async {
    try {
      print('==== get folders');
      Indicator.showLoading();
      QuerySnapshot foldersQuery =
          await FirebaseFirestore.instance.collection('folders').get();

      // Fetch all subfolders
      Map<String, FolderModel> subfolderMap = {};
      folders.clear();

      for (QueryDocumentSnapshot folderDoc in foldersQuery.docs) {
        FolderModel folder = FolderModel.fromFirestore(folderDoc);

        folders.add(folder);

        // Store the folder in the subfolderMap for future reference
        subfolderMap[folder.id] = folder;
      }

      // Update actualSubfolders in each folder
      for (FolderModel folder in folders) {
        folder.actualSubfolders = [
          for (String subfolderId in folder.subFolders ?? [])
            subfolderMap[subfolderId] ??
                await fetchFolderFromFirebase(subfolderId) ??
                FolderModel(
                    id: subfolderId, name: '', path: '', parentId: folder.id)
        ];

        // Fetch files for the current folder
        List<FileModel> files = await fetchFilesForFolder(folder.id);

        int index = folders.indexWhere((element) => element.id == folder.id);
        FolderModel temp = folders[index];
        temp.files?.addAll(files);
        folders[index] = temp;
        //  folders[index].files?.addAll(files);

        update();
      }
      update();

      Indicator.closeLoading();
      return folders;
    } on FirebaseException catch (error) {
      Get.back();
      Get.snackbar(
        'Error',
        error.message ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
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

  Future<FolderModel?> fetchFolderFromFirebase(String folderId) async {
    DocumentSnapshot folderDoc = await FirebaseFirestore.instance
        .collection('folders')
        .doc(folderId)
        .get();

    if (folderDoc.exists) {
      return FolderModel.fromFirestore(folderDoc);
    }

    return null;
  }

  Future<void> checkAndCreateRootFolder() async {
    final CollectionReference foldersCollection =
        FirebaseFirestore.instance.collection('folders');

    QuerySnapshot query = await foldersCollection.get();

    if (query.docs.isEmpty) {
      // The 'folders' collection is empty, create a root folder
      final String folderId = '9876543210';

      // Create a new FolderModel for the root folder
      final FolderModel rootFolder = FolderModel(
        id: folderId,
        name: 'Root Folder',
        path: '/folders', // Update the path as needed
        downloadUrl:
            '', // Initially set to null, will be updated after storage upload
        subFolders: [],
        parentId: '',
        files: [],
      );

      // Save the new root folder to Firebase
      await foldersCollection.doc(folderId).set(rootFolder.toJson());
      folders.add(rootFolder);
      update();
      // // Create a folder in Firebase Storage with the same name as the Firestore folder
      // final Reference storageFolder =
      // FirebaseStorage.instance.ref().child('root_folder/');
      // await storageFolder.putData(Uint8List(0));
      //
      // // Get the download URL of the folder in Firebase Storage
      // final String downloadUrl = await storageFolder.getDownloadURL();
      //
      // // Update the downloadUrl field in Firestore
      // await foldersCollection.doc(folderId).update({
      //   'downloadUrl': downloadUrl,
      // });
    } else {}
  }

  Future<void> createFolder(String folderName, String parId) async {
    // Indicator.showLoading();
    Get.back();
    await checkAndCreateRootFolder();
    if (folderName.isNotEmpty) {
      Indicator.showLoading();
      final CollectionReference foldersCollection =
          FirebaseFirestore.instance.collection('folders');

      // Check if the folder name already exists in Firebase
      late QuerySnapshot query;
      if (parId == '') {
        query = await foldersCollection
            .where('name', isEqualTo: folderName)
            .where('parentId', isEqualTo: '9876543210')
            .get();
      } else {
        query = await foldersCollection
            .where('name', isEqualTo: folderName)
            .where('parentId', isEqualTo: parId)
            .get();
      }

      if (query.docs.isEmpty) {
        // The folder name is available
        // Generate a unique ID for the folder
        final String folderId =
            DateTime.now().millisecondsSinceEpoch.toString();

        // Create a new FolderModel
        final FolderModel newFolder = FolderModel(
            id: folderId,
            name: folderName,
            path:
                '${folderPath.value}/${folderName.replaceAll(' ', '_')}', // Update the path as needed
            downloadUrl:
                '', // Initially set to null, will be updated after storage upload
            subFolders: [],
            parentId: parId != '' ? parId : '9876543210',
            files: []);

        // Save the new folder to Firebase
        await foldersCollection.doc(folderId).set(newFolder.toJson());

        // Create a folder in Firebase Storage with the same name as the Firestore folder
        final Reference storageFolder = FirebaseStorage.instance
            .ref()
            .child('${folderPath.value}/${folderName.replaceAll(' ', '_')}/');
        await storageFolder.putData(
            Uint8List(0)); // Uploading an empty file to create the folder

        // Get the download URL of the folder in Firebase Storage
        final String downloadUrl = await storageFolder.getDownloadURL();
        if (parId.isNotEmpty || parId != '') {
          await foldersCollection.doc(parId).update({
            'subFolders': FieldValue.arrayUnion([folderId]),
          });
          await foldersCollection.doc(folderId).update({
            'downloadUrl': downloadUrl,
            'parentId': parId,
          });
        } else {
          await foldersCollection.doc('9876543210').update({
            'subFolders': FieldValue.arrayUnion([folderId]),
          });
          await foldersCollection.doc(folderId).update({
            'downloadUrl': downloadUrl,
            'parentId': '9876543210',
          });
        }
        // // Update the downloadUrl field in Firestore
        await foldersCollection.doc(folderId).update({
          'downloadUrl': downloadUrl,
          'parentId': parId,
        });
        FolderModel? folder = await fetchFolderFromFirebase(folderId);
        FolderModel? parentFolder = await fetchFolderFromFirebase(parId);
        int folderIndex = folders.indexWhere((element) => element.id == parId);

        if (folder != null) {
          folders.add(folder);
        }
        folders[folderIndex].actualSubfolders?.add(folder!);
        update();
        Indicator.closeLoading();
        // getFolders();

        // Check if it's a subfolder
        // if (parentFolderId.isNotEmpty) {
        //   // Update the parent folder's subFolders field with the reference to the new folder
        //   await foldersCollection.doc(parentFolderId).update({
        //     'subFolders': FieldValue.arrayUnion([foldersCollection.doc(folderId)]),
        //   });
        // }

        // Optionally, you can notify listeners or update the UI as needed
      } else {
        // The folder name is not available, append "Copy(number)" until it's unique
        int copyNumber = 1;
        String uniqueFolderName;

        do {
          uniqueFolderName = '${folderName}_Copy($copyNumber)';
          copyNumber++;
        } while (await isFolderNameExists(uniqueFolderName));

        // Now, uniqueFolderName is the available name
        // Generate a unique ID for the folder
        final String folderId =
            DateTime.now().millisecondsSinceEpoch.toString();

        // Create a new FolderModel
        final FolderModel newFolder = FolderModel(
          id: folderId,
          name: uniqueFolderName,
          path:
              '${folderPath.value}/$uniqueFolderName', // Update the path as needed
          subFolders: [],
          parentId: parId != '' ? parId : '9876543210',

          files: [],
        );

        // Save the new folder to Firebase
        await foldersCollection
            .doc(folderId)
            .set(newFolder.toJson()); // Assuming toJson method in FolderModel
        // Create a folder in Firebase Storage with the same name as the Firestore folder
        final Reference storageFolder = FirebaseStorage.instance
            .ref()
            .child('${folderPath.value}/${folderName.replaceAll(' ', '_')}/');
        await storageFolder.putData(
            Uint8List(0)); // Uploading an empty file to create the folder

        // Get the download URL of the folder in Firebase Storage
        final String downloadUrl = await storageFolder.getDownloadURL();

        // Update the downloadUrl field in Firestore
        if (parId.isNotEmpty || parId != '') {
          await foldersCollection.doc(parId).update({
            'subFolders': FieldValue.arrayUnion([folderId]),
          });
          await foldersCollection.doc(folderId).update({
            'downloadUrl': downloadUrl,
            'parentId': parId,
          });
        } else {
          await foldersCollection.doc('9876543210').update({
            'subFolders': FieldValue.arrayUnion([folderId]),
          });
          await foldersCollection.doc(folderId).update({
            'downloadUrl': downloadUrl,
            'parentId': '9876543210',
          });
        }
        FolderModel? folder = await fetchFolderFromFirebase(folderId);
        FolderModel? parentFolder = await fetchFolderFromFirebase(parId);
        int folderIndex = folders.indexWhere((element) => element.id == parId);

        if (folder != null) {
          folders.add(folder);
        }
        folders[folderIndex].actualSubfolders?.add(folder!);
        update();
        Indicator.closeLoading();
        // getFolders();

        // Check if it's a subfolder
        // if (parentFolderId.isNotEmpty) {
        //   // Update the parent folder's subFolders field with the reference to the new folder
        //   await foldersCollection.doc(parentFolderId).update({
        //     'subFolders': FieldValue.arrayUnion([foldersCollection.doc(folderId)]),
        //   });
        // }
        // Optionally, you can notify listeners or update the UI as needed
      }
    }
    // Indicator.closeLoading();
  }

  Future<bool> isFolderNameExists(String folderName) async {
    final CollectionReference foldersCollection =
        FirebaseFirestore.instance.collection('folders');

    final QuerySnapshot query =
        await foldersCollection.where('name', isEqualTo: folderName).get();

    return query.docs.isNotEmpty;
  }

  Future<void> showCreateFolderDialog(String parentId) async {
    TextEditingController folderNameController = TextEditingController();

    await Get.defaultDialog(
      title: 'Create New Folder',
      content: Column(
        children: [
          TextField(
            controller: folderNameController,
            decoration: InputDecoration(labelText: 'Folder Name'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await createFolder(folderNameController.text.trim(), parentId);
            Get.back(); // Close the dialog
          },
          child: Text('Create'),
        ),
      ],
    );
  }

  void showProgressDialog() {
    Get.dialog(
        AlertDialog(
          title: Text('Uploading'),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: uploadProgress.value / 100,
                ),
                SizedBox(height: 10),
                Text(
                  '${uploadProgress.value.toInt()}%',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }

  Future<void> uploadFiles(List<File> files, String folderId) async {
    showProgressDialog();
    await checkAndCreateRootFolder();
    for (File filex in files) {
      try {
        // Extract the file name from the path
        uploading.value = true;
        // Create a Zip archive

        String fileName = filex.path!.split('/').last;
        String ext = fileName.split('.').last;
        fileName = fileName.split('.').first;

        // Check if the file already exists in the folder
        bool fileExists = false;
        int copyNumber = 1;
        String baseFileName = fileName;
        do {
          DocumentSnapshot folderDoc = await FirebaseFirestore.instance
              .collection('folders')
              .doc(folderId)
              .get();
          List<dynamic> existingFiles = folderDoc['files'] ?? [];

          // Check if the file name already exists in the folder

          fileExists =
              existingFiles.any((file) => file['name'] == fileName + '.' + ext);

          // If the file name exists, append a copy number
          if (fileExists) {
            copyNumber++;
            fileName = '${baseFileName}_Copy($copyNumber)';
          }
        } while (fileExists);
        // Upload file to Firebase Storage
        //    fileName = DateTime.now().millisecondsSinceEpoch.toString();
        // Compress the file
        //  Uint8List compressedFile = await compressFile(filex);
        print(
            'stored path: ${folderPath.value}/${fileName.replaceAll(' ', '_')}.$ext/');
        Reference storageReference = FirebaseStorage.instance.ref().child(
            '${folderPath.value}/${fileName.replaceAll(' ', '_')}.$ext/');
        UploadTask uploadTask = storageReference.putFile(filex);
        //  UploadTask uploadTask = storageReference.putData(compressedFile);
        // Check the size of the file
        int fileSizeInBytes = filex.lengthSync();

// Introduce a delay only for smaller files (less than 1 MB for example)
        if (fileSizeInBytes < 1024 * 1024) {
          await Future.delayed(Duration(milliseconds: 500));
        }

        uploadTask.snapshotEvents.listen(
          (TaskSnapshot snapshot) {
            // Update the progress bar
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;

            uploadProgress.value = progress * 100;
          },
          onDone: () {
            // Reset progress when

            uploadProgress.value = 0.0;
            Get.back();
          },
          onError: (error) {
            Get.snackbar(
              'Error',
              error.message ?? '',
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          },
        );
        TaskSnapshot taskSnapshot = await uploadTask;
        // Get the download URL of the uploaded file
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        FileModel file = FileModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: '${fileName.replaceAll(' ', '_')}.$ext',
            path: '${folderPath.value}/${fileName.replaceAll(' ', '_')}.$ext/',
            downloadUrl: downloadURL);
        // Update Firestore with the file information
        await FirebaseFirestore.instance
            .collection('folders')
            .doc(folderId)
            .update({
          'files': FieldValue.arrayUnion([
            file.toJson(),
          ])
        });
        // Get the existing folder from the folders list based on folderId
        int i = folders.indexWhere((folder) => folder.id == folderId);

// Update the files property of the existing folder
        folders[i].files?.addAll([file]);
        update();
        // getFolders();
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString() ?? '',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        uploadProgress.value = 0.0;
        uploading.value = false;
        Get.back();
      }
    }
  }

// folders downlading
  void showDownloadingProgressDialog() {
    Get.dialog(
        AlertDialog(
          title: Text('Downlaoding'),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: downloadProgress.value / 100,
                ),
                SizedBox(height: 10),
                Text(
                  '${downloadProgress.value.toInt()}%',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false);
  }

  Future<void> downloadFilesFromFolder(String folderId, folderPath) async {
    try {
      showDownloadingProgressDialog();
      print('folderPath: $folderPath');
      Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);
      ListResult items = await storageRef.listAll();

      var appDocDir = await getApplicationDocumentsDirectory();
      totalFiles.value = items.items.length;
      await Future.wait(
        items.items.map((item) async {
          if (item is Reference) {
            File file = File('${appDocDir.path}${folderPath}/${item.name}');
            print('file: $file');
            Directory parentDirectory = file.parent;

// Check if the parent directory exists
            if (!parentDirectory.existsSync()) {
              // If it doesn't exist, create it
              print('parent directory does not exist, creating...');
              try {
                parentDirectory.createSync(recursive: true);
                print('parent directory created successfully');
              } catch (e) {
                print('Error creating parent directory: $e');
                // Handle the error (print, log, or throw)
                return;
              }
            } else {
              print('parent directory already exists');
            }
            // File file = File('${appDocDir.path}/${item.name}');

            TaskSnapshot taskSnapshot = await item.writeToFile(file);

            // Handle the downloaded file
            filesDownloaded++;
            downloadProgress.value = (filesDownloaded / totalFiles.value) * 100;
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

        dbController.storeFolder(updatedFolder);
      }
    } on FirebaseException catch (e) {
    } finally {
      downloadProgress.value = 0.0;
      filesDownloaded.value = 0;
      // uploading.value = false;
      Get.back();
    }
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
          if (item is Reference) {
            File file = File('${appDocDir.path}/${folderPath}/${item.name}');
            file.parent.createSync(recursive: true);
            // File file = File('${appDocDir.path}/${item.name}');

            TaskSnapshot taskSnapshot = await item.writeToFile(file);

            // Handle the downloaded file
            //  filesDownloaded++;
            //  downloadProgress.value = (filesDownloaded / totalFiles.value) * 100;
          }
        }),
      );

      FolderModel folder = folders.firstWhere(
        (folder) => folder.id == folderId,
      );
      if (folder != null) {
        // FolderModel folder = FolderModel.fromFirestore(folderDoc);
        //  folder.actualSubfolders = [];
        FolderModel updatedFolder = FolderModel(
            id: folder.id,
            name: folder.name,
            actualSubfolders: [],
            path: folder.path,
            subFolders: folder.subFolders,
            files: folder.files,
            downloadUrl: folder.downloadUrl,
            parentId: folder.parentId,
            appearance: folder.appearance // Set to an empty list
            // Copy other properties as needed
            );
        print(
            'downloading root folder sub files: ${updatedFolder.files?.length}');
        dbController.storeFolder(updatedFolder);
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

  Future<void> deleteAllFoldersInsideRoot() async {
    try {
      Indicator.showLoading();
      String rootFolderPath = '/folders';
      // Get the application documents directory
      var appDocDir = await getApplicationDocumentsDirectory();

      // Construct the full path of the root folder
      String rootFolderFullPath = '${appDocDir.path}$rootFolderPath';

      // Get a list of all subdirectories in the root folder
      Directory rootFolder = Directory(rootFolderFullPath);
      List<FileSystemEntity> subdirectories = await rootFolder.list().toList();

      // Delete each subdirectory along with its contents
      await Future.wait(subdirectories.map((subdirectory) async {
        if (subdirectory is Directory) {
          await subdirectory.delete(recursive: true);
        }
      }));

      print('All folders inside $rootFolderPath deleted successfully.');
      await dbController.deleteAllHiveFolders();
      await dbController.assignHiveFolders();
      await screenController.assignAll();
      screenController.bottomNavIndex.value = 0;
      Indicator.closeLoading();
    } catch (e) {
      Indicator.closeLoading();
      print('Error deleting folders: $e');
    }
  }

  Future<void> deleteFile(
      String filename, String parentId, String fileId) async {
    try {
      Indicator.showLoading();
      print('deleting');
      // Get the application documents directory
      var appDocDir = await getApplicationDocumentsDirectory();

      // Construct the full path of the file to be deleted
      String filePath =
          '${appDocDir.path}${folderPath.value}/$filename'; // Replace with the actual file name

      // Delete the file
      File fileToDelete = File(filePath);
      if (await fileToDelete.exists()) {
        await fileToDelete.delete();
        print('File $filePath deleted successfully.');
      } else {
        print('File $filePath not found.');
      }
      int index = dbController.hiveFolders
          .indexWhere((element) => element.id == parentId);
      FolderModel temp = dbController.hiveFolders[index];
      temp.files?.removeWhere((element) => element.id == fileId);
      dbController.hiveFolders[index] = temp;
      dbController.updateHiveFolders(dbController.hiveFolders);
      // screenController.bottomNavIndex.value = 0;
      // screenController.assignAll();
      // // Additional operations after deleting the file
      // await dbController.deleteAllHiveFolders();
      // await dbController.assignHiveFolders();
      // await screenController.assignAll();
      // screenController.bottomNavIndex.value = 0;

      Indicator.closeLoading();
    } catch (e) {
      Indicator.closeLoading();
      print('Error deleting file: $e');
    }
  }

// Future<Uint8List> compressFile(File file) async {
  //   try {
  //     final encoder = ZipEncoder();
  //     final inputBytes = await file.readAsBytes();
  //     final archive = Archive()
  //       ..addFile(ArchiveFile('file', inputBytes.length, inputBytes));
  //     final compressedData = encoder.encode(archive);
  //     return Uint8List.fromList(compressedData!);
  //   } catch (e) {
  //
  //     return Uint8List(0);
  //   }
  // }
}
