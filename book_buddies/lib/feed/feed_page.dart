import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'post.dart';

var logger = Logger();

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

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
      body: SafeArea(
        child: PageView(
          children: [
            FeedScreen(posts: posts),
            MapScreen(),
          ],
        ),
      ),
    );
  }
}

class FeedScreen extends StatelessWidget {
  final List<Post> posts;

  const FeedScreen({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: posts.isEmpty
          ? const [Center(child: CircularProgressIndicator())]
          : posts,
    );
  }
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: const Center(
        child: Text('Map Screen'),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:logger/logger.dart';
// import 'post.dart';

// var logger = Logger();

// class FeedPage extends StatefulWidget {
//   const FeedPage({super.key});

//   @override
//   _FeedPageState createState() => _FeedPageState();
// }

// class _FeedPageState extends State<FeedPage> {
//   List<Post> posts = [];

//   @override
//   void initState() {
//     super.initState();
//     loadPosts();
//   }

//   Future<void> loadPosts() async {
//     final jsonString = await rootBundle.loadString('jsons/feed.json');
//     final data = jsonDecode(jsonString);
//     setState(() {
//       for (var post in data["messages"]) {
//         posts.add(Post.fromJson(post));
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Feed'),
//       ),
//       body: SafeArea(
//           child: ListView(
//         children: posts.isEmpty
//             ? const [Center(child: CircularProgressIndicator())]
//             : posts,
//       )),
//     );
//   }
// }
