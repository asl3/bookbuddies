import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Note {
  final int noteId;
  final String title;
  final String text;
  final DateTime creation;

  Note(this.noteId, this.title, this.text, this.creation);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(int.parse(json['noteId']), json['title'], json['text'],
        DateTime.parse(json['creation']));
  }
}

class Book extends ChangeNotifier {
  final int bookId;
  final String title;
  final String author;
  final String genre;
  final String readingStatus;
  int rating;
  bool isPublic;
  List<Note> journal = [];

  Book(this.bookId, this.title, this.author, this.genre, this.readingStatus,
      this.rating, this.isPublic);

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      int.parse(json['bookId']),
      json['title'],
      json['author'],
      json['genre'],
      json['readingStatus'],
      json['rating'],
      json['isPublic']
    );
  }

  void addNoteToJournal(Note note) {
    journal.add(note);
    notifyListeners();
  }

  void toggleVisiblity(bool isPublic) {
    this.isPublic = isPublic;
    notifyListeners();
  }

  void toggleRating(int rating) {
    this.rating = rating;
    notifyListeners();
  }
}

class BookTile extends StatelessWidget {
  const BookTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<Book>(
          builder: (context, state, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'by ${state.author}',
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: List.generate(
                  state.rating,
                  (index) => const Icon(Icons.star, color: Colors.amber),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
