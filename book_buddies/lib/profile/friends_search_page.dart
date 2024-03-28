import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_buddies/models/user.dart';

class FriendsSearchPage extends StatefulWidget {
  const FriendsSearchPage({Key? key}) : super(key: key);

  @override
  _FriendsSearchPageState createState() => _FriendsSearchPageState();
}

class _FriendsSearchPageState extends State<FriendsSearchPage> {
  List<User> searchResults = [];

  void searchFriends(String query) {
    FirebaseFirestore.instance
        .collection('users')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThan: query + 'z')
        .get()
        .then((querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs
            .map((doc) => User.fromMap(doc.data(), doc.reference))
            .toList();
      });
    }).catchError((error) {
      print("Failed to search for friends: $error");
      setState(() {
        searchResults = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Find Friends'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: searchFriends,
                decoration: InputDecoration(
                  labelText: 'Search for friends',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final friend = searchResults[index];
                  return ListTile(
                    title: Text(friend.displayName),
                    subtitle: Text(friend.email),
                    // You can add more information here like profile picture, etc.
                    onTap: () {
                      // Handle friend selection (e.g., add friend to the user's friend list)
                      // This could involve updating database records, etc.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('You selected: ${friend.displayName}')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
