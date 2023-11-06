import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthenticationController extends GetxController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final TextEditingController email = TextEditingController();
  // final TextEditingController password = TextEditingController();
  // final TextEditingController confirmpassword = TextEditingController();
  // RxBool isObsecure = true.obs;
  // RxBool isObsecure2 = true.obs;
  //
  // Rx<User?> user = Rx<User?>(null);
  //
  // Rx<UserModel?> userProfile = Rx<UserModel?>(null);
  // FirebaseService firebaseService = FirebaseService();
  // void isLoggedIn() async {
  //   if (_auth.currentUser != null) {
  //     user.value = _auth.currentUser;
  //     userProfile.value = await firebaseService.getProfile(user.value!.uid);
  //     Get.to(() => const HomeScreen());
  //   } else {
  //     Get.toNamed('/login-screen');
  //   }
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  //   isLoggedIn();
  // }
  //
  // toggleObsecure() {
  //   isObsecure.value = !isObsecure.value;
  // }
  //
  // toggleObsecure2() {
  //   isObsecure2.value = !isObsecure2.value;
  // }

  // Future<void> updateUserProfile(String name, XFile? selectedImage) async {
  //   try {
  //     Indicator.showLoading();
  //     userProfile.value = await firebaseService.updateUser(name, selectedImage);
  //
  //     Indicator.closeLoading();
  //     Get.offNamed('/home');
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // signInWithEmailandPassword() async {
  //   try {
  //     Indicator.showLoading();
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: email.text, password: password.text);
  //     Indicator.closeLoading();
  //     email.text = "";
  //     password.text = "";
  //     user.value = _auth.currentUser;
  //     // await createDefaultUserProfile();
  //     Get.to(() => const HomeScreen());
  //   } on FirebaseAuthException catch (e) {
  //     Indicator.closeLoading();
  //
  //     return Get.snackbar(
  //       'Error',
  //       e.code,
  //       duration: const Duration(seconds: 3),
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
  //
  // createUser() async {
  //   try {
  //     Indicator.showLoading();
  //     await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //       email: email.text.trimRight(),
  //       password: confirmpassword.text,
  //     )
  //         .whenComplete(() async {
  //       user.value = _auth.currentUser;
  //       await createDefaultUserProfile();
  //       Indicator.closeLoading();
  //       Get.toNamed('/home');
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     Indicator.closeLoading();
  //     return Get.snackbar(
  //       'Error',
  //       e.code,
  //       duration: const Duration(seconds: 3),
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // Future<UserCredential> signInWithGoogle() async {
  //   Indicator.showLoading();
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   final GoogleSignInAuthentication? googleAuth =
  //   await googleUser?.authentication;
  //
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   return await FirebaseAuth.instance
  //       .signInWithCredential(credential)
  //       .whenComplete(() async {
  //     user.value = _auth.currentUser;
  //     await createDefaultUserProfile();
  //     fetchUserProfile();
  //     Indicator.closeLoading();
  //     Get.toNamed('/home');
  //   });
  // }
  //
  // void logout() async {
  //   Indicator.showLoading();
  //   await FirebaseAuth.instance.signOut().whenComplete(() {
  //     Indicator.closeLoading();
  //     Get.off(() => const LoginScreen());
  //   });
  //   await GoogleSignIn().signOut();
  // }
  //
  // Future<void> fetchUserProfile() async {
  //   final userId = _auth.currentUser?.uid;
  //   if (userId != null) {
  //     final doc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .get();
  //     if (doc.exists) {
  //       userProfile.value =
  //           UserModel.fromJson(doc.data() as Map<String, dynamic>);
  //     }
  //   }
  // }
  //
  // Future<void> createDefaultUserProfile() async {
  //   final userId = _auth.currentUser?.uid;
  //   String email = _auth.currentUser?.email ?? "";
  //   List<String> parts = email.split("@");
  //   if (userId != null) {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .set(UserModel(id: userId, name: parts.first).toJson());
  //     userProfile.value = UserModel(id: userId, name: parts.first);
  //   }
  // }
}
