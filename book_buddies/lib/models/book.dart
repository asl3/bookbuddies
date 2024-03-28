import 'package:flutter/material.dart';
import 'firestore_model.dart';
import '../schemas/book.dart' as schemas;

class Book extends FirestoreModel<schemas.Book> with ChangeNotifier {
  Book({required super.id})
      : super(collection: "books", creator: schemas.Book.fromMap);

  factory Book.fromInfo(schemas.Book value) {
    return FirestoreModel.fromInfo(value, "books") as Book;
  }

  @override
  create() async {
    super.createWithMap(value.toMap());
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
