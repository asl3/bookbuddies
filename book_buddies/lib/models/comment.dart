import 'package:flutter/material.dart';
import 'user.dart';
import 'firestore_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment extends FirestoreModel with ChangeNotifier {
  late String text;
  late DateTime time;
  late User user;

  Comment({required super.id}) : super(collection: "comments");

  Comment.fromArgs({
    required this.text,
    required this.time,
    required this.user,
  }) : super(id: null, collection: "comments");

  @override
  Future<void> fromMap(Map<String, dynamic> data) async {
    text = data["text"];
    time = data["time"].toDate();
    user = User(id: data["user"].id, loadFull: false);
    await user.loadData();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "text": text,
      "user": user.doc,
      "time": Timestamp.fromDate(time),
    };
  }
}
