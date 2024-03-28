import 'base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book extends BaseSchema {
  String volumeId;
  String title;
  String author;
  String genre;
  String coverUrl;
  String readingStatus;
  int rating;
  bool isPublic;

  Book(
      {required this.volumeId,
      required this.title,
      required this.author,
      required this.genre,
      required this.coverUrl,
      required this.readingStatus,
      required this.rating,
      required this.isPublic,
      super.doc});

  factory Book.fromMap(
      Map<String, dynamic> data, DocumentReference<Map<String, dynamic>>? doc) {
    String volumeId = doc!.id;
    String title = data["title"];
    String author = data["author"];
    String genre = data["genre"];
    String coverUrl = data["coverUrl"];
    String readingStatus = data["readingStatus"];
    int rating = data["rating"];
    bool isPublic = data["isPublic"];

    return Book(
        volumeId: volumeId,
        title: title,
        author: author,
        genre: genre,
        coverUrl: coverUrl,
        readingStatus: readingStatus,
        rating: rating,
        isPublic: isPublic,
        doc: doc);
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
}
