import 'base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment extends BaseSchema {
  String text;
  DateTime time;

  Comment({required this.text, required this.time, super.doc});

  factory Comment.fromMap(
      Map<String, dynamic> data, DocumentReference<Map<String, dynamic>>? doc) {
    String text = data["text"];
    DateTime time = data["time"].toDate();

    return Comment(text: text, time: time, doc: doc);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "text": text,
      // "user": user.doc,
      "time": Timestamp.fromDate(time),
    };
  }
}
