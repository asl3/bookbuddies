import 'package:flutter/material.dart';
import 'user.dart';
import 'package:uuid/uuid.dart';

class Comment extends ChangeNotifier {
  final String commentId = const Uuid().v4();
  final User user;
  final String comment;
  final DateTime time;

  Comment(this.user, this.comment, this.time);

  factory Comment.fromJson(Map<String, dynamic> json) {
    Comment comment = Comment(
        User.fromJson(json['user']), 
        json['comment'], 
        DateTime.parse(json['time'])
    );

    comment.user.addListener(comment.notifyListeners);

    return comment;
  }
}