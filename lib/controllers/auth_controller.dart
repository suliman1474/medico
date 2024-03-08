import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medico/controllers/db_controller.dart';
import 'package:medico/controllers/screen_controller.dart';
import 'package:medico/models/about_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user_model.dart';
import '../screens/Authentication/login_screen.dart';
import '../screens/home/folders_screen.dart';
import '../screens/home/main_page.dart';
import '../services/firebase_services.dart';
import '../widgets/indicator.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController college = TextEditingController();
  TextEditingController discipline = TextEditingController();
  TextEditingController semester = TextEditingController();
  TextEditingController contact = TextEditingController();
  RxBool isObsecure = true.obs;
  RxBool isObsecure2 = true.obs;

  Rx<User?> user = Rx<User?>(null);

  DbController dbController = Get.find();
  Rx<UserModel?> userProfile = Rx<UserModel?>(null);
  Rx<AboutModel?> aboutInfo = Rx<AboutModel?>(null);

  FirebaseService firebaseService = FirebaseService();
  ScreenController screenController = Get.find();
  void isLoggedIn() async {
    if (_auth.currentUser != null) {
      // user.value = _auth.currentUser;
      // userProfile.value = await firebaseService.getProfile(user.value!.uid);
      await _firebaseMessaging.requestPermission();
      // Get FCM token
      String? fcmToken = await _firebaseMessaging.getToken();

      if (_auth.currentUser != null && fcmToken != null) {
        ;
        await firebaseService.updateFCMToken(_auth.currentUser!.uid, fcmToken);
      }
      ;
      Get.to(() => const MainPage());
    } else {
      Get.toNamed('/login-screen');
    }
  }

  @override
  void onReady() {
    super.onReady();
    // isLoggedIn();
    fetchAboutInfo();
  }

  toggleObsecure() {
    isObsecure.value = !isObsecure.value;
  }

  toggleObsecure2() {
    isObsecure2.value = !isObsecure2.value;
  }

  updateUserProfile(
    String name,
    String college,
    String discipline,
    String semester,
    String contact,
    XFile? selectedImage,
  ) async {
    try {
      Indicator.showLoading();

      userProfile.value = await firebaseService.updateUser(
        name,
        college,
        discipline,
        semester,
        contact,
        selectedImage,
      );
      await dbController.storeUser(userProfile.value!);
      Indicator.closeLoading();
      Get.off(MainPage());
    } on FirebaseAuthException catch (e) {
      Indicator.closeLoading();
      return Get.snackbar(
        'Error',
        e.message ?? '',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  signInWithEmailandPassword(String email, String password) async {
    try {
      Indicator.showLoading();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      await fetchUserProfile();
      await dbController.storeUser(userProfile.value!);

      Indicator.closeLoading();

      Get.offAndToNamed('/home');
    } on FirebaseAuthException catch (e) {
      Indicator.closeLoading();

      return Get.snackbar(
        'Error',
        e.code,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  createUser() async {
    try {
      Indicator.showLoading();

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trimRight(),
        password: password.text,
      )
          .whenComplete(() async {
        user.value = _auth.currentUser;

        await createDefaultUserProfile();
      });
      // UserModel userToStore = UserModel(
      //   id: user.value!.uid,
      //   name: name.text,
      //   college: college.text,
      //   contact: contact.text,
      //   discipline: discipline.text,
      //   email: email.text,
      //   semester: semester.text,
      // );
      // await _firebaseMessaging.requestPermission();
      // String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Update FCM token in user's document
      // if (user.value != null && fcmToken != null) {
      //   await firebaseService.addFCMToken(user.value!.uid, fcmToken);
      // }

      await fetchUserProfile();
      await dbController.storeUser(userProfile.value!);
      Indicator.closeLoading();

      Get.offAndToNamed('/home');
    } on FirebaseAuthException catch (e) {
      Indicator.closeLoading();
      return Get.snackbar(
        'Error',
        e.code,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {}
  }

  Future<UserCredential> signInWithGoogle() async {
    Indicator.showLoading();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      user.value = _auth.currentUser;

      await fetchUserProfile();
      await dbController.storeUser(userProfile.value!);
      Indicator.closeLoading();
      Get.toNamed('/home');
    });
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance
        .signInWithCredential(oauthCredential)
        .whenComplete(() async {
      user.value = _auth.currentUser;
      //  await createDefaultUserProfile();
      // fetchUserProfile();
      Indicator.closeLoading();
      Get.toNamed('/home');
    });
  }

  Future<void> logout() async {
    Indicator.showLoading();
    await FirebaseAuth.instance.signOut().whenComplete(() async {
      await GoogleSignIn().signOut();

      await dbController.signOut();
      Indicator.closeLoading();
      screenController.updatePageAt(
          AppPage.HomeScreen,
          FoldersScreen(
            // folders: rootFolders,
            back: false,

            path: '/folders',
          ));
      Get.off(() => const LoginScreen());
    });
  }

  Future<void> fetchUserProfile() async {
    final userId = _auth.currentUser?.uid;
    try {
      if (userId != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (doc.exists) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

          // Check if the 'role' field is not equal to 'admin'
          if (userData['role'] != 'admin') {
            // If the document exists, update the fcmToken field
            await _firebaseMessaging.requestPermission();
            String? fcmToken = await FirebaseMessaging.instance.getToken();
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'fcmToken': fcmToken});
          } else {
            ;
          }

          // Fetch the updated document
          final updatedDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

          if (updatedDoc.exists) {
            userProfile.value =
                UserModel.fromJson(updatedDoc.data() as Map<String, dynamic>);
          }
        } else {
          // Handle the case when the document doesn't exist
          ;
        }
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      ;
    }
  }

  Future<void> createDefaultUserProfile() async {
    final userId = _auth.currentUser?.uid;
    //  String email = _auth.currentUser?.email ?? "";
    // List<String> parts = email.split("@");
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(UserModel(
            id: userId,
            name: name.text,
            college: college.text,
            contact: contact.text,
            discipline: discipline.text,
            email: email.text,
            semester: semester.text,
          ).toJson());
    }
  }

  Future<void> updateInfo(
    String description,
    String whatsapp,
    String insta,
    String gmail,
    String name,
    XFile? selectedImage,
  ) async {
    try {
      Indicator.showLoading();
      await firebaseService.updateInfo(
        description,
        whatsapp,
        insta,
        gmail,
        name,
        selectedImage,
      );
      AboutModel? info = await firebaseService.fetchAboutInfo();
      if (info != null) {
        aboutInfo.value = info;
      }
      Indicator.closeLoading();
      Get.off(MainPage());
    } catch (e) {
      // Handle errors if necessary
      print("error updating about info: $e");
      Indicator.closeLoading();
    }
  }

  Future<void> fetchAboutInfo() async {
    try {
      // Fetch the about info from Firebase
      AboutModel? info = await firebaseService.fetchAboutInfo();
      if (info != null) {
        // print('about info fetched');
        aboutInfo.value = info;
      }
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching about info: $e');
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
