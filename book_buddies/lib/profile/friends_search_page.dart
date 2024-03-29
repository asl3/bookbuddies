import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_buddies/models/user.dart';
import 'package:provider/provider.dart'; // Import Provider

class FriendsSearchPage extends StatefulWidget {
  const FriendsSearchPage({super.key});

  @override
  _FriendsSearchPageState createState() => _FriendsSearchPageState();
}

class _FriendsSearchPageState extends State<FriendsSearchPage> {
  List<User> searchResults = [];

  void searchFriends(String query) {
    User currentUser = Provider.of<User>(context, listen: false);
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThan: '${query}z')
        .where('email', isNotEqualTo: currentUser.email)
        .get()
        .then((querySnapshot) {
      setState(() {
        searchResults = querySnapshot.docs.map((doc) {
          final user = User(id: doc.id, loadFull: false);
          user.fromMap(doc.data());
          return user;
        }).toList();
      });
    }).catchError((error) {
      print("Failed to search for friends: $error");
      setState(() {
        searchResults = [];
      });
    });
  }

  bool isFriend(User friend, User currentUser) {
    print(friend.email);
    print(currentUser.email);
    return currentUser.friends.contains(friend);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User currentUser = Provider.of<User>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Find Friends'),
      ),
      body: SafeArea(
        child: Column(
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You selected: ${friend.displayName} (${friend.email})'),
                        ),
                      );
                    },
                    trailing: isFriend(friend, currentUser)
                        ? ElevatedButton(
                            onPressed: () {
                              // Remove friend
                              currentUser.removeFriend(friend.userId);
                              friend.removeFriend(currentUser.userId);
                            },
                            child: Text('Remove Friend'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              // Add friend
                              currentUser.addFriend(friend);
                              friend.addFriend(currentUser);
                            },
                            child: Text('Add Friend'),
                          ),
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
