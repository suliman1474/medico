import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medico/models/post_model.dart';
import 'package:medico/screens/home/main_page.dart';
import 'package:medico/widgets/indicator.dart';

import '../models/option_model.dart';
import '../models/poll_model.dart';
import '../models/user_model.dart';
import '../services/firebase_services.dart';

class FeedController extends GetxController {
  FirebaseService firebaseService = FirebaseService();
  RxList<PostModel> postModels = <PostModel>[].obs;
  RxList<PollModel> pollModels = <PollModel>[].obs;
  RxList<UserModel> likedBy = <UserModel>[].obs;
  RxList<UserModel> votedBy = <UserModel>[].obs;
  RxInt selectedOptionIndex = RxInt(-1.obs);
  RxBool isLiked = false.obs;
  RxBool loading = false.obs;
  RxList<dynamic> combinedList = <dynamic>[].obs;

  void createPost(String? description, List<XFile>? images) async {
    try {
      Indicator.showLoading();
      await firebaseService.createPost(description, images);
      Indicator.closeLoading();
      Get.off(MainPage(), preventDuplicates: false);
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        e.toString() ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void createPoll(PollModel poll) async {
    try {
      Indicator.showLoading();
      await firebaseService.createPoll(poll);
      Indicator.closeLoading();
      Get.off(MainPage(), preventDuplicates: false);
    } catch (e) {
      Indicator.closeLoading();
      Get.snackbar(
        'Error',
        e.toString() ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<List<UserModel>> getLikedByUsers(PostModel post) async {
    List<UserModel> likedByUsers = [];

    if (post.like != null && post.like!.isNotEmpty) {
      for (int i = 0; i < post.like!.length; i++) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(post.like![i])
            .get();
        if (userSnapshot.exists) {
          likedByUsers.add(
              UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>));
        }
      }

      // Update the PostModel with the list of liked users
      //  post.like = likedByUsers;
      return likedByUsers;
    } else {
      return [];
    }
  }

  Future<List<PostModel>> getPosts() async {
    try {
      List<PostModel> postModels = await firebaseService.getPosts();
      return postModels;
      // Indicator.closeLoading();
    } on FirebaseAuthException catch (e) {
      Indicator.closeLoading();
      Get.snackbar(
        'Error',
        e.message ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> getPostsAndPolls() async {
    // Indicator.showLoading();
    loading.value = true;
    RxStatus.loading();
    QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    QuerySnapshot pollsSnapshot = await FirebaseFirestore.instance
        .collection('polls')
        .orderBy('timestamp', descending: true)
        .get();

    List<dynamic> combinedData = [];
    combinedData.addAll(postsSnapshot.docs.map((doc) {
      Map<String, dynamic> postData = {
        'type': 'post',
        ...doc.data() as Map<String, dynamic>
      };
      return postData;
    }));

    combinedData.addAll(pollsSnapshot.docs.map((doc) {
      Map<String, dynamic> pollData = {
        'type': 'poll',
        ...doc.data() as Map<String, dynamic>
      };
      return pollData;
    }));
    combinedData.sort((a, b) => (int.parse(b['timestamp'] as String))
        .compareTo(int.parse(a['timestamp'] as String)));

    for (int index = 0; index < combinedData.length; index++) {
      if (combinedData[index]['type'] == 'post') {
        PostModel post = PostModel.fromJson(combinedData[index]);

        postModels.add(post);
      } else if (combinedData[index]['type'] == 'poll') {
        PollModel poll = PollModel.fromJson(combinedData[index]);
        pollModels.add(poll);
      }
    }
    combinedList.value = combinedData;
    update();
    loading.value = false;
    RxStatus.success();
  }

  Future<void> likePost(String postId, String userId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      final post = PostModel.fromJson(snapshot.data()!);

      final isLiked = post.like!.contains(userId);

      if (isLiked) {
        // User already liked, so unlike

        post.like!.remove(userId);
        transaction.update(postRef, {
          'like': FieldValue.arrayRemove([userId]),
        });
      } else {
        // User not liked, so like

        post.like!.add(userId);
        transaction.update(postRef, {
          'like': FieldValue.arrayUnion([userId]),
        });
      }

      // Update the local post model
      final postIndex =
          postModels.indexWhere((element) => element.id == postId);
      if (postIndex != -1) {
        postModels[postIndex] = post;
        update(); // Update your UI or call rebuild functions
      }
    });
  }

  Future<void> vote(
      String pollId, String optionId, String userId, bool unvote) async {
    final pollRef = FirebaseFirestore.instance.collection('polls').doc(pollId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(pollRef);
      if (!snapshot.exists) {
        throw Exception('Poll not found');
      }

      final pollData = snapshot.data()!;
      final poll = PollModel.fromJson(pollData);
      // Remove user's vote from all options
      if (unvote == false) {
        for (final option in poll.options) {
          option.voterId?.remove(userId);
        }
      }
      final optionIndex =
          poll.options.indexWhere((option) => option.id == optionId);

      if (optionIndex == -1) {
        throw Exception('Invalid option ID');
      }

      final option = poll.options[optionIndex];
      ;
      final isVoted = option.voterId?.contains(userId) ?? false;

      if (isVoted) {
        // Unvote

        option.voterId?.remove(userId);
      } else {
        // Vote

        option.voterId?.add(userId);
      }
      poll.options[optionIndex] = option;
      // Update only the voterId list inside the specified option

      await transaction.update(
          pollRef, {'options': poll.options.map((opt) => opt.toJson()).toList()}
          //   {'options$optionIndex}': option.toJson()},
          );

      // Update your local state if needed
      final pollIndex = pollModels.indexWhere((p) => p.id == pollId);
      if (pollIndex != -1) {
        pollModels[pollIndex] = poll;

        update(); // Assuming feedController is an instance of GetxController
      }
    });
  }

  Future<List<UserModel>> getVoters(String pollId, OptionModel option) async {
    List<UserModel> Voters = [];

    if (option.voterId != null && option.voterId!.isNotEmpty) {
      for (int i = 0; i < option.voterId!.length; i++) {
        DocumentSnapshot votersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(option.voterId![i])
            .get();
        ;
        if (votersSnapshot.exists) {
          Voters.add(UserModel.fromJson(
              votersSnapshot.data() as Map<String, dynamic>));
        }
      }

      // Update the PostModel with the list of liked users
      //  post.like = likedByUsers;
      return Voters;
    } else {
      return [];
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      Indicator.showLoading();
      await firebaseService.deletePost(postId);
      // Remove the deleted post from your local state
      // postModels.removeWhere((post) => post.id == postId);
      // Update your UI or call rebuild functions
      // update();
      Indicator.closeLoading();
      Get.back();
      await getPostsAndPolls();

      Get.snackbar(
        'Success',
        'Post deleted successfully',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Indicator.closeLoading();
      Get.snackbar(
        'Error',
        e.message ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      ;
      Indicator.closeLoading();
      Get.snackbar(
        'Error',
        'An error occurred while deleting the post',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deletePoll(String pollId) async {
    try {
      Indicator.showLoading();
      await firebaseService.deletePoll(pollId);
      // Remove the deleted post from your local state
      // postModels.removeWhere((post) => post.id == postId);
      // Update your UI or call rebuild functions
      // update();
      Indicator.closeLoading();
      Get.back();
      await getPostsAndPolls();

      Get.snackbar(
        'Success',
        'Post deleted successfully',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Indicator.closeLoading();
      Get.snackbar(
        'Error',
        e.message ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      ;
      Indicator.closeLoading();
      Get.snackbar(
        'Error',
        'An error occurred while deleting the post',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> downloadImage(String imagePath) async {
    try {
      Indicator.showLoading();
      FileDownloader.downloadFile(
        url: imagePath,
        onDownloadCompleted: (path) {
          Indicator.closeLoading();
          // Get.off(MainPage(), preventDuplicates: false);
          Get.snackbar(
            'Success',
            'Image saved to gallery successfully',
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        onDownloadError: (errorMessage) {
          Indicator.closeLoading();
          Get.snackbar(
            'Error',
            'An error occurred while downloading the image',
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        },
      );
    } catch (e) {
      Indicator.closeLoading();
      Get.snackbar(
        'Error',
        'An error occurred while downloading the image',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
