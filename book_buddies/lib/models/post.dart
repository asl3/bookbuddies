import 'package:flutter/material.dart';
import 'book.dart';
import 'comment.dart';
import 'firestore_model.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../schemas/post.dart' as schemas;
import '../schemas/book.dart' as schema_book;

class Post extends FirestoreModel<schemas.Post> with ChangeNotifier {
  Post({required super.id})
      : super(collection: "posts", creator: schemas.Post.fromMap);

  factory Post.fromInfo(schemas.Post value) {
    return FirestoreModel.fromInfo(value, "posts") as Post;
  }

  @override
  create() async {
    super.createWithMap(value.toMap());
  }

  String get messageType => value.messageType;
  DateTime get time => value.time;
  Book get book => Book.fromInfo(value.book);
  List<Comment> get comments =>
      value.comments.map((comment) => Comment.fromInfo(comment)).toList();
  List<String> get likers => value.likers;

  void addLiker(String userId) {
    value.likers.add(userId);
    doc?.update({"likers": value.likers});
    notifyListeners();
  }

  void removeLiker(String userId) {
    value.likers.remove(userId);
    doc?.update({"likers": value.likers});
    notifyListeners();
  }

  void addComment(Comment comment) {
    comment.create();
    comment.addListener(notifyListeners);
    value.comments.add(comment.value);
    doc?.update({"comments": value.comments});
    notifyListeners();
  }

  bool isUserLiking(String userId) {
    return likers.contains(userId);
  }

  static String getMessageTypeForBook(Book book) {
    switch (book.readingStatus) {
      case 'Unread':
        return 'added';
      case 'Reading':
        return 'started';
      case 'Completed':
        return 'finished';
      default:
        throw ArgumentError("Invalid reading status");
    }
  }
}
