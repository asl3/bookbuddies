import 'package:flutter/material.dart';
import 'firestore_model.dart';
import 'book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note extends FirestoreModel with ChangeNotifier {
  late String title;
  late String text;
  late DateTime updatedAt;
  late Book book;

  Note({required super.id}) : super(collection: "notes");

  Note.fromArgs({
    required this.title,
    required this.text,
    required this.updatedAt,
    required this.book,
  }) : super(id: null, collection: "notes");

  @override
  Future<void> fromMap(Map<String, dynamic> data) async {
    title = data["title"];
    text = data["text"];
    updatedAt = data["updatedAt"].toDate();
    book = Book(id: data["book"].id);
    await book.loadData();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "text": text,
      "updatedAt": Timestamp.fromDate(updatedAt),
      "book": book.doc,
    };
  }

  void editNote(String title, String text) {
    this.title = title;
    this.text = text;
    updatedAt = DateTime.now();
    doc?.update({"title": title, "text": text, "updatedAt": updatedAt});
    notifyListeners();
  }
}
