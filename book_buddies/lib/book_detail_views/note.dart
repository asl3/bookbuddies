import 'package:flutter/material.dart';
import '../models.dart';
import 'forms.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    final Note note = Provider.of<Note>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16), 
          child: Text(note.text),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<Note>.value(
                value: note,
                child: const EditNoteForm(),
              ),
            )
          );
        },
        tooltip: 'Edit Note',
        child: const Icon(Icons.edit),
      ),
    );
  }
}

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