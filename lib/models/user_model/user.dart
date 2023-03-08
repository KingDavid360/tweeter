import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userId;
  final String? email;
  final String? name;
  final String? userName;
  final String? phoneNumber;
  final String? profilePhoto;
  final List? followers;
  final List? following;

  const UserModel(
      {this.userId,
      this.followers,
      this.following,
      this.email,
      this.name,
      this.userName,
      this.phoneNumber,
      this.profilePhoto});

  toJson() {
    return {
      "userId": userId,
      "email": email,
      "name": name,
      "userName": userName,
      "profilePhoto": profilePhoto,
      "phoneNumber": phoneNumber,
      "followers": followers,
      "following": following
    };
  }

  //Map user fetched from firebase to userModel using factory constructor

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        userId: data["userId"],
        email: data["email"],
        name: data["name"],
        userName: data["userName"],
        profilePhoto: data["profilePhoto"],
        phoneNumber: data["phoneNumber"],
        followers: data["followers"],
        following: data["following"]);
  }
}
