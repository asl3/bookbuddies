import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../book.dart';
import 'note.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({super.key, required this.book});

  final Book book;

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.book.journal.length,
      itemBuilder: (context, index) => GestureDetector(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<Note>.value(value: widget.book.journal[index]),
              ChangeNotifierProvider<Book>.value(value: widget.book),
            ],
            child: const NoteTile(),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<Note>.value(
                  value: widget.book.journal[index],
                  child: const NoteView(),
                ),
              ),
            );
          }),
    );
  }
}
