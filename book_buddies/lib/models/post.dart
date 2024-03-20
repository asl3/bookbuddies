import 'package:flutter/material.dart';
import 'book.dart';
import 'comment.dart';
import 'user.dart';
import 'package:uuid/uuid.dart';

class Post extends ChangeNotifier {
  final String postId = const Uuid().v4();
  final String messageType;
  final Book book;
  final DateTime time;
  List<Comment> comments = [];
  List<User> likers = [];

  Post(this.messageType, this.book, this.time);

  factory Post.fromJson(Map<String, dynamic> json) {
    Post post = Post(
      json['messageType'],
      Book.fromJson(json['book']),
      DateTime.parse(json['time']),
    );

    // Listen to changes in book!
    post.book.addListener(post.notifyListeners);

    // Add comments
    for (var comment in json['comments']) {
      post.addComment(Comment.fromJson(comment));
    }

    // Add likers
    for (var liker in json['likers']) {
      post.addLiker(User.fromJson(liker));
    }

    return post;
  }

  void addLiker(User user) {
    user.addListener(notifyListeners);
    likers.add(user);
    notifyListeners();
  }

  void removeLiker(String userId) {
    likers.removeWhere((user) => user.userId == userId);
    notifyListeners();
  }

  void addComment(Comment comment) {
    comment.addListener(notifyListeners);
    comments.add(comment);
    notifyListeners();
  }

  static String getMessageTypeForBook(Book book) {
    switch (book.readingStatus) {
      case 'Unread':
        return 'added';
      case 'Reading':
        return 'started';
      case 'Completed':
        return 'finished';
      default:
        throw ArgumentError("Invalid reading status");
    }
  }
}