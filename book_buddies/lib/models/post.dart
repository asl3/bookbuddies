import 'package:flutter/material.dart';
import 'book.dart';
import 'comment.dart';
import 'firestore_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post extends FirestoreModel with ChangeNotifier {
  late String messageType;
  late Book book;
  late DateTime time;
  List<Comment> comments = [];
  List<String> likers = [];

  Post({required super.id}) : super(collection: "posts");

  factory Post.fromArgs({
    required String messageType,
    required Book book,
    required DateTime time,
    required List<Comment> comments,
    required List<String> likers,
  }) {
    Post p = Post(id: null);
    p.messageType = messageType;
    p.book = book;
    p.time = time;
    p.comments = comments;
    p.likers = likers;
    return p;
  }

  @override
  fromMap(Map<String, dynamic> data) {
    messageType = data["messageType"];
    book = Book(id: data["book"].id);
    time = data["time"].toDate();

    comments = [];
    for (DocumentReference<Map<String, dynamic>> comment in data["comments"]) {
      comments.add(Comment(id: comment.id));
    }

    likers = [];
    for (String liker in data["likers"]) {
      likers.add(liker);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "messageType": messageType,
      "book": book.doc,
      "time": Timestamp.fromDate(time),
      "comments": comments.map((comment) => comment.doc).toList(),
      "likers": likers,
    };
  }

  void addLiker(String userId) {
    likers.add(userId);
    doc?.update({"likers": likers});
    notifyListeners();
  }

  void removeLiker(String userId) {
    likers.remove(userId);
    doc?.update({"likers": likers});
    notifyListeners();
  }

  void addComment(Comment comment) {
    comment.create();
    comment.addListener(notifyListeners);
    comments.add(comment);
    doc?.update({"comments": comments.map((comment) => comment.doc).toList()});
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
