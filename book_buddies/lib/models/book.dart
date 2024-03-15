import 'package:flutter/material.dart';
import 'note.dart';

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
