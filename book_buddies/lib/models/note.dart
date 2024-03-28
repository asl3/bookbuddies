import 'package:flutter/material.dart';
import 'firestore_model.dart';
import 'book.dart';
import '../schemas/note.dart' as schemas;

class Note extends FirestoreModel<schemas.Note> with ChangeNotifier {
  Note({required super.id})
      : super(collection: "notes", creator: schemas.Note.fromMap);

  factory Note.fromInfo(schemas.Note value) {
    return FirestoreModel.fromInfo(value, "notes") as Note;
  }

  @override
  create() async {
    super.createWithMap(value.toMap());
  }

  String get title => value.title;
  String get text => value.text;
  DateTime get updatedAt => value.updatedAt;
  Book get book => Book.fromInfo(value.book);

  void editNote(String title, String text) {
    value.title = title;
    value.text = text;
    value.updatedAt = DateTime.now();
    doc?.update({"title": title, "text": text, "updatedAt": value.updatedAt});
    notifyListeners();
  }
}
