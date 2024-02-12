import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/poll_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class FirebaseService {
  final CollectionReference _userProfile =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> updateFCMToken(String userId, String fcmToken) async {
    try {
      ;
      await _userProfile.doc(userId).update({
        'fcmToken': fcmToken,
      });
    } catch (e) {
      ;
    }
  }

  Future<void> createPost(String? description, XFile? image) async {
    try {
      // Get the current user

      DateTime timestamp = DateTime.now();
      // Create a post document
      final id = DateTime.now().toUtc().microsecondsSinceEpoch.toString();

      await _firestore.collection('posts').doc(id).set({
        'id': id,
        'timestamp': DateTime.now().toUtc().microsecondsSinceEpoch.toString(),
        'description': description ?? '',
        'image': '',
        'like': <String>[],
        'timestamp': DateTime.now().toUtc().microsecondsSinceEpoch.toString(),
      });

      // If an image is provided, upload it to Firebase Storage
      if (image != null) {
        File imageFile = File(image.path);
        String imageName = '${id}_post_image.jpg';
        Reference storageRef = _storage.ref().child('posts_images/$imageName');
        await storageRef.putFile(imageFile);
        String imageUrl = await storageRef.getDownloadURL();

        // Update the post document with the image URL
        await _firestore
            .collection('posts')
            .doc(id)
            .update({'image': imageUrl});
      }
    } catch (e) {}
  }

  Future<void> createPoll(PollModel poll) async {
    try {
      // Create a poll document
      Map<String, dynamic> pollData = poll.toJson();

      await _firestore.collection('polls').doc(poll.id).set(poll.toJson());
    } catch (e) {}
  }

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

  Future<UserModel> updateUser(
    String name,
    String college,
    String discipline,
    String semester,
    String contact,
    XFile? selectedImage,
  ) async {
    final userFirestoreRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await userFirestoreRef.update({
      'name': name,
      'college': college,
      'discipline': discipline,
      'semester': semester,
      'contact': contact,
    });

    if (selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref('profile_pictures/${selectedImage.name}');

      await storageRef.putFile(File(selectedImage.path));

      final updatedProfileUrl = await storageRef.getDownloadURL();

      await userFirestoreRef.update({
        'image': updatedProfileUrl,
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

  Future<List<PostModel>> getPosts() async {
    try {
      // Reference to the "posts" collection
      // Reference to the "posts" collection

      CollectionReference postsCollection =
          FirebaseFirestore.instance.collection('posts');

      // Query the posts collection
      QuerySnapshot querySnapshot = await postsCollection.get();

      // Map the query results to a list of PostModel objects

      List<PostModel> postModels = querySnapshot.docs.map((doc) {
        ;
        // Use the generated fromJson method to create a PostModel
        return PostModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return postModels;
    } catch (e) {
      // Handle any errors that might occur during fetching

      throw e; // Rethrow the error to be caught by the FutureBuilder
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      ;
      throw e;
    }
  }

  Future<void> deletePoll(String pollId) async {
    try {
      await _firestore.collection('polls').doc(pollId).delete();
    } catch (e) {
      ;
      throw e;
    }
  }
}
