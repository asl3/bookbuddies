import 'package:flutter/material.dart';
import 'package:book_buddies/models/user.dart';
import 'package:provider/provider.dart';
import 'friends_search_page.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);
    print(user.friends.map((e) => e.displayName));
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Friends',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: user.friends.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(user.friends[index].displayName),
                  );
                },
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendsSearchPage()),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
