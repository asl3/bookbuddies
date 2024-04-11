import 'package:flutter/material.dart';
import 'forms/edit_note_form.dart';
import 'package:provider/provider.dart';
import 'package:book_buddies/models/note.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key, required this.canEdit});

  final bool canEdit;

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
          child: ListView(
            children: [
              Text(note.text),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.canEdit ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<Note>.value(
                  value: note,
                  child: const EditNoteForm(),
                ),
              ));
        },
        tooltip: 'Edit Note',
        child: const Icon(Icons.edit),
      ) : null,
    );
  }
}
