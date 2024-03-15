import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'book.dart';
import 'note.dart';

class User extends ChangeNotifier {
  final AssetImage profilePicture;
  String fullName;
  String displayName;
  String email;
  String about;
  List<Book> books = [];

  User({
    required this.profilePicture,
    required this.fullName,
    required this.displayName,
    required this.email,
    required this.about,
  });

  Future<void> loadBooks() async {
    final jsonString = await rootBundle.loadString('jsons/collection.json');
    final data = jsonDecode(jsonString);
    for (var book in data["bookCollection"]) {
      addBook(Book.fromJson(book));
      for (var note in book['journal']) {
        books[books.length - 1].addNoteToJournal(Note.fromJson(note));
      }
    }
  }

  void setDisplayName(String displayName) {
    this.displayName = displayName;
    notifyListeners();
  }

  void setFullName(String fullName) {
    this.fullName = fullName;
    notifyListeners();
  }

  void setAbout(String about) {
    this.about = about;
    notifyListeners();
  }

  void addBook(Book book) {
    book.addListener(notifyListeners);
    books.add(book);
    books.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  void deleteBook(String volumeId) {
    books.removeWhere((book) => book.volumeId == volumeId);
    notifyListeners();
  }
}

class UserPreferences {
  static final User myUser = User(
    profilePicture: const AssetImage('assets/images/blankpfp.webp'),
    fullName: 'Name',
    displayName: 'ireadbooks123',
    email: 'example@umd.edu',
    about: "I'm currently reading The Great Gatsby!",
  );
}
