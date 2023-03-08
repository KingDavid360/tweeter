import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twitter_app/components/controller/authentication.dart';
import 'package:twitter_app/components/controller/post_controller.dart';
import 'package:twitter_app/components/controller/profile_controller.dart';
import 'package:twitter_app/components/controller/user.dart';
import 'package:twitter_app/screens/add_tweet_screen/post.dart';
import 'package:twitter_app/screens/comment/comment_screen.dart';
import 'package:twitter_app/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final authenticationController = Get.put(Authentication());
    final userController = Get.put(User());
    userController.getUserDetails(
        "${authenticationController.firebaseUser.value?.email}");
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    final postController = Get.put(PostController());
    final userController = Get.put(User());
    final authenticationController = Get.put(Authentication());
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTweetScreen()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return Column(
                children: [
                  ListTile(
                    leading: IconButton(
                        onPressed: () {
                          Authentication.instance.signOut();
                        },
                        icon: const Icon(Icons.menu)),
                    trailing: IconButton(
                        onPressed: () {
                          profileController.getUserData();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()));
                        },
                        icon: const Icon(Icons.person_outline_rounded)),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30.0),
                                child: ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.white,
                                        child: userController
                                                    .userData.profilePhoto ==
                                                ''
                                            ? Icon(
                                                Icons.person_outline_rounded,
                                                size: 40,
                                                color: Colors.black,
                                              )
                                            : Image.network(
                                                "${snapshot.data!.docs[index]["profilePhoto"]}",
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              )),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!
                                              .docs[index]["userDisplayName"]
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Flexible(
                                          child: Text(
                                            "@ ${snapshot.data!.docs[index]["userName"].toString()}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_horiz),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                                child: Authentication
                                                            .instance
                                                            .firebaseUser
                                                            .value!
                                                            .uid ==
                                                        snapshot.data!
                                                                .docs[index]
                                                            ["userId"]
                                                    ? Text('Delete post')
                                                    : Text("cancel"),
                                                onTap: () async {
                                                  print(
                                                      "current: ${Authentication.instance.firebaseUser.value!.uid}");
                                                  print(
                                                      "post: ${snapshot.data!.docs[index]["userId"]}");
                                                  if (Authentication
                                                          .instance
                                                          .firebaseUser
                                                          .value!
                                                          .uid ==
                                                      snapshot.data!.docs[index]
                                                          ["userId"]) {
                                                    print(
                                                        "current: ${Authentication.instance.firebaseUser.value!.uid}");
                                                    print(
                                                        "post: ${PostController.instance.postData.postId}");
                                                    await PostController
                                                        .instance
                                                        .deletePosts(snapshot
                                                                .data!
                                                                .docs[index]
                                                            ["postId"]);
                                                  }
                                                })
                                          ]),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot
                                            .data!.docs[index]["postContent"]
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => CommentScreen(
                                                          postId: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ["postId"]
                                                              .toString(),
                                                          username: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ["userName"]
                                                              .toString(),
                                                          displayName: snapshot
                                                              .data!
                                                              .docs[index][
                                                                  "userDisplayName"]
                                                              .toString(),
                                                          tweet: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ["postContent"]
                                                              .toString()),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons
                                                      .chat_bubble_outline_rounded,
                                                ),
                                              ),
                                              Text(
                                                "${snapshot.data!.docs[index]["comment"].length}",
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    await postController
                                                        .likePost(
                                                      snapshot.data!
                                                          .docs[index]["postId"]
                                                          .toString(),
                                                      "${User.instance.userData.userId}",
                                                      snapshot.data!.docs[index]
                                                          ["likes"],
                                                    );
                                                  },
                                                  icon: snapshot.data!
                                                          .docs[index]["likes"]
                                                          .contains(
                                                              authenticationController
                                                                  .firebaseUser
                                                                  .value!
                                                                  .uid)
                                                      ? const Icon(
                                                          Icons
                                                              .favorite_rounded,
                                                          color: Colors.red,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .favorite_border_outlined,
                                                        )),
                                              Text(
                                                "${snapshot.data!.docs[index]["likes"].length}",
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('something went wrong'),
              );
            }
          },
        ),
      ),
    );
  }
}
