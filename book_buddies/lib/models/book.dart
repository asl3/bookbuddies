import 'package:flutter/material.dart';
import 'firestore_model.dart';

class Book extends FirestoreModel with ChangeNotifier {
  late String volumeId;
  late String title;
  late String author;
  late String genre;
  late String coverUrl;
  late String readingStatus;
  late int rating;
  late bool isPublic;

  Book({required super.id}) : super(collection: "books");

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
    Book b = Book(id: null);
    b.volumeId = volumeId;
    b.title = title;
    b.author = author;
    b.genre = genre;
    b.coverUrl = coverUrl;
    b.readingStatus = readingStatus;
    b.rating = rating;
    b.isPublic = isPublic;

    b.id = volumeId;

    return b;
  }

  @override
  fromMap(Map<String, dynamic> data) {
    volumeId = doc!.id;
    id = volumeId;
    title = data["title"];
    author = data["author"];
    genre = data["genre"];
    coverUrl = data["coverUrl"];
    readingStatus = data["readingStatus"];
    rating = data["rating"];
    isPublic = data["isPublic"];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      // "volumeId": volumeId,
      "title": title,
      "author": author,
      "genre": genre,
      "coverUrl": coverUrl,
      "readingStatus": readingStatus,
      "rating": rating,
      "isPublic": isPublic,
    };
  }

  void toggleVisiblity(bool isPublic) {
    isPublic = isPublic;
    doc?.update({"isPublic": isPublic});
    notifyListeners();
  }

  void toggleRating(int rating) {
    rating = rating;
    doc?.update({"rating": rating});
    notifyListeners();
  }

  void setReadingStatus(String readingStatus) {
    readingStatus = readingStatus;
    doc?.update({"readingStatus": readingStatus});
    notifyListeners();
  }
}
