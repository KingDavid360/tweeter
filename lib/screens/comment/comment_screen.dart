import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:twitter_app/components/controller/post_controller.dart';
import 'package:twitter_app/components/controller/user.dart';

class CommentScreen extends StatefulWidget {
  String? postId;
  String? username;
  String? displayName;
  String? tweet;
  CommentScreen({
    Key? key,
    required this.postId,
    required this.username,
    required this.displayName,
    required this.tweet,
  }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostController());
    final userController = Get.put(User());
    final _key = GlobalKey<FormState>();
    bool _onTap() {
      if (postController.commentContent.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: ListView(children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  if (_key.currentState!.validate()) {
                    if (_onTap() == true) {
                      await postController.commentPost("${widget.postId}",
                          postController.commentContent.text.trim());
                      postController.commentContent.clear();
                      Navigator.pop(context);
                    }
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
            Form(
                key: _key,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Image.network(
                      userController.userData.profilePhoto.toString(),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  title: TextFormField(
                    controller: postController.commentContent,
                    decoration: const InputDecoration(
                      label: Text('Tweet your reply'),
                    ),
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
