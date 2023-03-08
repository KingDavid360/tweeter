import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? id;
  final String? postId;
  final String? userId;
  final DateTime? date;
  final String? profilePhoto;
  final String? postContent;
  final String? userImage;
  final List? likes;
  final int? likesLength;
  final String? userName;
  final String? userDisplayName;
  final List? comment;
  final int? commentLength;

  const PostModel(
      {this.id,
      this.postId,
      this.userId,
      this.date,
      this.profilePhoto,
      this.postContent,
      this.userImage,
      this.likes,
      this.likesLength,
      this.userName,
      this.userDisplayName,
      this.comment,
      this.commentLength});

  toJson() {
    return {
      "postId": postId,
      "userId": userId,
      "date": date,
      "profilePhoto": profilePhoto,
      "postContent": postContent,
      "userImage": userImage,
      "likes": likes,
      "likesLength": likesLength,
      "userName": userName,
      "userDisplayName": userDisplayName,
      "comment": comment,
      "commentLength": commentLength
    };
  }

  factory PostModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PostModel(
        id: document.id,
        postId: data["postId"],
        userId: data["userId"],
        date: data["date"].toDate(),
        profilePhoto: data["profilePhoto"],
        postContent: data["postContent"],
        userImage: data["userImage"],
        likes: data["likes"],
        likesLength: data["likesLength"],
        userName: data["userName"],
        comment: data["comment"],
        commentLength: data["commentLength"],
        userDisplayName: data["userDisplayName"]);
  }
}
