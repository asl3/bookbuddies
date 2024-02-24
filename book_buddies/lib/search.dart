import 'package:book_buddies/book_detail_views/details.dart';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:provider/provider.dart';
import 'book.dart' as local_book;
import 'package:google_books_api/src/models/book.dart' as google_book;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Book> searchResults = [];

  void lookupQuery(String query) async {
    List<Book> results = await GoogleBooksApi().searchBooks(
      query,
      maxResults: 20,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      local_book.Book curr_book = local_book.Book(
                          searchResults[index].id,
                          searchResults[index].volumeInfo.title,
                          searchResults[index].volumeInfo.authors.first,
                          searchResults[index].volumeInfo.categories.first,
                          link.toString(),
                          "Unread", // TODO: use profile info to make this accurate
                          searchResults[index].volumeInfo.averageRating.toInt(),
                          true);
                      return GestureDetector(
                        child: ChangeNotifierProvider<local_book.Book>.value(
                          value: curr_book,
                          child: local_book.BookTile(book: curr_book),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider<
                                    local_book.Book>.value(
                                  value: curr_book,
                                  child: const DetailsView(),
                                ),
                              ));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
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

  void updateQuery(String newQuery) {
    setState(() {
      query = newQuery;
    });
    widget.onQueryChanged(newQuery);
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

/* 
  Search functionality will use the Google Books API.
  When the user searches for a book, there will be an API query made for a 
  volume with the search terms.
  API Key: AIzaSyDqtBQsYDmTHXK-vKYXqRN1l89ua8pfmpU
*/
