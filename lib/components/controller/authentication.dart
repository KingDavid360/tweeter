import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:twitter_app/components/controller/post_controller.dart';
import 'package:twitter_app/components/exceptions/signup_email_password_failures.dart';
import 'package:twitter_app/models/user_model/user.dart';
import 'package:twitter_app/screens/home_screen/home.dart';
import 'package:twitter_app/screens/signup_screen/signup.dart';

class Authentication extends GetxController {
  static Authentication get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  late UserCredential credential;
  UserModel user = UserModel();

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const SignUpScreen())
        : Get.off(() => const HomeScreen());
  }

  Future<void> signupUser(String email, String password, String userName,
      String phoneNumber, String name) async {
    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      user = UserModel(
          userId: credential.user?.uid,
          followers: [],
          following: [],
          email: email,
          name: name,
          userName: userName,
          phoneNumber: phoneNumber,
          profilePhoto: "");

      await _db
          .collection("users")
          .doc(firebaseUser.value!.uid)
          .set(user.toJson())
          .whenComplete(
            () => Get.snackbar("Success", "Your account has been created.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green),
          )
          .catchError((error, stackTrace) {
        Get.snackbar(
          "Error",
          "Something went wrong, try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red,
        );
        print(error.toString());
      });

      firebaseUser.value != null
          ? Get.offAll(() => const HomeScreen())
          : Get.off(() => const SignUpScreen());
    } on FirebaseException catch (e) {
      final ex = SignupWithEmailAndPasswordFailures.code(e.code);
      print('FIREBASE AUTH - ${ex.message}');
      throw ex;
    } catch (_) {
      const ex = SignupWithEmailAndPasswordFailures();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const HomeScreen())
          : Get.off(() => const SignUpScreen());
    } on FirebaseException catch (e) {
      print(e);
    } catch (_) {}
  }

  Future<void> signOut() async => await _auth.signOut();

  Future deleteUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      user!.delete();
      await _db.collection("users").doc(firebaseUser.value!.uid).delete();

      // await postController.deletePosts();
      signOut();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
