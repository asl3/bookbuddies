import 'base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'book.dart';

class Note extends BaseSchema {
  String title;
  String text;
  DateTime updatedAt;

  Note(
      {required this.title,
      required this.text,
      required this.updatedAt,
      super.doc});

  factory Note.fromMap(
      Map<String, dynamic> data, DocumentReference<Map<String, dynamic>>? doc) {
    String title = data["title"];
    String text = data["text"];
    DateTime updatedAt = data["updatedAt"].toDate();

    return Note(title: title, text: text, updatedAt: updatedAt, doc: doc);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "text": text,
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }
}
