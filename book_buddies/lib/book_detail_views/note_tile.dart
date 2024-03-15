import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:book_buddies/models/note.dart';
import 'package:book_buddies/models/book.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({super.key});

  @override
  Widget build(BuildContext context) {
    final Book book = Provider.of<Book>(context, listen: true);

    return Consumer<Note>(
      builder: (context, state, child) => ListTile(
        title: Text(state.title),
        subtitle: Text(DateFormat('yMd').format(state.updatedAt)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            book.deleteNoteFromJournal(state.noteId);
          },
        ),
      ),
    );
  }
}
