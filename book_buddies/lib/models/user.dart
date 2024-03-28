import 'package:flutter/material.dart';
import 'book.dart';
import 'post.dart';
import 'note.dart';
import 'firestore_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../schemas/user.dart' as schemas;

class User extends FirestoreModel<schemas.User> with ChangeNotifier {
  List<Book> books = [];
  List<User> friends = [];
  List<Post> posts = [];
  List<Note> notes = [];

  static createUser(auth.User? user, String email, String displayName) {
    FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
      "username": user.displayName ?? email,
      "email": email,
      "preferences": {
        "theme": "dark",
        "notification": {"email": true, "push": false},
        "displayOptions": {"sortBy": "author", "viewMode": "list"}
      },
      "profilePicture": user.photoURL ?? "",
      "displayName": displayName,
      "about": "",
      "friends": [],
      "library": [],
      "posts": [],
      "notes": [],
    });
  }

  User({required super.id})
      : super(collection: "users", creator: schemas.User.fromMap);

  factory User.fromInfo(schemas.User value) {
    var model = User(id: null);
    model.value = value;
    return model;
  }

  // AssetImage get profilePicture => value.profilePicture; // todo
  AssetImage get profilePicture =>
      const AssetImage("assets/images/blankpfp.webp");
  String get displayName => value.displayName;
  String get email => value.email;
  String get about => value.about;
  String get userId => value.userId;
  List<Note> journal(Book book) {
    return notes.where((note) => note.book.id == book.id).toList();
  }

  loadFull({bool deep = false}) {
    if (id == null) return;
    FirebaseFirestore db = FirebaseFirestore.instance;
    doc = db.collection("users").doc(id);
    doc?.get().then((event) {
      Map<String, dynamic> data = event.data()!;

      for (DocumentReference<Map<String, dynamic>> book in data["library"]) {
        Book b = Book(id: book.id);
        b.addListener(notifyListeners);
        books.add(b);
      }

      for (DocumentReference<Map<String, dynamic>> friend in data["friends"]) {
        User u = User(id: friend.id);
        u.addListener(notifyListeners);
        if (!deep) u.loadFull(deep: true); // prevent recursion
        friends.add(u);
      }

      for (DocumentReference<Map<String, dynamic>> post in data["posts"]) {
        Post p = Post(id: post.id);
        p.addListener(notifyListeners);
        posts.add(p);
      }

      for (DocumentReference<Map<String, dynamic>> note in data["notes"]) {
        Note n = Note(id: note.id);
        n.addListener(notifyListeners);
        notes.add(n);
      }

      notifyListeners();
    });
  }

  void setDisplayName(String displayName) {
    value.displayName = displayName;
    doc?.update({"username": displayName});
    notifyListeners();
  }

  void setAbout(String about) {
    value.about = about;
    doc?.update({"about": about});
    notifyListeners();
  }

  void addBook(Book book) {
    book.create();
    book.addListener(notifyListeners);
    Post newPost = Post.fromArgs(
        messageType: Post.getMessageTypeForBook(book),
        book: book,
        comments: [],
        time: DateTime.now(),
        likers: []);
    addPost(newPost);
    books.add(book);
    books.sort((a, b) => a.title.compareTo(b.title));
    doc?.update({
      "library": books.map((book) => book.doc).toList(),
    });
    notifyListeners();
  }

  void deleteBook(String volumeId) {
    books.removeWhere((book) => book.volumeId == volumeId);
    doc?.update({
      "library": books.map((book) => book.doc).toList(),
    });
    notifyListeners();
  }

  void addFriend(User friend) {
    friend.addListener(notifyListeners);
    friends.add(friend);
    doc?.update({"friends": friends.map((friend) => friend.doc).toList()});
    notifyListeners();
  }

  void removeFriend(String userId) {
    friends.removeWhere((friend) => friend.userId == userId);
    doc?.update({"friends": friends.map((friend) => friend.doc).toList()});
    notifyListeners();
  }

  void addNoteToJournalWithParams(String title, String text, Book book) {
    Note note = Note.fromArgs(
        title: title, text: text, updatedAt: DateTime.now(), book: book);
    addNoteToJournal(note);
  }

  void addNoteToJournal(Note note) {
    note.create();
    note.addListener(onUpdateNote);
    notes.add(note);
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    doc?.update({"notes": notes.map((note) => note.doc).toList()});
    notifyListeners();
  }

  void deleteNoteFromJournal(String noteId) {
    notes.removeWhere((note) => noteId == note.id);
    doc?.update({"notes": notes.map((note) => note.doc).toList()});
    notifyListeners();
  }

  void updateReadingStatus(String readingStatus, Book book) {
    book.setReadingStatus(readingStatus);

    // Add new post for reading status change
    Post newPost = Post.fromArgs(
      messageType: Post.getMessageTypeForBook(book),
      book: book,
      time: DateTime.now(),
      comments: [],
      likers: [],
    );
    addPost(newPost);

    // Notify listeners
    notifyListeners();
  }

  void onUpdateNote() {
    notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  void addPost(Post post) {
    post.create();
    post.addListener(notifyListeners);
    posts.add(post);
    doc?.update({"posts": posts.map((post) => post.doc).toList()});
    notifyListeners();
  }
}
