import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'book_detail_views/book_tile.dart';
import 'book_detail_views/details_view.dart';
import 'package:book_buddies/models/user.dart';
import 'package:book_buddies/models/book.dart';

var logger = Logger();

class LibraryPage extends StatefulWidget {
  final User owner; // the owner of the library, may not be self

  const LibraryPage({super.key, required this.owner});

  @override
  LibraryPageState createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    // User myUser = Provider.of<User>(context, listen: true);

    if (widget.owner.books.isEmpty) {
      return const Center(child: Text('Nothing in the library'));
    }

    return GridView.count(
      // physics:
      //     const NeverScrollableScrollPhysics(), // Disable scrolling of GridView
      crossAxisCount: MediaQuery.of(context).orientation ==
              Orientation.portrait
          ? 2
          : 4,
      childAspectRatio: 3 / 4,
      shrinkWrap: true, // Wrap the GridView inside a SizedBox
      children: List.generate(widget.owner.books.length, (index) {
        return GestureDetector(
          child: ChangeNotifierProvider<Book>.value(
            value: widget.owner.books[index],
            child: BookTile(book: widget.owner.books[index]),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<Book>.value(
                  value: widget.owner.books[index],
                  child: DetailsView(owner: widget.owner),
                ),
              ),
            );
          },
        );
      }),
    );

    // return Scaffold(
    //   body: SafeArea(
    //     child: widget.owner.books.isEmpty
    //         ? const Center(child: Text('Nothing in the library'))
    //         : SingleChildScrollView(
    //             child: Column(
    //               children: [
    //                 SizedBox(
    //                   height: MediaQuery.of(context)
    //                       .size
    //                       .height, // Adjust this height as needed
    //                   child: GridView.count(
    //                     physics:
    //                         const NeverScrollableScrollPhysics(), // Disable scrolling of GridView
    //                     crossAxisCount: MediaQuery.of(context).orientation ==
    //                             Orientation.portrait
    //                         ? 2
    //                         : 4,
    //                     childAspectRatio: 3 / 4,
    //                     shrinkWrap: true, // Wrap the GridView inside a SizedBox
    //                     children: List.generate(widget.owner.books.length, (index) {
    //                       return GestureDetector(
    //                         child: ChangeNotifierProvider<Book>.value(
    //                           value: widget.owner.books[index],
    //                           child: BookTile(book: widget.owner.books[index]),
    //                         ),
    //                         onTap: () {
    //                           Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                               builder: (context) =>
    //                                   ChangeNotifierProvider<Book>.value(
    //                                 value: widget.owner.books[index],
    //                                 child: DetailsView(owner: widget.owner),
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                       );
    //                     }),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //   ),
    // );
  }
}
