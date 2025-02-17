import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'post_tile.dart';
import 'package:provider/provider.dart';
import 'package:book_buddies/models/user.dart';
import 'package:book_buddies/models/post.dart';

var logger = Logger();

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);

    List<PostTile> loadPosts() {
      List<PostTile> posts = [];

      for (Post post in myUser.posts) {
        posts.add(PostTile(post: post, user: myUser));
      }

      for (User friend in myUser.friends) {
        for (Post post in friend.posts) {
          posts.add(PostTile(post: post, user: friend));
        }
      }

      posts.sort((a, b) => b.post.time.compareTo(a.post.time));

      return posts;
    }

    return FutureBuilder<int>(
      future: myUser.updateFeed(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PostTile> posts = loadPosts();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Feed'),
            ),
            body: SafeArea(
              child: PageView(
                children: [
                  FeedScreen(posts: posts),
                  const MapScreen(),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class FeedScreen extends StatelessWidget {
  final List<PostTile> posts;

  const FeedScreen({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);

    Future<void> onRefresh() async {
      await myUser.updateFeed(force: true);
    }

    return RefreshIndicator(
      onRefresh: onRefresh, 
      child: ListView(
        children: posts.isNotEmpty ? List.generate(posts.length, (index) {
          return ChangeNotifierProvider<Post>.value(
            value: posts[index].post,
            child: posts[index],
          );
        }) : const [Center(
          child: Text('Nothing in your feed'),
        )],
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

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
