import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'book.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

/* DETAILS VIEW */

class DetailsView extends StatefulWidget {
  const DetailsView({super.key});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    final Book book = Provider.of<Book>(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(book.title),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Info',
                  icon: Icon(Icons.info),
                ),
                Tab(text: 'Journal', icon: Icon(Icons.notes)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              InfoTab(book: book),
              JournalTab(book: book),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider<Book>.value(
                    value: book,
                    child: const AddNoteForm(),
                  ),
                )
              );
            },
            tooltip: 'Add Note',
            child: const Icon(Icons.add),
          ),
        ));
  }
}

/* INFO TAB */

class InfoTab extends StatefulWidget {
  const InfoTab({super.key, required this.book});

  final Book book;

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            children: [
              const Center(
                child: Text(
                  'Author',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    widget.book.author,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Center(
                child: Text(
                  'Genre',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    widget.book.genre,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Center(
                child: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    widget.book.readingStatus,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Center(
                child: Text(
                  'Visibility',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: ToggleSwitch(
                    initialLabelIndex: widget.book.isPublic ? 0 : 1,
                    totalSwitches: 2,
                    activeBgColors: const [[Colors.green], [Colors.red]],
                    labels: const ['Public', 'Private'],
                    onToggle: (index) {
                      widget.book.toggleVisiblity(index == 0);
                    },
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Center(
                heightFactor: 2,
                child: Text(
                  'Rating',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: widget.book.rating.toDouble(),
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 30,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    widget.book.toggleRating(rating.toInt());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* JOURNAL TAB */

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
          // child: ChangeNotifierProvider<Note>.value(
          //   value: widget.book.journal[index],
          //   child: const NoteTile(),
          // ),
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

/* NOTE TILE */

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

/* NOTE VIEW */

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
