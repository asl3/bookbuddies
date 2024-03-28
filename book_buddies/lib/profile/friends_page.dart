import 'package:flutter/material.dart';
import 'package:book_buddies/models/user.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: Center(
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
                  String name = 
                  return ListTile(
                    title: Text("Friend 1"),
                    // You can add more information here like profile picture, etc.
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a page where users can search for new friends
          // You can implement this as per your application flow
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
