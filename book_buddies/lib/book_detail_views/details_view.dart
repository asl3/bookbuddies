import 'package:flutter/material.dart';
import 'package:book_buddies/models/book.dart';
import 'info_tab.dart';
import 'journal_tab.dart';
import 'package:provider/provider.dart';
import 'forms/add_note_form.dart';

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
                  ));
            },
            tooltip: 'Add Note',
            child: const Icon(Icons.add),
          ),
        ));
  }
}
