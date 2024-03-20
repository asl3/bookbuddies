import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'note.dart';
import 'post.dart';

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
  List<Post> posts = []; // easier to update posts list when updating book

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

  Future<void> loadPosts() async {
    final jsonString = await rootBundle.loadString('jsons/feed.json');
    final data = jsonDecode(jsonString);
    for (var post in data["messages"]) {
      addPost(Post.fromJson(post));
    }
  }

  void addNoteToJournalWithParams(String title, String text) {
    Note note = Note(
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

  void deleteNoteFromJournal(String noteId) {
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

    // Add new post for reading status change
    Post newPost = Post(
      Post.getMessageTypeForBook(this),
      this,
      DateTime.now(),
    );
    addPost(newPost);

    // Notify listeners
    notifyListeners();
  }

  void onUpdateNote() {
    journal.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  void addPost(Post post) {
    post.addListener(notifyListeners);
    posts.add(post);
    notifyListeners();
  }
}
