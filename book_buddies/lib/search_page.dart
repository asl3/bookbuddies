import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:provider/provider.dart';
import 'book_detail_views/book_tile.dart' as local_book_tile;
import 'models/book.dart' as models;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Book> searchResults = [];

  void lookupQuery(String query) async {
    try {
      List<Book> results = await const GoogleBooksApi().searchBooks(
        query,
        maxResults: 20,
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
      );

      setState(() {
        searchResults = results;
      });
    } catch (_) {
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final models.User myUser = Provider.of<models.User>(context, listen: true);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          SearchBar(
              onQueryChanged:
                  lookupQuery), // callback to update state once search is entered
          Expanded(
            child: searchResults.isEmpty
                ? const Center(
                    child: Text('No search results found'),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      Uri link = searchResults[index]
                              .volumeInfo
                              .imageLinks?["thumbnail"] ??
                          Uri.parse(
                              "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg");
                      models.Book currBook = models.Book.fromArgs(
                          volumeId: searchResults[index].id,
                          title: searchResults[index].volumeInfo.title,
                          author: searchResults[index]
                                  .volumeInfo
                                  .authors
                                  .firstOrNull ??
                              "Unknown",
                          genre: searchResults[index]
                                  .volumeInfo
                                  .categories
                                  .firstOrNull ??
                              "Unknown",
                          coverUrl: link.toString(),
                          readingStatus:
                              "Unread", // TODO: use profile info to make this accurate
                          rating: searchResults[index]
                              .volumeInfo
                              .averageRating
                              .round(),
                          isPublic: true,
                          finishedAt: null);
                      return ChangeNotifierProvider<models.Book>.value(
                        value: currBook,
                        child: local_book_tile.BookTile(book: currBook),
                      ); // Don't allow access to details until user adds book to collection
                    },
                  ),
          ),
        ],
      ),
    ));
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onQueryChanged;
  const SearchBar({super.key, required this.onQueryChanged});
  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  String query = '';
  final _debouncer = Debouncer(milliseconds: 500);

  void updateQuery(String newQuery) {
    setState(() {
      query = newQuery;
    });
    _debouncer.run(() {
      widget.onQueryChanged(newQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: updateQuery,
        decoration: const InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

/* 
  Search functionality will use the Google Books API.
  When the user searches for a book, there will be an API query made for a 
  volume with the search terms.
  API Key: AIzaSyDqtBQsYDmTHXK-vKYXqRN1l89ua8pfmpU
*/