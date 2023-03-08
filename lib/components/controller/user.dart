// user repo to perform database operations

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_app/models/post/post_model.dart';
import 'package:twitter_app/models/user_model/user.dart';

class User extends GetxController {
  static User get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  UserModel userData = UserModel();

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("users").where("email", isEqualTo: email).get();
    userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> allUsersData() async {
    final snapshot = await _db.collection("users").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<String> updateProfilePhoto(String userId, String imageUrl) async {
    String res = "Something went wrong";
    try {
      print(userId);
      await _db
          .collection("users")
          .doc(userId)
          .update({
            "profilePhoto": imageUrl,
          })
          .whenComplete(
            () => Get.snackbar("Update", "Profile photo updated",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green),
          )
          .catchError((error, stackTrace) {
            Get.snackbar("Error", "Something went wrong, try again.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                colorText: Colors.red);
            print(error.toString());
          });
      res = "Success";
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
}
