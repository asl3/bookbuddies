import 'package:flutter/material.dart';

class Note extends ChangeNotifier {
  final int noteId;
  String title;
  String text;
  DateTime updatedAt;

  Note(this.noteId, this.title, this.text, this.updatedAt);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(int.parse(json['noteId']), json['title'], json['text'],
        DateTime.parse(json['updatedAt']));
  }

  void editNote(String title, String text) {
    this.title = title;
    this.text = text;
    updatedAt = DateTime.now();
    notifyListeners();
  }
}
