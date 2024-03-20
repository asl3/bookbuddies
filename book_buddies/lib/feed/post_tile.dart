import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../book_detail_views/book_tile.dart';
import 'package:book_buddies/models/book.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/comment.dart';

class PostTile extends StatelessWidget {
  final User user;
  final Post post;

  const PostTile({required this.post, required this.user, super.key});

  Icon messageTypeIcon() {
    if (post.messageType == 'reading') {
      return const Icon(Icons.book, color: Colors.orange);
    } else if (post.messageType == 'finished') {
      return const Icon(Icons.check, color: Colors.green);
    } else if (post.messageType == 'added') {
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
                        text: user.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ${post.messageType}',
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  timeDelta(post.time),
                  style: const TextStyle(color: Colors.grey),
                )
              ]),
              const SizedBox(height: 8),
              ChangeNotifierProvider<Book>.value(
                value: post.book,
                child: BookTile(book: post.book),
              ),
              const Divider(),
              Column(
                children: post.comments
                    .map((comment) => ChangeNotifierProvider<Comment>.value(
                      value: comment,
                      child:  Card(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(comment.user.displayName,
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
                    )
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
