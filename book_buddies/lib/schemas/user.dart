import 'base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User extends BaseSchema {
  AssetImage profilePicture;
  String displayName;
  String email;
  String about;
  String userId;

  User(
      {required this.profilePicture,
      required this.displayName,
      required this.email,
      required this.about,
      required this.userId,
      super.doc});

  factory User.fromMap(
      Map<String, dynamic> data, DocumentReference<Map<String, dynamic>>? doc) {
    AssetImage profilePicture = AssetImage(data["profilePicture"]);
    String displayName = data["displayName"];
    String email = data["email"];
    String about = data["about"];
    String userId = doc!.id;

    return User(
        profilePicture: profilePicture,
        displayName: displayName,
        email: email,
        about: about,
        userId: userId);
  }
}
