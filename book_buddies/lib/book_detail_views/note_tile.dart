import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:book_buddies/models/note.dart';
import 'package:book_buddies/models/user.dart';

class NoteTile extends StatelessWidget {
  final bool canDelete;

  const NoteTile({super.key, required this.canDelete});

  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);

    return Consumer<Note>(
      builder: (context, state, child) => ListTile(
        title: Text(state.title),
        subtitle: Text(DateFormat('yMd').format(state.updatedAt)),
        trailing: canDelete ? IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            myUser.deleteNoteFromJournal(state.id!);
          },
        ) : null,
      ),
    );
  }
}
