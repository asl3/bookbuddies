import 'package:flutter/material.dart';
import '../book.dart';
import 'package:provider/provider.dart';

/* ADD NOTE FORM */

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key});

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Book book = Provider.of<Book>(context);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a title';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Note note = Note(
                      book.journal.length + 1,
                      titleController.text,
                      descriptionController.text,
                      DateTime.now()
                    );
                    book.addNoteToJournal(note);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        )
      ),
    );
  }
}

/* EDIT NOTE FORM */

class EditNoteForm extends StatefulWidget {
  const EditNoteForm({super.key});

  @override
  State<EditNoteForm> createState() => _EditNoteFormState();
}

class _EditNoteFormState extends State<EditNoteForm> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Note note = Provider.of<Note>(context);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    titleController.text = note.title;
    descriptionController.text = note.text;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a title';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    note.editNote(
                      titleController.text, 
                      descriptionController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        )
      ),
    );
  }
}
