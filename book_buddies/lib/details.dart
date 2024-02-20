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
              JournalTab(journal: book.journal),
            ],
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
    return Center(
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Info',
                  style: Theme.of(context).textTheme.headlineLarge)),
          Padding(
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
              child: Text('Journal',
                  style: Theme.of(context).textTheme.headlineLarge)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.journal.length,
              itemBuilder: (context, index) => GestureDetector(
                  child: ListTile(
                    title: Text(widget.journal[index].title),
                    subtitle: Text(
                        DateFormat('yMd').format(widget.journal[index].creation)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NoteView(),
                        settings:
                            RouteSettings(arguments: widget.journal[index]),
                      ),
                    );
                  }),
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
        centerTitle: true,
      ),
      body: Center(
        child: Text(note.text),
      ),
    );
  }
}
