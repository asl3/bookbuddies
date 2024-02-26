import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'book.dart';

var logger = Logger();

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final jsonString = await rootBundle.loadString('jsons/feed.json');
    final data = jsonDecode(jsonString);
    setState(() {
      for (var post in data["messages"]) {
        posts.add(Post.fromJson(post));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: ListView(
        children: posts.isEmpty
            ? const [Center(child: CircularProgressIndicator())]
            : posts,
      ),
    );
  }
}

class Comment {
  final String username;
  final String comment;
  final DateTime time;

  const Comment(this.username, this.comment, this.time);

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        json['username'], json['comment'], DateTime.parse(json['time']));
  }
}

class Post extends StatelessWidget {
  final String username;
  final String messageType;
  final Book book;
  final DateTime time;
  final List<Comment> comments;

  const Post(
      this.username, this.messageType, this.book, this.time, this.comments,
      {super.key});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        json['username'],
        json['messageType'],
        Book.fromJson(json['book']),
        DateTime.parse(json['time']),
        (json['comments'] as List).map((e) => Comment.fromJson(e)).toList());
  }

  Icon messageTypeIcon() {
    if (messageType == 'reading') {
      return const Icon(Icons.book, color: Colors.orange);
    } else if (messageType == 'finished') {
      return const Icon(Icons.check, color: Colors.green);
    } else if (messageType == 'added') {
      return const Icon(Icons.add, color: Colors.blue);
    } else {
      return const Icon(Icons.error, color: Colors.red);
    }
  }

  String timeDelta(DateTime other) {
    final now = DateTime.now();
    final difference = now.difference(other);

    final seconds = difference.inSeconds;
    if (seconds < 60) {
      return '${seconds}s';
    }

    final minutes = difference.inMinutes;
    if (minutes < 60) {
      return '${minutes}m';
    }

    final hours = difference.inHours;
    if (hours < 24) {
      return '${hours}h';
    }

    final days = difference.inDays;
    if (days < 7) {
      return '${days}d';
    }

    final weeks = (days / 7).round();
    if (weeks < 4) {
      return '${weeks}w';
    }

    final months = (weeks / 4).round();
    if (months < 12) {
      return '${months}mo';
    }

    final years = (months / 12).round();
    return '${years}y';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color.fromRGBO(255, 255, 255, 1),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 12),
                    children: <TextSpan>[
                      TextSpan(
                        text: username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' $messageType',
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  timeDelta(time),
                  style: const TextStyle(color: Colors.grey),
                )
              ]),
              const SizedBox(height: 8),
              ChangeNotifierProvider<Book>.value(
                value: book,
                child: const BookTile(),
              ),
              const Divider(),
              Column(
                children: comments
                    .map((comment) => Card(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(comment.username,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Text(
                                      timeDelta(comment.time),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ]),
                                  Text(comment.comment)
                                ]))))
                    .toList(),
              ),
              const SizedBox(height: 8),
              const TextField(
                  decoration: InputDecoration(
                labelText: 'Add Comment',
                border: OutlineInputBorder(),
              )),
              const Divider(),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Spacer(),
                  Icon(Icons.favorite_border),
                ],
              )
            ])));
  }
}
