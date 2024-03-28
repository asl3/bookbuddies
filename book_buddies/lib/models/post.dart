import 'package:flutter/material.dart';
import 'book.dart';
import 'comment.dart';
import 'firestore_model.dart';
import '../schemas/post.dart' as schemas;
import 'package:cloud_firestore/cloud_firestore.dart';

class Post extends FirestoreModel<schemas.Post> with ChangeNotifier {
  Post({required super.id})
      : super(collection: "posts", creator: schemas.Post.fromMap);

  factory Post.fromInfo(schemas.Post value) {
    var model = Post(id: null);
    model.value = value;
    return model;
  }

  factory Post.fromArgs({
    required String messageType,
    required Book book,
    required DateTime time,
    required List<Comment> comments,
    required List<String> likers,
  }) {
    Post p = Post.fromInfo(schemas.Post(
      messageType: messageType,
      time: time,
      likers: likers,
    ));
    p.book = book;
    p.comments = comments;
    return p;
  }

  @override
  create() async {
    Map<String, dynamic> map = value.toMap();
    map["book"] = book.doc;
    map["comments"] = comments.map((comment) => comment.doc).toList();
    super.createWithMap(map);
  }

  String get messageType => value.messageType;
  DateTime get time => value.time;
  List<String> get likers => value.likers;
  late Book book;
  List<Comment> comments = [];

  @override
  loadData() {
    super.loadData();
    doc?.get().then((event) {
      Map data = event.data()!;
      book = Book(id: data["book"].id);
      for (DocumentReference<Map<String, dynamic>> comment
          in data["comments"]) {
        comments.add(Comment(id: comment.id));
      }
    });
  }

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
