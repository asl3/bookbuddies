import 'package:flutter/material.dart';
import 'package:book_buddies/models/book.dart';
import 'package:book_buddies/models/note.dart';
import 'package:provider/provider.dart';

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
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Note'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
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
                    padding: const EdgeInsets.all(16),
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
                        if (formKey.currentState!.validate()) {
                          Note note = Note(
                              book.journal.length + 1,
                              titleController.text,
                              descriptionController.text,
                              DateTime.now());
                          book.addNoteToJournal(note);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              )),
        ));
  }
}
