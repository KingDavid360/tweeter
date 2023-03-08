import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:twitter_app/components/controller/post_controller.dart';
import 'package:twitter_app/models/post/post_model.dart';
import 'package:uuid/uuid.dart';

import '../../components/controller/authentication.dart';
import '../../components/controller/singup_controller.dart';
import '../../components/controller/user.dart';

class AddTweetScreen extends StatefulWidget {
  const AddTweetScreen({Key? key}) : super(key: key);

  @override
  State<AddTweetScreen> createState() => _AddTweetScreenState();
}

class _AddTweetScreenState extends State<AddTweetScreen> {
  final controller = Get.put(PostController());
  bool _onTap() {
    if (controller.postContent.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    final userController = Get.put(User());
    final authController = Get.put(Authentication());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )),
              trailing: GestureDetector(
                onTap: () async {
                  if (_key.currentState!.validate()) {
                    String postId = const Uuid().v1();
                    final post = PostModel(
                      postId: postId,
                      postContent: controller.postContent.text.trim(),
                      userName: userController.userData.userName,
                      userDisplayName: userController.userData.name,
                      userId: userController.userData.userId,
                      likes: [],
                      likesLength: controller.postData.likes?.length,
                      comment: [],
                      commentLength: controller.postData.comment?.length,
                      date: DateTime.now(),
                      profilePhoto: userController.userData.profilePhoto,
                    );
                    if (_onTap() == true) {
                      controller.postContent.clear();
                      await controller.createPost(post);
                      Navigator.pop(context);
                    }
                    // await controller.getAllPosts();
                  }
                },
                child: Container(
                  height: 40,
                  width: 85,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(20),
                          left: Radius.circular(20))),
                  child: const Center(
                    child: Text(
                      'Tweet',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                  key: _key,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 25,
                      child: userController.userData.profilePhoto == ''
                          ? Icon(
                              Icons.person_outline_rounded,
                              size: 40,
                              color: Colors.black,
                            )
                          : Image.network(
                              userController.userData.profilePhoto.toString(),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                    ),
                    title: TextFormField(
                      controller: controller.postContent,
                      decoration: const InputDecoration(
                        label: Text('what\'s happening?'),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
