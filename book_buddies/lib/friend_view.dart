import 'package:flutter/material.dart';
import 'package:book_buddies/models/user.dart';
import './library_page.dart';

class FriendView extends StatefulWidget {
  final User owner; // the owner of the library, may not be self

  const FriendView({super.key, required this.owner});

  @override
  FriendViewState createState() => FriendViewState();
}

class FriendViewState extends State<FriendView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: widget.owner.loadLibrary(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.owner.displayName),
              centerTitle: true,
            ),
            body: LibraryPage(owner: widget.owner),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}