import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'book.dart';
import 'book_detail_views/details.dart';

var logger = Logger();

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with AutomaticKeepAliveClientMixin {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> loadBooks() async {
    final jsonString = await rootBundle.loadString('jsons/collection.json');
    final data = jsonDecode(jsonString);
    setState(() {
      // create the books list from the json data
      for (var book in data["bookCollection"]) {
        books.add(Book.fromJson(book));
        for (var note in book['journal']) {
          books[books.length - 1].addNoteToJournal(Note.fromJson(note));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
      ),
      body: books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2,
              children: List.generate(books.length, (index) {
                return GestureDetector(
                    child: ChangeNotifierProvider<Book>.value(
                      value: books[index],
                      child: BookTile(book: books[index]),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<Book>.value(
                              value: books[index],
                              child: const DetailsView(),
                            ),
                          ));
                    });
              }),
            ),
    );
  }
}
