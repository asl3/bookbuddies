import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'book_detail_views/book_tile.dart';
import 'book_detail_views/details_view.dart';
import 'package:book_buddies/models/user.dart';
import 'package:book_buddies/models/book.dart';

var logger = Logger();

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
        ),
        body: SafeArea(
          child: myUser.books.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.count(
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 2
                          : 4,
                  childAspectRatio: 3 / 4,
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
