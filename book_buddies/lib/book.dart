import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Note extends ChangeNotifier {
  final int noteId;
  String title;
  String text;
  DateTime updatedAt;

  Note(this.noteId, this.title, this.text, this.updatedAt);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(int.parse(json['noteId']), json['title'], json['text'],
        DateTime.parse(json['updatedAt']));
  }

  void editNote(String title, String text) {
    this.title = title;
    this.text = text;
    updatedAt = DateTime.now();
    notifyListeners();
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
    note.addListener(onUpdateNote);
    journal.add(note);
    journal.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  void deleteNoteFromJournal(int noteId) {
    journal.removeWhere((note) => noteId == note.noteId);
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

  void onUpdateNote() {
    journal.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
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
