import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/widgets/indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/file_model.dart';
import '../models/folder_model.dart';
import '../models/link_model.dart';

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
  late StreamSubscription<InternetConnectionStatus> listener;

  RxBool isInternet = false.obs;
  void checkNet() async {
    isInternet.value = await InternetConnectionChecker().hasConnection;
    ;
  }

  @override
  onInit() async {
    folders.clear();
    //  getFolders();
    super.onInit();
  }

  @override
  onReady() async {
    folders.clear();
    // checkNet();
    // listener = InternetConnectionChecker().onStatusChange.listen(
    //       (InternetConnectionStatus status) {
    //     switch (status) {
    //       case InternetConnectionStatus.connected:
    //       // ignore: avoid_print
    //         Indicator.showToast('Internet Available', Colors.green);
    //         ;
    //         isInternet.value = true;
    //         if (dbController.isInternet.value == false) {getFolders();
    //         }
    //         break;
    //       case InternetConnectionStatus.disconnected:
    //       // ignore: avoid_print
    //         Indicator.showToast('No Internet Connection', Colors.red);
    //         isInternet.value = false;
    //         ;
    //         break;
    //     }
    //   },
    // );
    super.onReady();
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      getFolders();
    } else {
      //  print(InternetConnectionChecker().lastTryResults);
    }
  }

  Future<List<FolderModel>> getFolders() async {
    try {
      Indicator.showLoading();
      QuerySnapshot foldersQuery =
          await FirebaseFirestore.instance.collection('folders').get();

      // Fetch all subfolders
      Map<String, FolderModel> subfolderMap = {};
      folders.clear();

      for (QueryDocumentSnapshot folderDoc in foldersQuery.docs) {
        Map<String, dynamic> data = folderDoc.data() as Map<String, dynamic>;
        print('links: ${data['links']}');
        FolderModel folder = FolderModel.fromFirestore(folderDoc);

        folders.add(folder);
        print('folder.links .length: ${folder.links?.length}');
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
        path: '/folders/', // Update the path as needed
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
                '${folderPath.value}/${folderName.replaceAll(' ', '_')}/', // Update the path as needed
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
              '${folderPath.value}/$uniqueFolderName/', // Update the path as needed
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

  Future<void> uploadFiles(
      List<File> files, String folderId, List<String> names) async {
    showProgressDialog();
    await checkAndCreateRootFolder();
    int nme = 0;
    for (File filex in files) {
      try {
        // Extract the file name from the path
        uploading.value = true;
        // Create a Zip archive

        String fileName = names[nme];
        nme++; //filex.path!.split('/').last;
        // String fileName = filex.path!.split('/').last;
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
            'stored path: ${folderPath.value}/${fileName.replaceAll(' ', '_')}.$ext');
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('${folderPath.value}/${fileName.replaceAll(' ', '_')}.$ext');
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
            path: '${folderPath.value}/${fileName.replaceAll(' ', '_')}.$ext',
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
        folders.refresh();
        ;
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

  Future<void> renameFileAdmin(
    String folderId,
    String fileId,
    String newName,
  ) async {
    try {
      // Delete file from Firebase Storage
      Indicator.showLoading();
      CollectionReference<Map<String, dynamic>> foldersCollection =
          FirebaseFirestore.instance.collection('folders');
      FirebaseStorage storage = FirebaseStorage.instance;

      try {
        List<FileModel> files = await fetchFilesForFolder(folderId);

        int ind = files.indexWhere((element) => element.id == fileId);
        files[ind].name = newName;
        List<Map<String, dynamic>> filesJson =
            files.map((file) => file.toJson()).toList();

        await FirebaseFirestore.instance
            .collection('folders')
            .doc(folderId)
            .update({'files': filesJson});

        ;
      } catch (e) {
        print('error: ' + e.toString());
      }

      await getFolders();
    } catch (error) {
      Indicator.closeLoading();
    } finally {
      Indicator.closeLoading();
    }
  }

  Future<void> deleteFileAdmin(
      String folderId, String fileId, String path) async {
    try {
      // Delete file from Firebase Storage
      Indicator.showLoading();
      CollectionReference<Map<String, dynamic>> foldersCollection =
          FirebaseFirestore.instance.collection('folders');
      FirebaseStorage storage = FirebaseStorage.instance;
      ;
      await storage.ref().child(path).delete();

      try {
        // Remove file from the array in the document
        ;
        ;
        List<FileModel> files = await fetchFilesForFolder(folderId);

        files.removeWhere((element) => element.id == fileId);

        List<Map<String, dynamic>> filesJson =
            files.map((file) => file.toJson()).toList();

        await FirebaseFirestore.instance
            .collection('folders')
            .doc(folderId)
            .update({'files': filesJson});

        ;
      } catch (e) {
        print('error: ' + e.toString());
      }

      await getFolders();
      ;
    } catch (error) {
      ;
      Indicator.closeLoading();
    } finally {
      Indicator.closeLoading();
    }
  }

  // add link
  Future<void> addLink(LinkModel link, String parentId) async {
    print('in add link');
    try {
      Indicator.showLoading();
      // Replace "your-collection" and "your-document-id" with your actual values
      // DocumentSnapshot folderDoc = await FirebaseFirestore.instance
      //     .collection('folders')
      //     .doc(parentId)
      //     .get();
      // List<dynamic> existingFiles = folderDoc['links'] ?? [];

      // // Extract existing links from folder data
      // final List<dynamic> existingLinks =
      //     folderDocSnapshot.data()?['links'] ?? [];
      //
      // // Add the new link to the existing links
      // final List<dynamic> updatedLinks = List.from(existingLinks)
      //   ..add(link.toJson());
      //
      // // Update the links field of the document with the updated links
      // await folderDocRef.update({'links': updatedLinks});
      // Add the new link to the links array with the link's ID as the key
      print('here');
      await FirebaseFirestore.instance
          .collection('folders')
          .doc(parentId)
          .update({
        'links': FieldValue.arrayUnion([
          link.toJson(),
        ])
      });

      await getFolders();
    } catch (e) {
      // Handle potential exceptions during Firebase operations (e.g., network issues)
      print("Error saving link to Firebase: $e");
      Get.snackbar(
        "Error",
        "Failed to save link:",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Indicator.closeLoading();
    } finally {
      Indicator.closeLoading();
    }
  }

// delete link
  Future<void> deleteLink(String parentId, String linkId) async {
    try {
      print('deleted link called');
      Indicator.showLoading();
      // Get the reference to the folder document
      DocumentSnapshot folderDoc = await FirebaseFirestore.instance
          .collection('folders')
          .doc(parentId)
          .get();
      print('got');
      List<dynamic> existingFiles = folderDoc['links'] ?? [];

      existingFiles.removeWhere((element) => element['id'] == linkId);
      // Update the 'links' field by removing the link with the specified ID
      print('linkid: $linkId');

      await FirebaseFirestore.instance
          .collection('folders')
          .doc(parentId)
          .update({
        'links': existingFiles,
      });
      await getFolders();
      Indicator.closeLoading();
      print('Link deleted successfully');
    } catch (e) {
      // Handle potential exceptions during Firebase operations (e.g., network issues)
      print('error: ${e}');
      Get.snackbar(
        "Error",
        "Failed to delete link:",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Indicator.closeLoading();
    }
  }

  // Function to rename a link in Firebase
  Future<void> editLink(
      String parentId, String linkId, String newName, String newUrl) async {
    try {
      Indicator.showLoading();
      // Get the reference to the folder document

      DocumentSnapshot folderDoc = await FirebaseFirestore.instance
          .collection('folders')
          .doc(parentId)
          .get();
      print('got');
      List<dynamic> existingFiles = folderDoc['links'] ?? [];

      int index =
          await existingFiles.indexWhere((element) => element['id'] == linkId);
      existingFiles[index]['name'] = newName;
      existingFiles[index]['url'] = newUrl;
      // Update the 'links' field by updating the link's name and URL
      await FirebaseFirestore.instance
          .collection('folders')
          .doc(parentId)
          .update({
        'links': existingFiles,
      });

      print('Link edited successfully');
      await getFolders();
      Indicator.closeLoading();
    } catch (e) {
      // Handle potential exceptions during Firebase operations (e.g., network issues)

      Get.snackbar(
        "Error",
        "Failed to rename link:",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Indicator.closeLoading();
    }
  }

  goToYoutube(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar(
        "Error",
        "Failed to open link",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

// folders downlading
  void showDownloadingProgressDialog() {
    Get.dialog(
        AlertDialog(
          title: Text('Downloading'),
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

  Future<void> downloadFilesFromFolder(String folderId, folderPath) async {
    try {
      if (await requestStoragePermission()) {
        showDownloadingProgressDialog();
        ;
        Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);
        ListResult items = await storageRef.listAll();
        Directory appDocDir = await getApplicationDocumentsDirectory();
        //  Directory documentsDirectory = await getApplicationDocumentsDirectory();

        // // Create a folder in the documents directory
        // Directory folderDirectory =
        //     Directory('${documentsDirectory.path}$folderPath');
        // await folderDirectory.create(recursive: false);
        //  var appDocDir = await getApplicationDocumentsDirectory();
        totalFiles.value = items.items.length;
        await Future.wait(
          items.items.map((item) async {
            if (item is Reference) {
              if (item.name.contains('.')) {
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
                ;
                // Handle the downloaded file
                filesDownloaded++;
                downloadProgress.value =
                    (filesDownloaded / totalFiles.value) * 100;
              }
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
      }
    } on FirebaseException catch (e) {
    } finally {
      downloadProgress.value = 0.0;
      filesDownloaded.value = 0;
      totalFiles.value = 0;

      // uploading.value = false;
      Get.back();
    }
  }

  Future<void> downloadSingleFile(String folderId, String folderPath,
      String fileName, String fileId) async {
    try {
      showDownloadingProgressDialog();
      ;

      Reference storageRef =
          FirebaseStorage.instance.ref().child('$folderPath/$fileName');

      var appDocDir = await getApplicationDocumentsDirectory();

      // Create a file for the downloaded file
      File file = File('${appDocDir.path}$folderPath/$fileName');
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
      final downloadTask = storageRef.writeToFile(file);

      // Listen for progress
      await downloadTask.snapshotEvents.listen((snapshot) {
        switch (snapshot.state) {
          case TaskState.running:
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;

            uploadProgress.value = progress * 100;
            break;
          case TaskState.paused:
            ;
            break;
          case TaskState.success:
            uploadProgress.value = 0.0;
            break;
          case TaskState.canceled:
            ;
            break;
          case TaskState.error:
            snapshot.printError();
            // ;
            break;
        }
      });
      FolderModel onlinefolder = folders.value.firstWhere(
        (folder) => folder.id == folderId,
      );
      FolderModel folder = dbController.hiveFolders.value
          .firstWhere((folder) => folder.id == folderId);
      int index = dbController.hiveFolders.value
          .indexWhere((element) => element.id == folderId);
      FileModel? fileUpdated =
          onlinefolder.files?.firstWhere((element) => element.id == fileId);

      if (fileUpdated != null) {
        // //  List<FileModel> files = await fetchFilesForFolder(folder.id);
        // folder.files?.add(fileUpdated);
        // FolderModel updatedFolder = FolderModel(
        //     id: folder.id,
        //     name: folder.name,
        //     actualSubfolders: folder.actualSubfolders,
        //     path: folder.path,
        //     subFolders: folder.subFolders,
        //     files: folder.files,
        //     downloadUrl: folder.downloadUrl,
        //     parentId: folder.parentId,
        //     appearance: folder.appearance // Set to an empty list
        //     // Copy other properties as needed
        //     );
        // ;
        // print(
        //     'check hive folder files length so to know it is not updated yet:${dbController.hiveFolders[index].files?.length} }');
        ;
        await dbController.updateFileInFolder(folderId, fileUpdated);
        Get.back();
      }
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      ;
    } finally {
      downloadProgress.value = 0.0;

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
        ;
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

      ;
      await dbController.deleteAllHiveFolders();
      await dbController.assignHiveFolders();
      await screenController.assignAll();
      screenController.bottomNavIndex.value = 0;
      Indicator.closeLoading();
    } catch (e) {
      Indicator.closeLoading();
      ;
    }
  }

  Future<void> downloadFile(String folderId, String folderPath, String fileName,
      String fileId) async {
    try {
      // showDownloadingProgressDialog();
      ;

      Reference storageRef =
          FirebaseStorage.instance.ref().child('$folderPath/$fileName');

      var appDocDir = await getApplicationDocumentsDirectory();

      // Create a file for the downloaded file
      File file = File('${appDocDir.path}$folderPath/$fileName');
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
      final downloadTask = storageRef.writeToFile(file);

      // Listen for progress
      await downloadTask.snapshotEvents.listen((snapshot) {
        switch (snapshot.state) {
          case TaskState.running:
            filesDownloaded++;
            downloadProgress.value = (filesDownloaded / totalFiles.value) * 100;
            break;
          case TaskState.paused:
            ;
            break;
          case TaskState.success:
            //  downloadProgress.value = 0.0;
            break;
          case TaskState.canceled:
            ;
            break;
          case TaskState.error:
            snapshot.printError();
            // ;
            break;
        }
      });
      FolderModel onlinefolder = folders.value.firstWhere(
        (folder) => folder.id == folderId,
      );
      FolderModel folder = dbController.hiveFolders.value
          .firstWhere((folder) => folder.id == folderId);
      int index = dbController.hiveFolders.value
          .indexWhere((element) => element.id == folderId);
      FileModel? fileUpdated =
          onlinefolder.files?.firstWhere((element) => element.id == fileId);

      if (fileUpdated != null) {
        // //  List<FileModel> files = await fetchFilesForFolder(folder.id);
        // folder.files?.add(fileUpdated);
        // FolderModel updatedFolder = FolderModel(
        //     id: folder.id,
        //     name: folder.name,
        //     actualSubfolders: folder.actualSubfolders,
        //     path: folder.path,
        //     subFolders: folder.subFolders,
        //     files: folder.files,
        //     downloadUrl: folder.downloadUrl,
        //     parentId: folder.parentId,
        //     appearance: folder.appearance // Set to an empty list
        //     // Copy other properties as needed
        //     );
        // ;
        // print(
        //     'check hive folder files length so to know it is not updated yet:${dbController.hiveFolders[index].files?.length} }');
        ;
        await dbController.updateFileInFolder(folderId, fileUpdated);
        Get.back();
      }
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      ;
    }
  }

  Future<void> findFilesToDownload(String folderId) async {
    try {
      showDownloadingProgressDialog();

      FolderModel onlineFolder = folders.value.firstWhere(
        (folder) => folder.id == folderId,
      );

      FolderModel localFolder = dbController.hiveFolders.value
          .firstWhere((folder) => folder.id == folderId);

      List<FileModel> filesToDownload = onlineFolder.files!
          .where((onlineFile) =>
              localFolder.files
                  ?.every((localFile) => localFile.id != onlineFile.id) ??
              true)
          .toList();
      totalFiles.value = filesToDownload.length;
      ;
      for (FileModel fileToDownload in filesToDownload) {
        ;
        await downloadFile(
          folderId,
          onlineFolder.path,
          fileToDownload.name,
          fileToDownload.id,
        );
      }
    } catch (e) {
      ;
    } finally {
      Get.back();

      downloadProgress.value = 0.0;
      filesDownloaded.value = 0;
      totalFiles.value = 0;
      ;
      // uploading.value = false;
    }
  }

  Future<void> deleteFile(
      String filename, String parentId, String fileId) async {
    try {
      Indicator.showLoading();
      ;
      // Get the application documents directory
      var appDocDir = await getApplicationDocumentsDirectory();

      // Construct the full path of the file to be deleted
      String filePath =
          '${appDocDir.path}${folderPath.value}/$filename'; // Replace with the actual file name

      // Delete the file
      File fileToDelete = File(filePath);
      if (await fileToDelete.exists()) {
        await fileToDelete.delete();
        ;
      } else {
        ;
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
      ;
    }
  }

  Future<void> deleteAdminFolder(String folderId, String folderPath) async {
    try {
      // Get the folder to be deleted
      Indicator.showLoading();
      FolderModel folderToDelete = folders.value.firstWhere(
        (folder) => folder.id == folderId,
      );

      // Update the parent folder (if it has one)
      if (folderToDelete.parentId != null) {
        int indexP = folders.value.indexWhere(
          (folder) => folder.id == folderToDelete.parentId,
        );

        // Remove the ID of the folder being deleted from the parent folder's subfolders list
        //  parentFolder.subFolders?.remove(folderId);
        FolderModel temp = folders[indexP];
        temp.subFolders?.remove(folderId);

        temp.actualSubfolders?.removeWhere((element) => element.id == folderId);

        folders[indexP] = temp;

        folders.refresh();
        // Update the parent folder's subfolders list in Firebase Firestore
        await FirebaseFirestore.instance
            .collection('folders')
            .doc(folders[indexP].id)
            .update({'subFolders': folders[indexP].subFolders});
      }

      // Delete folder and its contents from Firebase Storage
      Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);
      await storageRef.listAll().then((ListResult result) async {
        await Future.forEach(result.items, (Reference item) async {
          await item.delete();
        });
      });
      // Delete the "folder" itself
      await storageRef.delete();
      try {
        // Delete folder from Firebase Firestore

        await deleteSubfolders(folderId);
        await FirebaseFirestore.instance
            .collection('folders')
            .doc(folderId)
            .delete();
        ;
      } catch (e) {}

      // Remove folder from list of Rx FolderModel
      int index = folders.value.indexWhere((element) => element.id == folderId);
      FolderModel temp = folders[index];
      folders.removeWhere((folder) {
        return folder.id == folderId;
      });

      // folders.remove(folderToDelete);

      folders.refresh();
      update();
      Indicator.closeLoading();
    } catch (e) {
      Indicator.closeLoading();
      ;
      Get.snackbar(
        'Error',
        e.toString() ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteSubfolders(String folderId) async {
    try {
      // Step 1: Query and get all subfolders based on 'parentId'
      QuerySnapshot subfoldersQuery = await FirebaseFirestore.instance
          .collection('folders')
          .where('parentId', isEqualTo: folderId)
          .get();

      // Step 2: Iterate through the result and delete each subfolder
      for (QueryDocumentSnapshot subfolder in subfoldersQuery.docs) {
        // Delete the subfolder document
        await FirebaseFirestore.instance
            .collection('folders')
            .doc(subfolder.id)
            .delete();

        // Optionally, you may also recursively delete subfolders of the current subfolder
        await deleteSubfolders(subfolder.id);
      }

      ;
    } catch (error) {
      ;
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
