import 'package:flutter/material.dart';
import 'user.dart';
import 'firestore_model.dart';
import '../schemas/comment.dart' as schemas;

class Comment extends FirestoreModel<schemas.Comment> with ChangeNotifier {
  Comment({required super.id})
      : super(collection: "comments", creator: schemas.Comment.fromMap);

  factory Comment.fromInfo(schemas.Comment value) {
    var model = Comment(id: null);
    model.value = value;
    return model;
  }

  factory Comment.fromArgs({
    required String text,
    required DateTime time,
    required User user,
  }) {
    Comment c = Comment.fromInfo(schemas.Comment(
      text: text,
      time: time,
    ));
    c.user = user;
    return c;
  }

  @override
  create() async {
    Map<String, dynamic> map = value.toMap();
    map["user"] = user.doc;
    super.createWithMap(map);
  }

  String get text => value.text;
  DateTime get time => value.time;

  late User user;

  @override
  loadData() {
    super.loadData();
    doc?.get().then((event) {
      user = User(id: event.data()!["user"].id);
    });
  }
}
