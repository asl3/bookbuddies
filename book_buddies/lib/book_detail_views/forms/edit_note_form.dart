import 'package:flutter/material.dart';
import 'package:book_buddies/models/note.dart';
import 'package:provider/provider.dart';

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
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    titleController.text = note.title;
    descriptionController.text = note.text;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Note'),
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
              )),
        ));
  }
}
