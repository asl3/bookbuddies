import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<String> data = [
    'apple',
    'banana',
    'cherry',
    'pineapple',
    'kumquat',
    'kiwi',
    'passionfruit',
  ];

  List<String> searchResults = [];

  void lookupQuery(String query) {
    setState(() {
      searchResults = data
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchResults[index]),
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
