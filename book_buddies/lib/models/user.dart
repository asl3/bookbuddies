import 'package:flutter/material.dart';
import 'book.dart';
import 'post.dart';
import 'note.dart';
import 'firestore_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User extends FirestoreModel with ChangeNotifier {
  late AssetImage profilePicture;
  late String displayName;
  late String email;
  late String about;
  late String userId;

  List<Book> books = [];
  List<User> friends = [];
  List<Post> posts = [];
  List<Note> notes = [];

  List<Note> journal(Book book) {
    return notes.where((note) => note.book.id == book.id).toList();
  }

  bool loadFull;
  bool refreshFeed = true;

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

  User({required super.id, required this.loadFull})
      : super(collection: "users");

  @override
  Future<void> fromMap(Map<String, dynamic> data) async {
    // profilePicture = AssetImage(data["profilePicture"]);
    // use default profile picture for now
    profilePicture = const AssetImage("assets/images/blankpfp.webp");
    displayName = data["displayName"];
    email = data["email"];
    about = data["about"];
    userId = doc!.id;

    if (!loadFull) return;

    // restore defaults in case of logout/login
    books.clear();
    friends.clear();
    posts.clear();
    notes.clear();
    refreshFeed = true;

    for (DocumentReference<Map<String, dynamic>> book in data["library"]) {
      Book b = Book(id: book.id);
      await b.loadData();
      b.addListener(notifyListeners);
      books.add(b);
    }

    for (DocumentReference<Map<String, dynamic>> friend in data["friends"]) {
      User u = User(id: friend.id, loadFull: false);
      await u.loadData();
      u.addListener(notifyListeners);
      friends.add(u);
    }

    for (DocumentReference<Map<String, dynamic>> note in data["notes"]) {
      Note n = Note(id: note.id);
      await n.loadData();
      n.addListener(notifyListeners);
      notes.add(n);
    }
  }

  Future<void> refreshPosts(User user) async {
    user.posts.clear(); // Need to pass in user to use native notifyListeners

    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(user.id)
      .get();
    Map<String, dynamic> data = doc.data()!;

    for (DocumentReference<Map<String, dynamic>> post in data['posts']) {
      Post p = Post(id: post.id);
      await p.loadData();
      p.addListener(notifyListeners);
      user.posts.add(p);
    }
  }

  Future<int> updateFeed({bool force = false}) async {
    if (!(force || refreshFeed)) return 0;

    await refreshPosts(this);
    for (User friend in friends) {
      await refreshPosts(friend);
    }

    refreshFeed = false;
    notifyListeners();
    
    return 1;
  }

  // never call .create() on a user object, use CreateUser
  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }

  void setDisplayName(String displayName) {
    this.displayName = displayName;
    doc?.update({"displayName": displayName});
    refreshFeed = true;
    notifyListeners();
  }

  void setAbout(String about) {
    this.about = about;
    doc?.update({"about": about});
    notifyListeners();
  }

  void addBook(Book book) {
    if (!books.contains(book)) {
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
  }

  void deleteBook(String volumeId) {
    books.removeWhere((book) => book.volumeId == volumeId);
    posts.removeWhere((post) => post.book.volumeId == volumeId);
    doc?.update({
      "library": books.map((book) => book.doc).toList(),
    });
    doc?.update({
      "posts": posts.map((post) => post.doc).toList(),
    });
    notifyListeners();
  }

  void addFriend(User friend) {
    if (!friends.contains(friend)) {
      friends.add(friend);
      doc?.update({"friends": friends.map((friend) => friend.doc).toList()});
      refreshFeed = true;
      notifyListeners();
    }
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
