import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'book.dart';

/* DETAILS VIEW */

class DetailsView extends StatefulWidget {
  const DetailsView({super.key});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    final Book book = ModalRoute.of(context)!.settings.arguments as Book;

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
              Tab(
                text: 'Journal',
                icon: Icon(Icons.notes)
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InfoTab(book: book),
            JournalTab(journal: book.journal),
          ],
        ),
      )
    );
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
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Info',
              style: Theme.of(context).textTheme.headlineLarge
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Table(
              children: [
                TableRow(
                  children: [
                    const Center(
                      child: Text(
                        'Author',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ),
                    Center(
                      child: Text(
                        widget.book.author, 
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
                    Center(
                      child: Text(
                        widget.book.genre,
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
                    Center(
                      child: Text(
                        widget.book.readingStatus,
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
                    Center(
                      child: Text(
                        widget.book.visibility,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Center(
                      child: Text(
                        'Rating',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.book.rating > 0 ?
                        List.generate(
                          widget.book.rating,
                          (index) => const Icon(Icons.star, color: Colors.amber),
                        ) : const [
                          Text('Not yet rated'),
                        ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* JOURNAL TAB */

class JournalTab extends StatefulWidget {
  const JournalTab({super.key, required this.journal});

  final List<Note> journal;

  @override
  State<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Journal',
              style: Theme.of(context).textTheme.headlineLarge
            )
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.journal.length,
              itemBuilder: (context, index) => GestureDetector(
                child: ListTile(
                  title: Text(widget.journal[index].title),
                  subtitle: Text(DateFormat().format(widget.journal[index].creation)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NoteView(),
                      settings: RouteSettings(arguments: widget.journal[index]),
                    ),
                  );
                }
              ),
            ),
          ),
        ],
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
    final Note note = ModalRoute.of(context)!.settings.arguments as Note;

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Text(DateFormat().format(note.creation)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(note.text),
      ),
    );
  }
}
