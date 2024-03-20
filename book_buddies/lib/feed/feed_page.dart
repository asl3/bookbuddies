import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'post_tile.dart';
import 'package:provider/provider.dart';
import 'package:book_buddies/models/user.dart';
import 'package:book_buddies/models/post.dart';
import 'package:book_buddies/models/book.dart';

var logger = Logger();

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // List<Post> posts = [];

  // @override
  // void initState() {
  //   super.initState();
  //   loadPosts();
  // }

  // Future<void> loadPosts() async {
  //   final jsonString = await rootBundle.loadString('jsons/feed.json');
  //   final data = jsonDecode(jsonString);
  //   setState(() {
  //     for (var post in data["messages"]) {
  //       posts.add(Post.fromJson(post));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);

    List<PostTile> posts = [];

    for (Book book in myUser.books) {
      for (Post post in book.posts) {
        posts.add(PostTile(post: post, user: myUser));
      }
    }

    for (User friend in myUser.friends) {
      for (Book book in friend.books) {
        for (Post post in book.posts) {
          posts.add(PostTile(post: post, user: friend));
        }
      }
    }

    posts.sort((a, b) => b.post.time.compareTo(a.post.time));

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
  final List<PostTile> posts;

  const FeedScreen({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: posts.isEmpty
          ? const [Center(child: CircularProgressIndicator())]
          : List.generate(posts.length, (index) {
            return ChangeNotifierProvider<Post>.value(
              value: posts[index].post,
              child: posts[index],
            );
          }),
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
