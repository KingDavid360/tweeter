import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_app/components/controller/authentication.dart';
import 'package:twitter_app/components/controller/profile_controller.dart';
import 'package:twitter_app/components/controller/user.dart';
import 'package:twitter_app/components/delete_dialog.dart';
import 'package:twitter_app/models/user_model/user.dart';

import '../../components/controller/post_controller.dart';

class ProfileScreen extends StatefulWidget {
  // String? postId;
  const ProfileScreen({
    Key? key,
    // required this.postId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var imageFileUint8List;
  final controller = Get.put(ProfileController());
  final postController = Get.put(PostController());
  final userController = Get.put(User());
  final authController = Get.put(Authentication());
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final authenticationController = Get.put(Authentication());
    final userController = Get.put(User());
    final postController = Get.put(PostController());
    userController.getUserDetails(
        "${authenticationController.firebaseUser.value?.email}");
    postController
        .getPost("${authenticationController.firebaseUser.value?.uid}");
    print(postController.postData.postId);
    print(userController.userData.profilePhoto);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeleteDialog();
                    });
              },
              icon: Icon(
                Icons.delete_rounded,
                color: Colors.redAccent,
                size: 30,
              ))
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.getUserData(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              if (snapShot.hasData) {
                final userData = snapShot.data as UserModel;
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await selectImage();
                            },
                            child: userController.userData.profilePhoto == ''
                                ? Column(
                                    children: [
                                      DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(50),
                                        dashPattern: const [10, 10],
                                        color: Colors.grey,
                                        strokeWidth: 2,
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: const Icon(
                                            Icons.add_a_photo_rounded,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      const Text(
                                        "Add profile photo",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )
                                : Image.network(
                                    userController.userData.profilePhoto
                                        .toString(),
                                    height: 100,
                                    width: 100,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
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
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: userData.email,
                            decoration: const InputDecoration(
                                label: Text('Email address'),
                                prefixIcon: Icon(Icons.email)),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            // keyboardType: TextInputType.text,
                            initialValue: userData.userName,
                            decoration: const InputDecoration(
                                label: Text('Username'),
                                prefixIcon: Icon(Icons.person)),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            // keyboardType: TextInputType.name,
                            initialValue: userData.name,
                            decoration: const InputDecoration(
                              label: Text('Display name'),
                              prefixIcon: Icon(
                                Icons.assignment_ind_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: userData.phoneNumber,
                            decoration: const InputDecoration(
                              label: Text('Phone number'),
                              prefixIcon: Icon(
                                Icons.phone,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    )
                  ],
                );
              } else if (snapShot.hasError) {
                return Center(
                  child: Text(snapShot.error.toString()),
                );
              } else {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  String selectedImagePath = '';
  late bool option;
  String imageUrl = '';
  var bytes;

  selectImageFromCamera() async {
    XFile? cameraFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (cameraFile != null) {
      return cameraFile?.path;
    } else {
      return '';
    }
  }

  selectImageFromGallery() async {
    XFile? galleryFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (galleryFile != null) {
      return galleryFile?.path;
    } else {
      return '';
    }
  }

  Future selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 200,
              child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Text(
                        "Select image from?",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                option = true;
                                selectedImagePath =
                                    await selectImageFromGallery();
                                print('Image_Path:-');
                                print(selectedImagePath);
                                if (selectedImagePath != '') {
                                  String uniqueFileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();

                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();

                                  Reference referenceDir =
                                      referenceRoot.child('images');

                                  Reference referenceImageToUpload =
                                      referenceDir.child(uniqueFileName);

                                  try {
                                    Navigator.pop(context);

                                    await referenceImageToUpload
                                        .putFile(File(selectedImagePath));

                                    imageUrl = await referenceImageToUpload
                                        .getDownloadURL();

                                    await userController.updateProfilePhoto(
                                        userController.userData.userId
                                            .toString(),
                                        imageUrl);
                                    print(imageUrl);
                                  } catch (error) {
                                    //something went wrong
                                  }

                                  setState(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('No image selected!')));
                                }
                              },
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'images/gallery.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                      const Text('Gallery'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                option = false;
                                selectedImagePath =
                                    await selectImageFromCamera();
                                print('Image_Path:-');
                                print(selectedImagePath);
                                if (selectedImagePath != '') {
                                  String uniqueFileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();

                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();

                                  Reference referenceDir =
                                      referenceRoot.child('images');

                                  Reference referenceImageToUpload =
                                      referenceDir.child(uniqueFileName);

                                  try {
                                    await referenceImageToUpload
                                        .putFile(File(selectedImagePath));

                                    imageUrl = await referenceImageToUpload
                                        .getDownloadURL();
                                    Navigator.pop(context);
                                  } catch (error) {
                                    //something went wrong
                                  }
                                  setState(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('No image selected!')));
                                }
                              },
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'images/camera.png',
                                        height: 60,
                                        width: 60,
                                      ),
                                      const Text('Camera'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }
}
