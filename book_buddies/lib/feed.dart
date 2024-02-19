import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

var logger = Logger();

class FeedPage extends StatefulWidget {
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

class Post extends StatelessWidget {
  final String username;
  final String messageType;
  final String book;
  final DateTime time;

  const Post(this.username, this.messageType, this.book, this.time,
      {super.key});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(json['username'], json['messageType'], json['book'],
        DateTime.parse(json['time']));
  }

  Icon messageTypeIcon() {
    if (messageType == 'reading') {
      return Icon(Icons.book);
    } else if (messageType == 'finished') {
      return Icon(Icons.check);
    } else if (messageType == 'added') {
      return Icon(Icons.add);
    } else {
      return Icon(Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: messageTypeIcon(),
            title: Text('$username $messageType $book'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy').format(time),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
