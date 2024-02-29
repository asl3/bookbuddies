import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'book.dart';
import 'book_detail_views/details.dart';
import 'models.dart';

var logger = Logger();

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  // List<Book> books = [];

  // @override
  // void initState() {
  //   super.initState();
  //   loadBooks();
  // }

  // @override
  // bool get wantKeepAlive => true;

  // Future<void> loadBooks() async {
  //   final jsonString = await rootBundle.loadString('jsons/collection.json');
  //   final data = jsonDecode(jsonString);
  //   setState(() {
  //     // create the books list from the json data
  //     for (var book in data["bookCollection"]) {
  //       books.add(Book.fromJson(book));
  //       for (var note in book['journal']) {
  //         books[books.length - 1].addNoteToJournal(Note.fromJson(note));
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);
    // super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
        ),
        body: SafeArea(
          child: myUser.books.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.count(
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                  childAspectRatio: 0.8,
                  children: List.generate(myUser.books.length, (index) {
                    return GestureDetector(
                        child: ChangeNotifierProvider<Book>.value(
                          value: myUser.books[index],
                          child: BookTile(book: myUser.books[index]),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider<Book>.value(
                                  value: myUser.books[index],
                                  child: const DetailsView(),
                                ),
                              ));
                        });
                  }),
                ),
        ));
  }
}
