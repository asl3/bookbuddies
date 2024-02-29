import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';

// class Note extends ChangeNotifier {
//   final int noteId;
//   String title;
//   String text;
//   DateTime updatedAt;

//   Note(this.noteId, this.title, this.text, this.updatedAt);

//   factory Note.fromJson(Map<String, dynamic> json) {
//     return Note(int.parse(json['noteId']), json['title'], json['text'],
//         DateTime.parse(json['updatedAt']));
//   }

//   void editNote(String title, String text) {
//     this.title = title;
//     this.text = text;
//     updatedAt = DateTime.now();
//     notifyListeners();
//   }
// }

// class Book extends ChangeNotifier {
//   final String volumeId;
//   final String title;
//   final String author;
//   final String genre;
//   final String coverUrl;
//   String readingStatus;
//   int rating;
//   bool isPublic;
//   List<Note> journal = [];

//   Book(this.volumeId, this.title, this.author, this.genre, this.coverUrl,
//       this.readingStatus, this.rating, this.isPublic);

//   factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//         json['volumeId'],
//         json['title'],
//         json['author'],
//         json['genre'],
//         json['smallThumbnail'],
//         json['readingStatus'],
//         json['rating'],
//         json['isPublic']);
//   }

//   void addNoteToJournalWithParams(String title, String text) {
//     int noteId =
//         journal.reduce((a, b) => a.noteId > b.noteId ? a : b).noteId + 1;
//     Note note = Note(
//       noteId,
//       title,
//       text,
//       DateTime.now(),
//     );
//     addNoteToJournal(note);
//   }

//   void addNoteToJournal(Note note) {
//     note.addListener(onUpdateNote);
//     journal.add(note);
//     journal.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
//     notifyListeners();
//   }

//   void deleteNoteFromJournal(int noteId) {
//     journal.removeWhere((note) => noteId == note.noteId);
//     notifyListeners();
//   }

//   void toggleVisiblity(bool isPublic) {
//     this.isPublic = isPublic;
//     notifyListeners();
//   }

//   void toggleRating(int rating) {
//     this.rating = rating;
//     notifyListeners();
//   }

//   void updateReadingStatus(String readingStatus) {
//     this.readingStatus = readingStatus;
//     notifyListeners();
//   }

//   void onUpdateNote() {
//     journal.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
//     notifyListeners();
//   }
// }

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context, listen: true);
    final bool contains = user.books.where((elt) => elt.volumeId == book.volumeId).isNotEmpty;

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
              book.title,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
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
              child: !contains ? 
                const Text(
                  'ADD TO COLLECTION', 
                  textAlign: TextAlign.center,
                ) : 
                const Text(
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
