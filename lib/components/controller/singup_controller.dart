// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:twitter_app/components/controller/authentication.dart';
// import 'package:twitter_app/components/controller/user.dart';
// import 'package:twitter_app/models/user_model/user.dart';
//
// class SignUpController extends GetxController {
//   static SignUpController get instance => Get.find();
//
//   //text field controllers to get data from text fields
//   final email = TextEditingController();
//   final password = TextEditingController();
//   final username = TextEditingController();
//   final displayName = TextEditingController();
//   final phoneNo = TextEditingController();
//
//   // final userController = Get.put(User());
//
//   void registerUsers(String email, String password) {
//     Authentication.instance.createUserWithEmailAndPassword(email, password);
//   }
//
//   void signInUsers(String email, String password) {
//     Authentication.instance.loginWithEmailAndPassword(email, password);
//   }
//
//   // Future<void> createUsers(UserModel user) async {
//   //   await userController.createUser(user);
//   // }
// }
