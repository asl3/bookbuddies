import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'book.dart';

var logger = Logger();

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  
  Future<void> loadBooks() async { 
    final jsonString = await rootBundle.loadString('jsons/collection.json');
    final data = jsonDecode(jsonString);
    logger.d(data);
    setState(() { 
      // create the books list from the json data
      for (var book in data["bookCollection"]) {
        books.add(Book.fromJson(book));
      }
    });  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
      ),
      body: books.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 2,
              children: List.generate(books.length, (index) {
                return BookTile(book: books[index]);
              }),
            ),
    );
  }
}
