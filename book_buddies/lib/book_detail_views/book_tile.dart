import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_buddies/models/user.dart';
import 'package:book_buddies/models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context, listen: true);
    final bool contains =
        user.books.where((elt) => elt.volumeId == book.volumeId).isNotEmpty;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            book.coverUrl.isNotEmpty
                ? Image.network(
                    book.coverUrl,
                    height: 60,
                    width: 40,
                  )
                : Container(),
            const SizedBox(height: 8.0),
            Text(
              book.title.length <= 20
                  ? book.title
                  : '${book.title.substring(0, 20)}...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'by ${book.author}',
              style: const TextStyle(fontSize: 14.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                book.rating,
                (index) => const Icon(Icons.star, color: Colors.amber),
              ),
            ),
            const SizedBox(height: 4.0),
            TextButton(
              onPressed: () {
                if (!contains) {
                  user.addBook(book);
                } else {
                  user.deleteBook(book.volumeId);
                }
              },
              child: !contains
                  ? const Text(
                      'ADD TO COLLECTION',
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      'REMOVE FROM COLLECTION',
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
