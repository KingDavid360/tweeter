import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_app/components/controller/authentication.dart';
import 'package:twitter_app/models/post/post_model.dart';

class PostController extends GetxController {
  static PostController get instance => Get.find();

  PostModel postData = PostModel();

  final postContent = TextEditingController();
  final commentContent = TextEditingController();
  final authController = Get.put(Authentication());

  var user;
  final _db = FirebaseFirestore.instance;

  createPost(PostModel post) async {
    await _db
        .collection("posts")
        .doc(post.postId)
        .set(post.toJson())
        .whenComplete(
          () => Get.snackbar("Tweeted", "Tweet successfully tweeted",
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
  }

  Future<PostModel> getPost(String userId) async {
    final snapshot =
        await _db.collection("posts").where("userId", isEqualTo: userId).get();
    postData = snapshot.docs.map((e) => PostModel.fromSnapshot(e)).single;
    print(postData.postId);
    return postData;
  }

  Stream<List<PostModel>> getAllPosts() async* {
    final snapshot = await _db.collection("posts").get();
    final postData =
        snapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList();
    yield postData;
  }

  Future<String> likePost(String postId, String userId, List likes) async {
    String res = "Something went wrong";
    try {
      if (likes.contains(userId)) {
        await _db.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayRemove([userId]),
        });
      } else {
        await _db.collection("posts").doc(postId).update({
          'likes': FieldValue.arrayUnion([userId]),
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> commentPost(String postId, String reply) async {
    String res = "Something went wrong";
    try {
      await _db
          .collection("posts")
          .doc(postId)
          .update({
            "comment": FieldValue.arrayUnion([reply]),
          })
          .whenComplete(
            () => Get.snackbar("Reply", "Reply successfully sent",
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
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future deletePosts(String postId) async {
    try {
      print(postData.postId);
      print(postId);
      await _db.collection("posts").doc(postId).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
