import 'package:flutter/material.dart';
import 'firestore_model.dart';
import 'book.dart';
import '../schemas/note.dart' as schemas;

class Note extends FirestoreModel<schemas.Note> with ChangeNotifier {
  Note({required super.id})
      : super(collection: "notes", creator: schemas.Note.fromMap);

  factory Note.fromInfo(schemas.Note value) {
    var model = Note(id: null);
    model.value = value;
    return model;
  }

  factory Note.fromArgs({
    required String title,
    required String text,
    required DateTime updatedAt,
    required Book book,
  }) {
    Note n = Note.fromInfo(schemas.Note(
      title: title,
      text: text,
      updatedAt: updatedAt,
    ));
    n.book = book;
    return n;
  }

  @override
  create() async {
    Map<String, dynamic> map = value.toMap();
    map["book"] = book.doc;
    super.createWithMap(map);
  }

  String get title => value.title;
  String get text => value.text;
  DateTime get updatedAt => value.updatedAt;
  // Book get book => Book.fromInfo(value.book);
  late Book book;

  @override
  loadData() {
    super.loadData();
    doc?.get().then((event) {
      book = Book(id: event.data()!["book"].id);
    });
  }

  void editNote(String title, String text) {
    value.title = title;
    value.text = text;
    value.updatedAt = DateTime.now();
    doc?.update({"title": title, "text": text, "updatedAt": value.updatedAt});
    notifyListeners();
  }
}
