import 'package:flutter/material.dart';
import 'firestore_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book extends FirestoreModel with ChangeNotifier {
  late String volumeId;
  late String title;
  late String author;
  late String genre;
  late String coverUrl;
  late String readingStatus;
  late int rating;
  late bool isPublic;
  DateTime? finishedAt;

  Book({required super.id}) : super(collection: "books");

  Book.fromArgs({
    required this.volumeId,
    required this.title,
    required this.author,
    required this.genre,
    required this.coverUrl,
    required this.readingStatus,
    required this.rating,
    required this.isPublic,
    required this.finishedAt,
  }) : super(id: null, collection: "books");

  @override
  Future<void> fromMap(Map<String, dynamic> data) async {
    volumeId = doc!.id;
    id = volumeId;
    title = data["title"];
    author = data["author"];
    genre = data["genre"];
    coverUrl = data["coverUrl"];
    readingStatus = data["readingStatus"];
    rating = data["rating"];
    isPublic = data["isPublic"];

    Timestamp? f = data["finishedAt"];
    if (f != null) {
      finishedAt = f.toDate();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "title": title,
      "author": author,
      "genre": genre,
      "coverUrl": coverUrl,
      "readingStatus": readingStatus,
      "rating": rating,
      "isPublic": isPublic,
    };

    if (finishedAt != null) {
      map["finishedAt"] = Timestamp.fromDate(finishedAt!);
    }

    return map;
  }

  void toggleVisiblity(bool isPublic) {
    this.isPublic = isPublic;
    doc?.update({"isPublic": isPublic});
    notifyListeners();
  }

  void toggleRating(int rating) {
    this.rating = rating;
    doc?.update({"rating": rating});
    notifyListeners();
  }

  void setReadingStatus(String readingStatus) {
    this.readingStatus = readingStatus;
    doc?.update({"readingStatus": readingStatus});

    if (readingStatus == "Completed") {
      finishedAt = DateTime.now();
      doc?.update({"finishedAt": Timestamp.fromDate(finishedAt!)});
    }

    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Book && other.volumeId == volumeId;
  }

  @override
  int get hashCode => volumeId.hashCode;
}
