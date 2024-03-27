import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'book.dart';
import 'note.dart';
import 'post.dart';
import 'package:uuid/uuid.dart';

class User extends ChangeNotifier {
  final AssetImage profilePicture;
  final String userId = const Uuid().v4();
  String fullName;
  String displayName;
  String email;
  String about;
  List<Book> books = [];
  List<User> friends = [];

  User({
    required this.profilePicture,
    required this.fullName,
    required this.displayName,
    required this.email,
    required this.about,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    User myUser = User(
      profilePicture: AssetImage(json['profilePicture']),
      fullName: json['fullName'],
      displayName: json['username'],
      email: json['email'],
      about: json['about']
    );

    // Add friends
    for (var friend in json['friends']) {
      myUser.addFriend(User.fromJson(friend));
    }

    return myUser;
  }

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
    Post newPost = Post(Post.getMessageTypeForBook(book), book, DateTime.now());
    book.addPost(newPost);
    books.add(book);
    books.sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  void deleteBook(String volumeId) {
    books.removeWhere((book) => book.volumeId == volumeId);
    notifyListeners();
  }

  void addFriend(User friend) {
    friend.addListener(notifyListeners);
    friends.add(friend);
    notifyListeners();
  }

  void removeFriend(String userId) {
    friends.removeWhere((friend) => friend.userId == userId);
    notifyListeners();
  }
}
