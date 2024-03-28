import 'package:flutter/material.dart';
import 'firestore_model.dart';
import '../schemas/book.dart' as schemas;
import 'package:cloud_firestore/cloud_firestore.dart';

class Book extends FirestoreModel<schemas.Book> with ChangeNotifier {
  Book({required super.id})
      : super(collection: "books", creator: schemas.Book.fromMap);

  factory Book.fromInfo(schemas.Book value) {
    var model = Book(id: null);
    model.value = value;
    return model;
  }

  factory Book.fromArgs({
    required String volumeId,
    required String title,
    required String author,
    required String genre,
    required String coverUrl,
    required String readingStatus,
    required int rating,
    required bool isPublic,
  }) {
    return Book.fromInfo(schemas.Book(
      volumeId: volumeId,
      title: title,
      author: author,
      genre: genre,
      coverUrl: coverUrl,
      readingStatus: readingStatus,
      rating: rating,
      isPublic: isPublic,
    ));
  }

  @override
  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    id = volumeId;
    doc = db.collection(collection).doc(id);
    await doc?.get().then((event) {
      if (!event.exists) {
        doc?.set(value.toMap());
      }
    });
    value.doc = doc;
  }

  String get volumeId => value.volumeId;
  String get title => value.title;
  String get author => value.author;
  String get genre => value.genre;
  String get coverUrl => value.coverUrl;
  String get readingStatus => value.readingStatus;
  int get rating => value.rating;
  bool get isPublic => value.isPublic;

  void toggleVisiblity(bool isPublic) {
    value.isPublic = isPublic;
    doc?.update({"isPublic": isPublic});
    notifyListeners();
  }

  void toggleRating(int rating) {
    value.rating = rating;
    doc?.update({"rating": rating});
    notifyListeners();
  }

  void setReadingStatus(String readingStatus) {
    value.readingStatus = readingStatus;
    doc?.update({"readingStatus": readingStatus});
    notifyListeners();
  }
}
