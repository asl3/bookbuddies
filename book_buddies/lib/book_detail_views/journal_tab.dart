import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_buddies/models/book.dart';
import 'package:book_buddies/models/note.dart';
import 'note_view.dart';
import 'note_tile.dart';
import 'package:book_buddies/models/user.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({super.key, required this.book});

  final Book book;

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);
    List<Note> journal = myUser.journal(widget.book);

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: journal.length,
      itemBuilder: (context, index) => GestureDetector(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<Note>.value(value: journal[index]),
              ChangeNotifierProvider<Book>.value(value: widget.book),
            ],
            child: const NoteTile(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<Note>.value(
                  value: journal[index],
                  child: const NoteView(),
                ),
              ),
            );
          }),
    );
  }
}
