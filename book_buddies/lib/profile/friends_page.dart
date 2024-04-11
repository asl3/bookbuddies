import 'package:flutter/material.dart';
import 'package:book_buddies/models/user.dart';
import 'package:provider/provider.dart';
import 'friends_search_page.dart';
import '../friend_view.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

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
        title: const Text('Friends'),
      ),
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Friends',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: user.friends.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(user.friends[index].email),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendView(owner: user.friends[index])
                        ),
                      );
                    }
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
            MaterialPageRoute(builder: (context) => const FriendsSearchPage()),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
