import 'package:flutter/material.dart';
// import 'book.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Note extends ChangeNotifier {
  final int noteId;
  String title;
  String text;
  DateTime updatedAt;

  Note(this.noteId, this.title, this.text, this.updatedAt);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(int.parse(json['noteId']), json['title'], json['text'],
        DateTime.parse(json['updatedAt']));
  }

  void editNote(String title, String text) {
    this.title = title;
    this.text = text;
    updatedAt = DateTime.now();
    notifyListeners();
  }
}

class Book extends ChangeNotifier {
  final String volumeId;
  final String title;
  final String author;
  final String genre;
  final String coverUrl;
  String readingStatus;
  int rating;
  bool isPublic;
  List<Note> journal = [];

  Book(this.volumeId, this.title, this.author, this.genre, this.coverUrl,
      this.readingStatus, this.rating, this.isPublic);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        json['volumeId'],
        json['title'],
        json['author'],
        json['genre'],
        json['smallThumbnail'],
        json['readingStatus'],
        json['rating'],
        json['isPublic']);
  }

  void addNoteToJournalWithParams(String title, String text) {
    int noteId =
        journal.reduce((a, b) => a.noteId > b.noteId ? a : b).noteId + 1;
    Note note = Note(
      noteId,
      title,
      text,
      DateTime.now(),
    );
    addNoteToJournal(note);
  }

  void addNoteToJournal(Note note) {
    note.addListener(onUpdateNote);
    journal.add(note);
    journal.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  void deleteNoteFromJournal(int noteId) {
    journal.removeWhere((note) => noteId == note.noteId);
    notifyListeners();
  }

  void toggleVisiblity(bool isPublic) {
    this.isPublic = isPublic;
    notifyListeners();
  }

  void toggleRating(int rating) {
    this.rating = rating;
    notifyListeners();
  }

  void updateReadingStatus(String readingStatus) {
    this.readingStatus = readingStatus;
    notifyListeners();
  }

  void onUpdateNote() {
    journal.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }
}

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
    profilePicture:
        const AssetImage('assets/images/blankpfp.webp'),
    fullName: 'Name',
    displayName: 'ireadbooks123',
    email: 'example@umd.edu',
    about: "I'm currently reading The Great Gatsby!",
  );
}

class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 200, 200);
  }

  @override
  bool shouldReclip(oldClipper) {
    return true;
  }
}