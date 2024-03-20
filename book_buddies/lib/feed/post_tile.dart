import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../book_detail_views/book_tile.dart';
import 'package:book_buddies/models/book.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/comment.dart';

class PostTile extends StatefulWidget {
  final User user;
  final Post post;

  const PostTile({required this.post, required this.user, super.key}); 

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Icon messageTypeIcon() {
    if (widget.post.messageType == 'reading') {
      return const Icon(Icons.book, color: Colors.orange);
    } else if (widget.post.messageType == 'finished') {
      return const Icon(Icons.check, color: Colors.green);
    } else if (widget.post.messageType == 'added') {
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
                        text: widget.user.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ${widget.post.messageType}',
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  timeDelta(widget.post.time),
                  style: const TextStyle(color: Colors.grey),
                )
              ]),
              const SizedBox(height: 8),
              ChangeNotifierProvider<Book>.value(
                value: widget.post.book,
                child: BookTile(book: widget.post.book),
              ),
              const Divider(),
              Column(
                children: widget.post.comments
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
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Add Comment',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  String text = textController.text;
                  textController.clear();
                  widget.post.addComment(Comment(widget.user, text, DateTime.now()));
                },
              ),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    icon: widget.post.isUserLiking(widget.user.userId) ?
                      const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                    onPressed: () {
                      if (widget.post.isUserLiking(widget.user.userId)) {
                        widget.post.removeLiker(widget.user.userId);
                      } else {
                        widget.post.addLiker(widget.user.userId);
                      }
                    },
                  ),
                  Text('${widget.post.likers.length}')
                ],
              )
            ])));
  }
}
