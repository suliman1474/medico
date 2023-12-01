import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user_model.dart';
import '../screens/Authentication/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/main_page.dart';
import '../services/firebase_services.dart';
import '../widgets/indicator.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  Rx<UserModel?> userProfile = Rx<UserModel?>(null);
  FirebaseService firebaseService = FirebaseService();
  void isLoggedIn() async {
    if (_auth.currentUser != null) {
      // user.value = _auth.currentUser;
      // userProfile.value = await firebaseService.getProfile(user.value!.uid);
      print('IS LOGGED IN');
      Get.to(() => const MainPage());
    } else {
      Get.toNamed('/login-screen');
    }
  }

  @override
  void onReady() {
    super.onReady();
    // isLoggedIn();
  }

  toggleObsecure() {
    isObsecure.value = !isObsecure.value;
  }

  toggleObsecure2() {
    isObsecure2.value = !isObsecure2.value;
  }

  Future<void> updateUserProfile(String name, XFile? selectedImage) async {
    try {
      Indicator.showLoading();
      userProfile.value = await firebaseService.updateUser(name, selectedImage);

      Indicator.closeLoading();
      Get.offNamed('/home');
    } catch (e) {
      print(e);
    }
  }

  signInWithEmailandPassword() async {
    try {
      Indicator.showLoading();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      Indicator.closeLoading();
      email.text = "";
      password.text = "";
      user.value = _auth.currentUser;
      // await createDefaultUserProfile();
      Get.to(() => const HomeScreen());
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
      print('create user function');
      Indicator.showLoading();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email.text.trimRight(),
        password: confirmpassword.text,
      )
          .whenComplete(() async {
        user.value = _auth.currentUser;
        print('creatting defaultt user');
        await createDefaultUserProfile();
        Indicator.closeLoading();
        Get.toNamed('/home');
      });
    } on FirebaseAuthException catch (e) {
      Indicator.closeLoading();
      return Get.snackbar(
        'Error',
        e.code,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print(e);
    }
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
      //  await createDefaultUserProfile();
      fetchUserProfile();
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

  void logout() async {
    Indicator.showLoading();
    await FirebaseAuth.instance.signOut().whenComplete(() {
      Indicator.closeLoading();
      Get.off(() => const LoginScreen());
    });
    await GoogleSignIn().signOut();
  }

  Future<void> fetchUserProfile() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        userProfile.value =
            UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
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
          .set(UserModel(id: userId, name: name.text, college: college.text, contact: contact.text, discipline: discipline.text, email: email.text, semester: semester.text,).toJson());
     // userProfile.value = UserModel(id: userId, name: parts.first);
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
