import 'package:flutter/material.dart';

class Book {
  final int bookId;
  final String title;
  final String author;
  final String genre;
  final String readingStatus;
  final int rating;

  Book(this.bookId, this.title, this.author, this.genre, this.readingStatus,
      this.rating);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(int.parse(json['bookId']), json['title'], json['author'],
        json['genre'], json['readingStatus'], json['rating']);
  }
}

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'by ${book.author}',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: List.generate(
                book.rating,
                (index) => const Icon(Icons.star, color: Colors.amber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
