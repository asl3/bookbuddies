import 'package:flutter/material.dart';
import 'user.dart';
import 'firestore_model.dart';
import '../schemas/comment.dart' as schemas;

class Comment extends FirestoreModel<schemas.Comment> with ChangeNotifier {
  Comment({required super.id})
      : super(collection: "comments", creator: schemas.Comment.fromMap);

  factory Comment.fromInfo(schemas.Comment value) {
    return FirestoreModel.fromInfo(value, "comments") as Comment;
  }

  @override
  create() async {
    super.createWithMap(value.toMap());
  }

  String get text => value.text;
  DateTime get time => value.time;
  User get user => User.fromInfo(value.user);
}
