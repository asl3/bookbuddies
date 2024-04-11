import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_buddies/models/book.dart';
import 'package:book_buddies/models/note.dart';
import 'note_view.dart';
import 'note_tile.dart';
import 'package:book_buddies/models/user.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({super.key, required this.book, required this.owner});

  final Book book;
  final User owner;

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);

    List<Note> journal = widget.owner.journal(widget.book);
    final bool isCurrentOwner = myUser == widget.owner;

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
                  child: NoteView(canEdit: isCurrentOwner),
                ),
              ),
            );
          }),
    );
  }
}
