import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/userModel.dart';

class FirebaseService {
  final CollectionReference _userProfile =
      FirebaseFirestore.instance.collection('users');

  Future<UserModel?> getProfile(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userProfile.doc(id).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data()! as Map<String, dynamic>;

        // Return the user profile.
        return UserModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> updateUser(String name, XFile? selectedImage) async {
    final userFirestoreRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await userFirestoreRef.update({
      'name': name,
    });

    if (selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref('profile_pictures/${selectedImage.name}');

      await storageRef.putFile(File(selectedImage.path));

      final updatedProfileUrl = await storageRef.getDownloadURL();

      await userFirestoreRef.update({
        'profile': updatedProfileUrl,
      });

      final updatedUserDoc = await userFirestoreRef.get();
      final updatedUserData = updatedUserDoc.data() as Map<String, dynamic>;

      return UserModel.fromJson(updatedUserData);
    } else {
      final updatedUserDoc = await userFirestoreRef.get();
      final updatedUserData = updatedUserDoc.data() as Map<String, dynamic>;

      return UserModel.fromJson(updatedUserData);
    }
  }
}
